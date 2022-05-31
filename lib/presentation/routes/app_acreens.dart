import 'package:clean_login/presentation/routes/app_routes.dart';
import 'package:clean_login/presentation/screens/authentication/auth_screen.dart';
import 'package:clean_login/presentation/screens/pages/Home.dart';

import 'package:flutter/material.dart';

import '../../splash.dart';

class AppPages {
  static final routes = <String, WidgetBuilder>{

    //Lista de rutas

   Routes.INITIAL: (_) => SplashScreen(),
    Routes.LOGIN: (_) => LoginScreen(),
    Routes.HOME: (_) => Home(),
   

  };
}
