import 'package:clean_login/core/errors/failure.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';


@LazySingleton()
class GetUser {
  final UserRepository userRepository;

  GetUser({required this.userRepository});

  Future<Either<Failure, UserEntities>> callLogin(String email, String password) async {
    return userRepository.login( email, password);
  }


  Future<Either<Failure, UserEntities>> callRegistrar( UserModel user) async {
    return userRepository.register( user );
  }

  Future<Either<Failure, bool>> callSendRecoverPassword( String email) async {
    return userRepository.sendRecoverPassword( email );
  }

  Future<Either<Failure, UserEntities>> callgetUser( String id) async {
    return userRepository.getUser( id );
  }


}
