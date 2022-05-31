import 'dart:convert';
import 'package:clean_login/domain/entities/user.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends UserEntities {
  UserModel(
      {required this.usuario,
      required this.email,
      required this.password,
      required this.id,
      required this.status,
      required this.image})
      : super(
            usuario: usuario,
            email: email,
            password: password,
            id: id,
            image: image,
            status: status);

  final String email;
  final String password;
  final String usuario;
  final String id;
  final bool status;
  final String image;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      usuario: json["username"],
      email: json["email"],
      password: json["password"],
      image: json['image'],
      status: json['status'],
      id: json['id']);

  Map<String, dynamic> toJson() => {
        "username": usuario,
        "email": email,
        "password": password,
        'image': image,
        'status': status,
        'id': id
      };
}
