import 'dart:developer';
import 'dart:io';

import 'package:clean_login/data/models/notifications.dart';
import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/data/singleton/notifications.dart';
import 'package:clean_login/data/singleton/post.dart';
import 'package:flutter/cupertino.dart';

class PostProvider with ChangeNotifier {
  List<PostData> _item = [];
  List<PostData>? itemPostUser = [];
  List<Notifications>? notifications = [];
  bool loading = false;
  bool loadingNotifi = false;
  bool loadingPostUser = false;
  bool loadingpaginacion = false;
  bool createPostLoading = false;

  NotificationSingleton _notificationSingleton = NotificationSingleton();

  PostSingleton post = PostSingleton();
  List<PostData> get data => _item;

  void createPosts(String content, File? image) async {
    createPostLoading = true;
    notifyListeners();
    final result = await post.createPost(content, image);
    _item.insert(0, result!);
    itemPostUser!.insert(0, result);
    createPostLoading = false;
    notifyListeners();
  }

  void editPosts(PostData data, File? image, String content) async {
    createPostLoading = true;
    notifyListeners();
    // respuesta de la base de datos
    final result = await post.editPost(data, image, content);
    // Modificar la data principal del post
   final resp =  _item.map((e) => e.uid == data.uid ? e =  result! : e).toList();
    _item.clear();
   _item.addAll(resp);
    notifyListeners();
   
   // Modificar la data de los post del perfil del usuario
   final respExisr = itemPostUser!.where((element) => element.uid == result!.uid).toList();
   if(respExisr.length > 0){
   final resprofile =  itemPostUser!.map((e) => e.uid == data.uid ? e =  result! : e).toList();
    itemPostUser!.clear();
    itemPostUser!.addAll(resprofile);
   notifyListeners();
   }
     
    createPostLoading = false;
    notifyListeners();
  }

  void removePosts(String uid) async {
    await post.removePost(uid);
    final resp = _item.where((element) => element.uid != uid).toList();
    final respostuser = itemPostUser!.where((element) => element.uid != uid).toList();
    _item.clear();
   _item.addAll(resp);
    itemPostUser!.clear();
    itemPostUser!.addAll(respostuser);
    notifyListeners();
  }

 void loadData(int? ult, int limit) async {
    loading = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await post.requestPost(ult, limit);
    // log(result[1].like!.itsYouLike!.toString());
    _item.addAll(result);
    loading = false;
    notifyListeners();
  }

  void loadDataPaginacion(int? ult, int limit) async {
    loadingpaginacion = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await post.requestPost(ult, limit);
    _item.addAll(result);
    loadingpaginacion = false;
    notifyListeners();
  }
 
 void likePost(String uid, PostData postdata)async{
   await post.setLikes(uid, postdata);
  final data =  _item.map((e) => e.uid == uid ? e =  PostData(active: e.active, attachments: e.attachments, content: e.content, 
   createTime: e.createTime, uid: e.uid, userId: e.userId, comment: e.comment, publicUser: e.publicUser, like:Like(itsYouLike: true, quantityLike: e.like!.quantityLike! + 1) )   
   : e).toList();

   final datapostuser =  itemPostUser!.map((e) => e.uid == uid ? e =  PostData(active: e.active, attachments: e.attachments, content: e.content, 
   createTime: e.createTime, uid: e.uid, userId: e.userId, comment: e.comment, publicUser: e.publicUser, like:Like(itsYouLike: true, quantityLike: e.like!.quantityLike! + 1) )   
   : e).toList();
   _item.clear();
   _item.addAll(data);
    itemPostUser!.clear();
    itemPostUser!.addAll(datapostuser);
    notifyListeners();
 }

 void removeLikePost(String uid)async{
 await post.removeLike(uid);
 final data =  _item.map((e) => e.uid == uid ? e =  PostData(active: e.active, attachments: e.attachments, content: e.content, 
   createTime: e.createTime, uid: e.uid, userId: e.userId, comment: e.comment, publicUser: e.publicUser, like:Like(itsYouLike: false, quantityLike: e.like!.quantityLike! - 1) )   
   : e).toList();

   final datapostuser =  itemPostUser!.map((e) => e.uid == uid ? e =  PostData(active: e.active, attachments: e.attachments, content: e.content, 
   createTime: e.createTime, uid: e.uid, userId: e.userId, comment: e.comment, publicUser: e.publicUser, like:Like(itsYouLike: false, quantityLike: e.like!.quantityLike! - 1) )   
   : e).toList();

    _item.clear();
   _item.addAll(data);
 
    itemPostUser!.clear();
    itemPostUser!.addAll(datapostuser);

    notifyListeners();
 }

 set data(List<PostData> data) {
    _item = data;
    notifyListeners();
  }


 void loadDataPostProfile(String idUser) async {
    loadingPostUser = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await post.requestPostUser(idUser);
    log(result.length.toString());
    itemPostUser!.clear();
    itemPostUser!.addAll(result);
    loadingPostUser = false;
    notifyListeners();
  }

   void loadDataNotification(String iduser) async {
    loadingNotifi = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await _notificationSingleton.getNotifications(iduser);
     notifications!.clear();
    notifications!.addAll(result);
    loadingNotifi = false;
    notifyListeners();
  }


}