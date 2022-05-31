import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_login/core/errors/failure.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/domain/usecase/get_user.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';


part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  GetUser getUser;
  AuthBloc({required this.getUser}) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginSubmittingEvent) {
      yield* login(event);
    } else if (event is RegisterSubmittingEvent) {
      yield* register(event);
    } else if (event is SendRecoverPasswordSubmittingEvent) {
      yield* sendRecoverPassword(event);
    }else if (event is OnGetUser){
      yield* getUserID(event);
    }
  }

  /* LOGIN */

  Stream<AuthState> login(LoginSubmittingEvent event) async* {
    emit(LoginLoading());
    final loginUser = await this.getUser.callLogin(event.email, event.password);
    await Future.delayed(Duration(milliseconds: 2000));
    emit(_eitherLoadedOrErrorState(loginUser));
  }


  AuthState _eitherLoadedOrErrorState(
      Either<Failure, UserEntities> failureOrUser) {
    return failureOrUser.fold(
        (failure) => LoginDetailError(_mapFailureToMessage(failure)),
        (user) => LoginLoaded(user));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return '${failure.message}';
      default:
        return 'Unexpected error';
    }
  }

  // TraeruSUARIO
  Stream<AuthState> getUserID(OnGetUser event) async* {
    final loginUser = await this.getUser.callgetUser(event.id);
    emit(_eitherLoadedOrErrorStateuser(loginUser));
  }


  AuthState _eitherLoadedOrErrorStateuser(
      Either<Failure, UserEntities> failureOrUser) {
    return failureOrUser.fold(
        (failure) => LoginDetailError(_mapFailureToMessageuser(failure)),
        (user) => LoginLoaded(user));
  }

  String _mapFailureToMessageuser(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return '${failure.message}';
      default:
        return 'Unexpected error';
    }
  }


  /* REGISTRAR */

  Stream<AuthState> register(RegisterSubmittingEvent event) async* {
    emit(LoginLoading());
    final loginUser = await this.getUser.callRegistrar(event.user);
    emit(_eitherLoadedOrErrorRegisterState(loginUser));
  }

  AuthState _eitherLoadedOrErrorRegisterState(
      Either<Failure, UserEntities> failureOrUser) {
    return failureOrUser.fold(
        (failure) => LoginDetailError(_mapFailureToMessageRegister(failure)),
        (user) => LoginLoaded(user));
  }

  String _mapFailureToMessageRegister(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return '${failure.message}';
      default:
        return 'Unexpected error';
    }
  }

  Stream<AuthState> sendRecoverPassword(
      SendRecoverPasswordSubmittingEvent event) async* {
    emit(RecoverPasswordLoading());
    final loginUser = await this.getUser.callSendRecoverPassword(event.email);
    emit(_eitherLoadedOrErrorSendRecoverPassowrdState(loginUser));
  }

  AuthState _eitherLoadedOrErrorSendRecoverPassowrdState(
      Either<Failure, bool> failureOrUser) {
    return failureOrUser.fold(
        (failure) => RecoverPasswordDetailError(
            _mapFailureToMessageSendRecoverPassword(failure)),
        (user) => RecoverPasswordLoaded(user));
  }

  String _mapFailureToMessageSendRecoverPassword(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return '${failure.message}';
      default:
        return 'Unexpected error';
    }
  }


}
