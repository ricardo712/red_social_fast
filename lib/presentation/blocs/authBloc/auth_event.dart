part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmittingEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginSubmittingEvent({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}


class RegisterSubmittingEvent extends AuthEvent {
  final UserModel user;
  const RegisterSubmittingEvent({required this.user});
  @override
  List<Object> get props => [user];
}

class SendRecoverPasswordSubmittingEvent extends AuthEvent {
  final String email;
  const SendRecoverPasswordSubmittingEvent({required this.email});
  @override
  List<Object> get props => [email];
}


class OnGetUser extends AuthEvent{
  final String id;

  const OnGetUser({required this.id});
  @override
  List<Object> get props => [id];

}
