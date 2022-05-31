import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/core/framework/tipografia.dart';
import 'package:clean_login/presentation/screens/authentication/login/widget/form.dart';
import 'package:clean_login/presentation/screens/authentication/password/form_password.dart';
import 'package:flutter/material.dart';


class RecoverPasswordScreen extends StatefulWidget {
  final PageController pageController;

  RecoverPasswordScreen({Key? key, required this.pageController})
      : super(key: key);

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Recuperar Contraseña", style: TextStyle(color: primary, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              FormLoginPassword(),
              SizedBox(height: 40),
              TextButton(
                  onPressed: () {
                    this.widget.pageController.animateToPage(0,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.ease);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.navigate_before, color: secondary,),
                      Text('Iniciar Sesion', style:styleTituloW600ORANGE)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
