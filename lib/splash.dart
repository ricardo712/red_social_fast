import 'package:clean_login/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'core/preferences/preferences.dart';
import 'injection_dependency.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final _preferences = getIt<Preferences>();
  String user = '';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) => verificar());
    // verificar();
  }

  Future verificar() async {
    this.user = await _preferences.getAuthToken();
    if (user != "") {
        
      Navigator.pushReplacementNamed(context, Routes.HOME);
    } else {
      Navigator.pushReplacementNamed(context, Routes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
