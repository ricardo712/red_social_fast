// To parse this JSON data, do
//
//     final postData = postDataFromJson(jsonString);

import 'dart:convert';

List<PostData> postDataFromJson(String str) => List<PostData>.from(json.decode(str).map((x) => PostData.fromJson(x)));

String postDataToJson(List<PostData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostData {
    PostData({
      required this.active,
      required this.attachments,
       this.comment,
      required this.content,
      required this.createTime,
       this.like,
       this.publicUser,
      required this.uid,
      required this.userId,
    });

    bool active;
    String attachments;
    Comment? comment;
    String content;
    int createTime;
    Like? like;
    PublicUser? publicUser;
    String uid;
    String userId;

    factory PostData.fromJson(Map<String, dynamic> json) => PostData(
        active: json["active"],
        attachments: json["attachments"],
        // comment: Comment.fromJson(json["comment"]),
        content: json["content"],
        createTime: json["createTime"],
        // like: Like.fromJson(json["like"]) ,
        // publicUser: PublicUser.fromJson(json["publicUser"]),
        uid: json["uid"],
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "active": active,
        "attachments": attachments,
        "comment": comment!.toJson(),
        "content": content,
        "createTime": createTime,
        "like": like!.toJson(),
        "publicUser": publicUser!.toJson(),
        "uid": uid,
        "userId": userId,
    };
}

class Comment {
    Comment({
        this.quantityComments,
    });

    int? quantityComments;

    factory Comment.fromJson(Map<String, int> json) => Comment(
        quantityComments: json["quantityComments"],
    );

    Map<String, dynamic> toJson() => {
        "quantityComments": quantityComments,
    };
}

class Like {
    Like({
       this.itsYouLike,
       this.quantityLike,
    });

    bool? itsYouLike;
    int? quantityLike;

    factory Like.fromJson(Map<String, dynamic> json) => Like(
        itsYouLike: json["itsYouLike"],
        quantityLike: json["quantityLike"],
    );

    Map<String, dynamic> toJson() => {
        "itsYouLike": itsYouLike,
        "quantityLike": quantityLike,
    };
}

class PublicUser {
    PublicUser({
        this.photoUrl,
        this.userId,
        this.userName,
    });

    String? photoUrl;
    String? userId;
    String? userName;

    factory PublicUser.fromJson(Map<String, dynamic> json) => PublicUser(
        photoUrl: json["photoUrl"],
        userId: json["userId"],
        userName: json["userName"],
    );

    Map<String, dynamic> toJson() => {
        "photoUrl": photoUrl,
        "userId": userId,
        "userName": userName,
    };
}
