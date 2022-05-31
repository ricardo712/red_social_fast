import 'dart:developer';
import 'dart:io';

import 'package:clean_login/data/singleton/friends.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/presentation/blocs/authBloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendProvider extends ChangeNotifier {
  List<UserEntities>? item;
  bool loading = false;
  bool loadingUpdateuser = false;
  String stateSolicitude = "";
  int zisefriends = 0;

  FriendSingleton _friendSingleton = FriendSingleton();

  void loadData() async {
    loading = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();

    final result = await _friendSingleton.requestUsers();
    if (item == null) {
      item = [];
    }
    item!.addAll(result);

    loading = false;
    notifyListeners();
  }

  void getStateSolicitude(String iduser, String idFriend) async {
    stateSolicitude = "loading";
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await _friendSingleton.getFriendSolicitude(iduser, idFriend);
    stateSolicitude = result;
    notifyListeners();
  }

  void createStateSolicitude(String iduser, String idFriend) async {
    stateSolicitude = "loading";
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await _friendSingleton.addFriends(idFriend, iduser);
    stateSolicitude = result;
    notifyListeners();
  }

  void aceptarStateSolicitude(List<String> users) async {
    stateSolicitude = "loading";
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await _friendSingleton.aceptFriends(users);
    stateSolicitude = result;
    notifyListeners();
  }

  void sizeFriends(String idUser) async {
    final result = await _friendSingleton.sizeFriends(idUser);
    zisefriends = result;
    notifyListeners();
  }

  void eliminarFriends(List<String> idUser) async {
    stateSolicitude = "loading";
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await _friendSingleton.deleteFriends(idUser);
    stateSolicitude = result;
    notifyListeners();
  }

  void cancelarFriends(List<String> idUser) async {
    stateSolicitude = "loading";
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await _friendSingleton.cancelFriends(idUser);
    stateSolicitude = result;
    notifyListeners();
  }

  void updateUser(UserEntities user, File? image, BuildContext context) async {
    loadingUpdateuser = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    final result = await _friendSingleton.updateUser(user, image);
    log(result.toString());
    loadingUpdateuser = false;
    notifyListeners();
    context.read<AuthBloc>().add(OnGetUser(id: user.id));

  }
}
