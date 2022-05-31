import 'package:clean_login/core/errors/exceptions.dart';
import 'package:clean_login/core/errors/failure.dart';
import 'package:clean_login/data/datasources/class_abstract/user_remote_datasource.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositpryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositpryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntities>> login(
      String email, String password) async {
    try {
      final rUser = await remoteDataSource.requestUserLogin(email, password);
      return Right(rUser);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: "${e.message}"),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntities>> register(UserModel user) async {
    try {
      final rUser = await remoteDataSource.requestUserRegister(user);
      return Right(rUser);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: "${e.message}"),
      );
    }
  }


  @override
  Future<Either<Failure, bool>> sendRecoverPassword(String email) async {
    try {
      final rUser =
          await remoteDataSource.requestSendUserRecoverPassword(email);
      return Right(rUser);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: "${e.message}"),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntities>> getUser(String id) async {
     try {
       final rUser = await remoteDataSource.getUser(id);
       return Right(rUser);
     } on ServerException catch (e) {
       return Left(
        ServerFailure(message: "${e.message}"),
      );
     }
  }


}
