
import 'package:clean_login/presentation/screens/authentication/login/loginpage.dart';
import 'package:clean_login/presentation/screens/authentication/register/registerpage.dart';
import 'package:clean_login/presentation/screens/widget/logo.dart';
import 'package:flutter/material.dart';

import 'password/request_pass_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pageController = PageController(initialPage: 0);
  bool visible = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this._pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Logo(),
             
              Container(
                  height: size.height * 0.7,
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    onPageChanged: (page) {
                      if (page == 0) {
                        setState(() {
                          visible = true;
                        });
                      }
                    },
                    pageSnapping: false,
                    physics: new NeverScrollableScrollPhysics(),
                    itemBuilder: (context, position) {
                      if (position == 0) {
                        return Login(
                            pageController: _pageController);
                      } else if (position == 1) {
                        return RegisterScreen(
                            pageController: _pageController);
                      } else if (position == 2) {
                        return RecoverPasswordScreen(
                            pageController: _pageController);
                      } else {
                        return Login(
                            pageController: _pageController);
                      }
                    },
                    itemCount: 3,
                  )),
              
            ],
          ),
        ),
      ),
    );
  }
}
