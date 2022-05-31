import 'package:equatable/equatable.dart';

class UserEntities extends Equatable {
  UserEntities(
      {
      required this.usuario,
      required this.email,
      required this.password,
      required this.id,
      required this.status,
      required this.image
      }
      );

  final String email;
  final String password;
  final String usuario;
  final String id;
  final bool status;
  final String image;

  @override
  List<Object?> get props =>
      [ email, password, usuario, id, status, image];
}
