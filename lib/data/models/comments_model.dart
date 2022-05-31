// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

List<Comments> commentsFromJson(String str) => List<Comments>.from(json.decode(str).map((x) => Comments.fromJson(x)));

String commentsToJson(List<Comments> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comments {
    Comments({
      required  this.content,
      required  this.createTime,
      required  this.userId,
      required  this.uid,
      required  this.postId,
        this.publicUser,
    });

    String content;
    int createTime;
    String userId;
    String uid;
    String postId;
    PublicUsers? publicUser;

    factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        content: json["content"],
        createTime: json["createTime"],
        userId: json["userId"],
        uid: json["uid"],
        postId: json["postId"],
        // publicUser: PublicUsers.fromJson(json["publicUser"]),
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "createTime": createTime,
        "userId": userId,
        "uid": uid,
        "postId": postId,
        "publicUser": publicUser!.toJson(),
    };
}

class PublicUsers {
    PublicUsers({
      required  this.userName,
      required  this.userId,
      required  this.photoUrl,
    });

    String userName;
    String userId;
    String photoUrl;

    factory PublicUsers.fromJson(Map<String, dynamic> json) => PublicUsers(
        userName: json["userName"],
        userId: json["userId"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
        "photoUrl": photoUrl,
    };
}
