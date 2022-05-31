// To parse this JSON data, do
//
//     final solicitude = solicitudeFromJson(jsonString);

import 'dart:convert';

List<Solicitude> solicitudeFromJson(String str) => List<Solicitude>.from(json.decode(str).map((x) => Solicitude.fromJson(x)));

String solicitudeToJson(List<Solicitude> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Solicitude {
    Solicitude({
       required this.state,
       required this.userFromId,
       required this.userToId,
       required this.id,
    });

    String state;
    String userFromId;
    String userToId;
    String id;

    factory Solicitude.fromJson(Map<String, dynamic> json) => Solicitude(
        state: json["state"],
        userFromId: json["userFromId"],
        userToId: json["userToId"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "state": state,
        "userFromId": userFromId,
        "userToId": userToId,
        "id": id,
    };
}
