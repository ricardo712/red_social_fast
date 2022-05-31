import 'dart:developer';

import 'package:clean_login/data/models/notifications.dart';
import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clean_login/core/preferences/preferences.dart';

class NotificationSingleton {
  FirebaseFirestore db = FirebaseFirestore.instance;
 final _preferences = getIt<Preferences>();
  Future queryAddNotification(String iduser, String friend, String type, String? idPost) async {
    final query =
        db.collection("users").doc(iduser).collection("notification").doc();
     final date = DateTime.now().millisecondsSinceEpoch;
    final data = {
      "type": type,
      "iduser": iduser,
      "userToId": friend,
      "createDate": date,
      "id": query.id,
      "idPost": idPost
    };

    query.set(data);
    final querySnapshot = await query.get();
    return querySnapshot;
  }

   Future <List<Notifications>> getNotifications(String iduser) async {
    final query = await
        db.collection("users").doc(iduser).collection("notification").orderBy("createDate", descending: true).get();
     
      final resp = query.docs.map((e) {
        return Notifications.fromJson(e.data());
      }).toList();

      await Future.wait(
          resp.map((e) async => {
          e.user = await getUser(e.userToId),
          e.post = await requestPost(e.idPost!)
          })
          );
    

    return resp;
  }

  Future<UserEntities> getUser(id)async{
   final user = await db.collection("users").doc(id).get();
    return UserModel.fromJson(user.data()!);
  }

  Future<PostData?> requestPost(String idpost) async {
     try {
       
      final result = await db.collection('post').doc(idpost).get();
      final data =   PostData.fromJson(result.data()!); 
          final id = await idUser();

          data.comment = await getComments(data.uid, id);
          data.publicUser =  await getUserpost(data.userId);
          data.like = await getLike(data.uid, id);

          
    return data;
     } catch (e) {
       log(e.toString());
       return null;
     }
  }

  Future getUserpost(String uid) async {
  final query = db.collection("users").doc(uid);
  final querySnapshot = await query.get();
  final String userName = querySnapshot.get("username");
  final String photoUrl = querySnapshot.get("image");
  final PublicUser data = PublicUser(photoUrl: photoUrl, userId: uid, userName: userName);
  return data;
}


 Future getLike(String uid, String userId) async {
  try {
   final ref = db.collection("post").doc(uid).collection("postLikes");
   final doc = await ref.doc(userId).get();
   final quantity = (await ref.get()).docs.length;
   final Like data = Like(itsYouLike: doc.exists, quantityLike: quantity);
    
    return data;
  } catch (error) {
    log(error.toString());
    return 0;
  }
}

 Future getComments(String uid, String userId) async {
   try {
    final ref = db.collection("post").doc(uid).collection("postComments");
    final quantity = (await ref.get()).size;
     final Comment da = Comment(quantityComments: quantity ) ;
    return da;
  } catch (error) {
    return 0;
  }
}

 Future<String> idUser() async {
    final authToken = await _preferences.getAuthToken();
    return authToken;
  }




}
