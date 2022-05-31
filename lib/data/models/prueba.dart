// To parse this JSON data, do
//
//     final prueba = pruebaFromJson(jsonString);

import 'dart:convert';

List<Prueba> pruebaFromJson(String str) => List<Prueba>.from(json.decode(str).map((x) => Prueba.fromJson(x)));

String pruebaToJson(List<Prueba> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Prueba {
    Prueba({
       required this.active,
       required this.attachments,
       required this.content,
       required this.createTime,
       required this.userId,
       required this.uid,
    });

    bool active;
    String attachments;
    String content;
    int createTime;
    String userId;
    String uid;

    factory Prueba.fromJson(Map<String, dynamic> json) => Prueba(
        active: json["active"],
        attachments: json["attachments"],
        content: json["content"],
        createTime: json["createTime"],
        userId: json["userId"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "active": active,
        "attachments": attachments,
        "content": content,
        "createTime": createTime,
        "userId": userId,
        "uid": uid,
    };
}
