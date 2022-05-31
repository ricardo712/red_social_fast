// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/domain/entities/user.dart';

List<Notifications> notificationsFromJson(String str) => List<Notifications>.from(json.decode(str).map((x) => Notifications.fromJson(x)));

String notificationsToJson(List<Notifications> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notifications {
    Notifications({
       required this.type,
       required this.iduser,
       required this.userToId,
       required this.createDate,
       required this.id,
       this.idPost,
       this.user,
       this.post
    });

    String type;
    String iduser;
    String? idPost;
    String userToId;
    int createDate;
    String id;
    UserEntities? user;
    PostData? post;

    factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        type: json["type"],
        iduser: json["iduser"],
        userToId: json["userToId"],
        createDate: json["createDate"],
        id: json["id"],
        idPost: json["idPost"]
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "iduser": iduser,
        "userToId": userToId,
        "createDate": createDate,
        "id": id,
    };
}
