
import 'dart:developer';

import 'package:clean_login/data/models/comments_model.dart';
import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/data/singleton/comments_S.dart';
import 'package:flutter/material.dart';

class CommentsProvider extends ChangeNotifier {
  List<Comments>? item;
  bool loading = false;

  CommetsSingleton _commetsSingleton = CommetsSingleton();


void createPosts(String content, String userId, String postid, PostData post) async {
    final result = await _commetsSingleton.createCommets(postid, content, userId, post);
    item!.insert(0, result!);
    notifyListeners();
  }

  void loadData(String idPost) async {
    loading = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();

    final result = await _commetsSingleton.requestCommets(idPost);
    if (item == null) {
      item = [];
    }
    item!.clear();
    item!.addAll(result);

    loading = false;
    notifyListeners();
  }
}