import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/core/framework/tipografia.dart';
import 'package:clean_login/presentation/screens/authentication/register/widget/form_register.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final PageController pageController;

  RegisterScreen({Key? key, required this.pageController}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nitCtrl = TextEditingController();

  final codeCtrl = TextEditingController();

  final firstNameCtrl = TextEditingController();

  final lastNameCtrl = TextEditingController();

  final passOrCodeCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nitCtrl.dispose();
    codeCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    passOrCodeCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Registro", style: TextStyle(color: primary, fontWeight: FontWeight.bold),),
              Expanded(

                child: FormRegister(
                  phonenumber: codeCtrl,
                  correo: firstNameCtrl,
                  username: lastNameCtrl,
                  passCtrl: passOrCodeCtrl,
                  tituloBtn: 'Crear cuenta',
                 
                ),
              ),
              
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
                      Text('Ya tengo cuenta, iniciar sesion', style: styleTituloW600ORANGE),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
