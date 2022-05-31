import 'package:clean_login/core/errors/failure.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntities>> login(String email, String password);
  Future<Either<Failure, UserEntities>> register( UserModel user );
  Future<Either<Failure, bool>> sendRecoverPassword( String email );
  Future<Either<Failure, UserEntities>> getUser( String id );
}
