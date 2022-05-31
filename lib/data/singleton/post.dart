import 'dart:developer';
import 'dart:io';

import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/data/singleton/notifications.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:clean_login/core/preferences/preferences.dart';

class PostSingleton {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storag = FirebaseStorage.instance;
  final _preferences = getIt<Preferences>();
  NotificationSingleton _singleton = NotificationSingleton();

  Future<PostData?> createPost(String content, File? image) async {
    try {
      final date = DateTime.now().millisecondsSinceEpoch;
       String? url;
      late String iduser;
      final result = db.collection("post").doc();
      if (image != null) {
        url = await requesUpdateImage(image, result.id);
        iduser = await idUser();
        final data = {
          "content": content,
          "createTime": date,
          "attachments": url,
          "userId": iduser,
          "active": true,
          "uid": result.id
        };
        result.set(data);
      }else{

         iduser = await idUser();
        final data = {
          "content": content,
          "createTime": date,
          "attachments": "",
          "userId": iduser,
          "active": true,
          "uid": result.id
        };
        result.set(data);

      }


      final datauser = await getUser(iduser);
      final comment = Comment(quantityComments: 0);
      final like = Like(itsYouLike: false, quantityLike: 0);
      final user = datauser as PublicUser;

      return PostData(active: true, attachments: url ?? "", comment: comment, content: content, createTime: date, like: like, publicUser: user, uid: result.id, userId: iduser);
    } catch (e) {
      print(e);
      return null;
    }
  }

   Future<PostData?> editPost(PostData data, File? image, String content) async {
    try {

       String? url;
      final result = db.collection("post").doc(data.uid);
      if (image != null) {
        url = await requesUpdateImage(image, data.uid);
        final resp = {
          "content": content,
          "createTime": data.createTime,
          "attachments": url,
          "userId": data.userId,
          "active": true,
          "uid": data.uid
        };
        result.update(resp);
      }else{

        final resp = {
          "content": content,
          "createTime": data.createTime,
          "attachments": data.attachments,
          "userId": data.userId,
          "active": true,
          "uid": data.uid
        };
        result.update(resp);

      }

      return PostData(active: true, attachments: url ?? data.attachments, comment: data.comment, content: content, createTime: data.createTime, like: data.like, publicUser: data.publicUser, uid: result.id, userId: data.userId);
    } catch (e) {
      print(e);
      return null;
    }
  }

   Future removePost(String uid) async {
  try {
    log("entra");
     db.collection("post").doc(uid).delete();
      return true;
  } catch (error) {
    return false;
  }
}




 Future<List<PostData>> requestPost(int? ult, int limit) async {
      log("entra");
     try {
       
      Query result = this.db.collection('post')
      .orderBy('createTime', descending: true);
        
      if (ult == null) {
        result = result.limit(limit);
      } else {
        log("paginacion");
        result = result.startAfter([ult]).limit(limit);
      }
       final resp =
          (await result.get()).docs.map((e) {
            return PostData.fromJson(e.data() as Map<String, dynamic>);
          }).toList();

          final id = await idUser();

          await Future.wait(
          resp.map((e) async => {
          e.comment = await getComments(e.uid, id),
          e.publicUser =  await getUser(e.userId),
          e.like = await getLike(e.uid, id),
          })
          );
    return resp.toList();
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


 Future setLikes(String postId, PostData? post) async {
   try {
   final userId = await idUser();
    final refPost = db.collection("post").doc(postId);
    final ref = refPost.collection("postLikes").doc(userId);
    await ref.set({ "userId": userId });
    if(post != null){
   _singleton.queryAddNotification(post.userId, userId, "addLike", postId);
    }
    return true;
  } catch (error) {
    return false;
  }
}

 Future removeLike(String postId) async {
   try {
   final userId = await idUser();
    final refPost = db.collection("post").doc(postId);
    final ref = refPost.collection("postLikes").doc(userId);
    await ref.delete();
    return true;
  } catch (error) {
    return false;
  }
}




  Future<String> requesUpdateImage(File image, String uid) async {
    try {
      String resultImagenUrl = "";
      var nameImage = "postImage";
      final path = "/imagenes/post/$uid/$nameImage.png";
      final storageReference = storag.ref().child(path);

      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.then((e) => print(e));

      resultImagenUrl = await storageReference.getDownloadURL().then((fileURL) {
        return resultImagenUrl = fileURL;
      });
      return resultImagenUrl;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

 

  Future<List<PostData>> requestPostUser(String idUser) async {
     try {
      Query result = this.db.collection('post')
      .orderBy('createTime', descending: true).where("userId", isEqualTo: idUser );
    
       final resp =
          (await result.get()).docs.map((e) {
            return PostData.fromJson(e.data() as Map<String, dynamic>);
          }).toList();
           
            final authToken = await _preferences.getAuthToken();
          await Future.wait(
          resp.map((e) async => {
          e.comment = await getComments(e.uid, authToken),
          e.publicUser =  await getUser(e.userId),
          e.like = await getLike(e.uid, authToken),
          })
          );
    return resp.toList();
     } catch (e) {
       log(e.toString());
       return [];
     }
  }

   Future<String> idUser() async {
    final authToken = await _preferences.getAuthToken();
    return authToken;
  }
}
