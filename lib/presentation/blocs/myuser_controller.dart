

import 'package:clean_login/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
class MyUserData  extends ChangeNotifier{

late final UserEntities _myuser;
late final String _userId;

UserEntities get dataUser => _myuser;
  set dataUser(UserEntities user) {
   _myuser  = user;
    notifyListeners();
  }

  String get idUser => _userId;
  set idUser(String user) {
   _userId  = user;
    notifyListeners();
  }




}