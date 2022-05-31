import 'dart:developer';

import 'package:clean_login/data/models/comments_model.dart';
import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/data/singleton/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommetsSingleton {
  FirebaseFirestore db = FirebaseFirestore.instance;
  NotificationSingleton _singleton = NotificationSingleton();

  Future<List<Comments>> requestCommets(String posId) async {
    log("entra commetd");
    try {
      final result = await this
          .db
          .collection('post')
          .doc(posId)
          .collection("postComments")
          .get();

      final resp = result.docs.map((e) {
        return Comments.fromJson(e.data());
      }).toList();

        await Future.wait(
          resp.map((e) async => {
          e.publicUser = await getUser(e.userId),
          })
          );

      return resp;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future createCommets(String postId, String content, String userId, PostData post) async {
    log(postId);
    log(content);
    log(userId);
    try {
      final date = DateTime.now().millisecondsSinceEpoch;
      final result =
          db.collection('post').doc(postId).collection("postComments").doc();
      log(result.id);
      final data = {
        "content": content,
        "createTime": date,
        "userId": userId,
        "uid": result.id,
        "postId": postId
      };
      await result.set(data);
      _singleton.queryAddNotification(post.userId, userId, "addComment", postId);

      final user = await getUser(userId);

      return Comments(
          content: content,
          createTime: date,
          userId: userId,
          uid: result.id,
          postId: postId,
          publicUser: user);
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future getUser(String uid) async {
    final query = db.collection("users").doc(uid);
    final querySnapshot = await query.get();
    final String userName = querySnapshot.get("username");
    final String photoUrl = querySnapshot.get("image");
    final PublicUsers data =
        PublicUsers(photoUrl: photoUrl, userId: uid, userName: userName);
    return data;
  }
}
