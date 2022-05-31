import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/core/framework/tipografia.dart';
import 'package:clean_login/presentation/screens/authentication/login/widget/form.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Login extends StatefulWidget {
  final PageController pageController;

  const Login({Key? key, required this.pageController}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailOrNitCtrl = TextEditingController();
  final passOrCodeCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailOrNitCtrl.dispose();
    passOrCodeCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Padding(padding: EdgeInsets.symmetric(vertical: 40),
               child: Text("Iniciar sesion", style: TextStyle(color: primary, fontWeight: FontWeight.bold),),
               ),

               Expanded(
                 child: FormLogin(
                    titulo: 'Correo electronico',
                    tituloSecure: 'Contraseña',
                    emailOrNitCtrl: emailOrNitCtrl,
                    passOrCodeCtrl: passOrCodeCtrl,
                  ),
               ),
              

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿No te has registrado?"),
                  TextButton(
                      onPressed: () {
                        widget.pageController.animateToPage(1,
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut);
                      },
                      child: Text('Registrar', style: styleTituloW600ORANGE))
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿Olvidaste la contraseña?"),
                  TextButton(
                      onPressed: () {
                        widget.pageController.animateToPage(2,
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut);
                      },
                      child: Text('Recuperar', style: styleTituloW600ORANGE))
                ],
              ),
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
