part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginLoaded extends AuthState {
  final UserEntities user;

  LoginLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class LoginDetailError extends AuthState {
  final String message;

  LoginDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterLoading extends AuthState {}

class RegisterLoaded extends AuthState {
  final UserEntities user;

  RegisterLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class RegisterDetailError extends AuthState {
  final String message;

  RegisterDetailError(this.message);

  @override
  List<Object> get props => [message];
}


class RecoverPasswordLoading extends AuthState {}

class RecoverPasswordLoaded extends AuthState {
  final bool change;

  RecoverPasswordLoaded(this.change);

  @override
  List<Object> get props => [change];
}

class RecoverPasswordDetailError extends AuthState {
  final String message;

  RecoverPasswordDetailError(this.message);

  @override
  List<Object> get props => [message];
}