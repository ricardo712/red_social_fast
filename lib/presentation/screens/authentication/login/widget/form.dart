import 'package:clean_login/core/validators/value_validators.dart';
import 'package:clean_login/presentation/blocs/authBloc/auth_bloc.dart';
import 'package:clean_login/presentation/routes/app_routes.dart';
import 'package:clean_login/presentation/screens/widget/boton_azul.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_button_auth.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_input.dart';
import 'package:clean_login/presentation/screens/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class FormLogin extends StatefulWidget {
  final TextEditingController emailOrNitCtrl;
  final TextEditingController passOrCodeCtrl;
  final String titulo;
  final String? tituloSecure;
  final String tituloBtn;
  final bool activeEditCrtSecond;

  const FormLogin({
    Key? key,
    required this.emailOrNitCtrl,
    required this.passOrCodeCtrl,
    required this.titulo,
    this.tituloSecure = 'Correo electronico',
    this.activeEditCrtSecond = true,
    this.tituloBtn = 'Ingresar',
  }) : super(key: key);

  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  bool loading = false;
  final loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is LoginLoading) {
        loading = true;
      } else if (state is LoginLoaded) {
        Navigator.pushReplacementNamed(context, Routes.HOME);
      } else if (state is LoginDetailError) {
        loading = false;
        print("===============>>>>>>>  ${state.message}");
        showSnackBar(context, 'ERROR', '${state.message}');
      }
    }, builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: this.loginKey,
            child: Column(
              children: [
                CustomInput(
                    icon: Ionicons.mail_open,
                    placeHolder: widget.titulo,
                    keyboardType: TextInputType.emailAddress,
                    textController: widget.emailOrNitCtrl,
                    validator: validateEmail,
                    typeFormatters: 'todo',
                    enabled: !loading,
                    textInputAction: TextInputAction.next),
                CustomInput(
                  icon: Ionicons.lock_closed,
                  placeHolder: widget.tituloSecure!,
                  textController: widget.passOrCodeCtrl,
                  isPassword: true,
                  validator: validatePassword,
                  typeFormatters: 'todo',
                  enabled: !loading,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomBtn(
                    loading: loading,
                    textBtn: "Ingresar",
                    onTap: () {
                      if (this.loginKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(LoginSubmittingEvent(
                            email: widget.emailOrNitCtrl.text,
                            password: widget.passOrCodeCtrl.text));
                      }
                    })
              ],
            ),
          ),
        ),
      );
    });
  }
}
