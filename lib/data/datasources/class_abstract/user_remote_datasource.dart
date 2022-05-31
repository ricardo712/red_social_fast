import 'package:clean_login/data/models/user_model.dart';




abstract class UserRemoteDataSource {
  Future<UserModel> requestUserLogin(String email, String password);
  Future<UserModel> requestUserRegister(UserModel user);
  Future<UserModel> getUser(String id);
  Future<bool> requestSendUserRecoverPassword(String email);

}
