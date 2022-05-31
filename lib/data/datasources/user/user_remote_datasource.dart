import 'package:clean_login/core/errors/exceptions.dart';
import 'package:clean_login/core/errors/typeError.dart';
import 'package:clean_login/core/preferences/preferences.dart';
import 'package:clean_login/data/datasources/class_abstract/user_remote_datasource.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';


@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore db;
   late final _preferences = getIt<Preferences>();
  UserRemoteDataSourceImpl({required this.auth, required this.db});

  Future<User> user( String email, String password) async {
    UserCredential result = await this
        .auth
        .createUserWithEmailAndPassword(email: email, password: password);
    return result.user!;
  }

  Future<User> userL(String email, String password) async {
    UserCredential result = await this
        .auth
        .signInWithEmailAndPassword(email: email, password: password);
    return result.user!;
  }

  @override
  Future<UserModel> requestUserLogin(String email, String password) async {
    try {
      final userUid = await this.userL(email, password);
      
      // print("============================0");
      // print(userUid.getIdToken().then((value) => value.toString()));

      if (userUid.uid != '') {
        final rUser = await this
            .db
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        return (rUser.docs.map((e) {
          if (e.exists) {
            _preferences.setAuthToken(userUid.uid);
            return UserModel.fromJson(e.data());
          } else {
            throw ServerException('El usuario no existe');
          }
        })).first;
      } else {
        throw ServerException('El usuario no existe');
      }
    } catch (e) {
      throw ServerException(error("$e"));
    }
  }

  @override
  Future<UserModel> requestUserRegister(UserModel user) async {
    try {
      final userUid = await this.user(user.email, user.password);

      final userData = UserModel(
          id: userUid.uid,
          usuario: user.usuario,
          status: true,
          email: user.email,
          password: "",
          image:  "https://firebasestorage.googleapis.com/v0/b/socialfast-395c8.appspot.com/o/Profile_avatar_placeholder_large%20(1).png?alt=media&token=70e09cc2-5e37-4d0b-a93a-6dd99d694249");

      this.db.collection('users').doc(userUid.uid).set(userData.toJson());
      if (userUid.uid != '') {
        _preferences.setAuthToken(userUid.uid);
        return user;
      } else {
        throw ServerException('El usuario no existe');
      }
    } catch (e) {
      print(e);
      throw ServerException(error("$e"));
    }
  }

  @override
  Future<bool> requestSendUserRecoverPassword(String email) async {
    try {
      final rUser = await this
          .db
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      final rUserDb = (rUser.docs.map((e) {
        return e.exists;
      })).first;

      if (rUserDb) {
        await this.auth.sendPasswordResetEmail(email: email);
        return rUserDb;
      } else {
        throw ServerException("El usuario no existe");
      }
    } catch (e) {
      throw ServerException(error("$e"));
    }
  }

  @override
  Future<UserModel> getUser(String id) async {
   try {
     final result = await this.db.collection('users').doc(id).get();
     return UserModel.fromJson(result.data()!);
     
   } catch (e) {
    throw ServerException(error("$e"));
   }
  }

}
