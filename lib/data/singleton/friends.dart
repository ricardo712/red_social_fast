import 'dart:developer';
import 'dart:io';

import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/data/models/solicitude.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/data/singleton/notifications.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FriendSingleton {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storag = FirebaseStorage.instance;
  NotificationSingleton _singleton = NotificationSingleton();

  Future<List<UserModel>> requestUsers() async {
    log("entra friend");
    try {
      final result = await this.db.collection('users').get();

      final resp = result.docs.map((e) {
        return UserModel.fromJson(e.data());
      }).toList();

      return resp;
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
    final PublicUser data =
        PublicUser(photoUrl: photoUrl, userId: uid, userName: userName);
    return data;
  }

  Future<String> addFriends(String idFriend, String idUser) async {
    final query = db.collection("friends").doc();
    final data = {
      "id": query.id,
      "userFromId": idUser,
      "userToId": idFriend,
      "state": "pendiente"
    };
    await query.set(data);
    _singleton.queryAddNotification(idFriend, idUser, "addFriend", "");
    
    return "pendiente";
  }

  Future<String> aceptFriends(List<String> users) async {
    QuerySnapshot<Map<String, dynamic>> foundFriendInvitation;
    foundFriendInvitation = await query(users[0], users[1]);
    if (foundFriendInvitation.size == 0) {
      foundFriendInvitation = await query(users[1], users[0]);
    }

    final dataresp = foundFriendInvitation.docs
        .map((e) => Solicitude.fromJson(e.data()))
        .toList();

    final querydata = db.collection("friends").doc(dataresp[0].id);
    final data = {"state": "aceptado"};
    await querydata.update(data);
    _singleton.queryAddNotification(users[1], users[0], "acceptFriend", "");

    await Future.wait(
        users.map((e) async => {await inserFriend(dataresp[0].id, e)}));

    return "aceptado";
  }

  Future inserFriend(String uid, userId) async {
    final query =
        db.collection("users").doc(userId).collection("friends").doc(uid);
    query.set({"invitacion": uid});
    return true;
  }

  Future remove(String uid, userId) async {
    await db
        .collection("users")
        .doc(userId)
        .collection("friends")
        .doc(uid)
        .delete();
    return true;
  }

  Future deleteFriends(List<String> users) async {
    QuerySnapshot<Map<String, dynamic>> foundFriendInvitation;
    foundFriendInvitation = await query(users[0], users[1]);
    if (foundFriendInvitation.size == 0) {
      foundFriendInvitation = await query(users[1], users[0]);
    }

    final dataresp = foundFriendInvitation.docs
        .map((e) => Solicitude.fromJson(e.data()))
        .toList();

    await db.collection("friends").doc(dataresp[0].id).delete();
    await Future.wait(
        users.map((e) async => {await remove(dataresp[0].id, e)}));

    return "";
  }

  Future cancelFriends(List<String> users) async {
    QuerySnapshot<Map<String, dynamic>> foundFriendInvitation;
    foundFriendInvitation = await query(users[0], users[1]);
    if (foundFriendInvitation.size == 0) {
      foundFriendInvitation = await query(users[1], users[0]);
    }
    final dataresp = foundFriendInvitation.docs
        .map((e) => Solicitude.fromJson(e.data()))
        .toList();

    await db.collection("friends").doc(dataresp[0].id).delete();
    return "";
  }

  Future<int> sizeFriends(String iduser) async {
    final query =
        db.collection("users").doc(iduser).collection("friends").get();
    final size = (await query).size;
    return size;
  }

  Future<String> getFriendSolicitude(String iduser, String friend) async {
    QuerySnapshot<Map<String, dynamic>> foundFriendInvitation;
    foundFriendInvitation = await query(iduser, friend);
    if (foundFriendInvitation.size == 0) {
      foundFriendInvitation = await query(friend, iduser);
    }

    if (foundFriendInvitation.size == 0) {
      return "";
    } else {
      final data = foundFriendInvitation.docs
          .map((e) => Solicitude.fromJson(e.data()))
          .toList();

      return data[0].state == "aceptado"
          ? data[0].state
          : iduser == data[0].userFromId
              ? data[0].state
              : "pendiente1";
    }
  }

  Future query(String iduser, String friend) async {
    final query = db
        .collection("friends")
        .where("userFromId", isEqualTo: iduser)
        .where("userToId", isEqualTo: friend);

    final querySnapshot = await query.get();
    return querySnapshot;
  }

  Future updateUser(UserEntities user, File? image) async {
    if (image != null) {
      final url = await requesUpdateImage(image, user.id);
      db
          .collection("users")
          .doc(user.id)
          .update({"image": url, "username": user.usuario});
    } else {
      db.collection("users").doc(user.id).update({"username": user.usuario});
    }

    return true;
  }

  Future<String> requesUpdateImage(File image, String uid) async {
    try {
      String resultImagenUrl = "";
      var nameImage = "profileimage";
      final path = "/imagenes/perfil/$uid/$nameImage.png";
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
}
