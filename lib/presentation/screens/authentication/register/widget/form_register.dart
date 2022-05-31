import 'package:clean_login/core/validators/value_validators.dart';
import 'package:clean_login/data/models/user_model.dart';
import 'package:clean_login/presentation/blocs/authBloc/auth_bloc.dart';
import 'package:clean_login/presentation/routes/app_routes.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_button_auth.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_input.dart';
import 'package:clean_login/presentation/screens/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class FormRegister extends StatefulWidget {
  final TextEditingController phonenumber;
  final TextEditingController correo;
  final TextEditingController username;
  final TextEditingController passCtrl;

  final String tituloBtn;
  final bool activeEditCrtSecond;

  const FormRegister(
      {Key? key,
      this.activeEditCrtSecond = true,
      this.tituloBtn = 'Ingresar',
      required this.phonenumber,
      required this.correo,
      required this.username,
      required this.passCtrl})
      : super(key: key);

  @override
  _FormRegisterState createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  bool loading = false;
  final registerKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
          width: size.width,
          height: size.height,
      child: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is LoginLoading) {
            loading = true;
          } else if (state is LoginLoaded) {
            Navigator.pushReplacementNamed(context, Routes.HOME);
          } else if (state is LoginDetailError) {
            loading = false;
             showSnackBar(context, 'ERROR', '${state.message}');
            print("==========>>>> ${state.message}");
          }
        }, builder: (context, state) {
          return Container(
            margin: const EdgeInsets.only(top: 40.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: this.registerKey,
              child: Column(
                children: [
                  CustomInput(
                      icon: Ionicons.mail_open,
                      placeHolder: 'Correo',
                      keyboardType: TextInputType.emailAddress,
                      textController: widget.correo,
                      typeFormatters: 'todo',
                      validator: validateEmail,
                      enabled: !loading,
                      textInputAction: TextInputAction.next),
                  CustomInput(
                      icon: Ionicons.person,
                      placeHolder: 'Usuario',
                      keyboardType: TextInputType.name,
                      textController: widget.username,
                      typeFormatters: 'text',
                      validator: validatename,
                      enabled: !loading,
                      textInputAction: TextInputAction.next),
                  CustomInput(
                      icon: Ionicons.phone_portrait,
                      placeHolder: 'Telefono',
                      keyboardType: TextInputType.number,
                      textController: widget.phonenumber,
                      typeFormatters: 'number',
                      validator: validatePhone,
                      enabled: !loading,
                      textInputAction: TextInputAction.next),
                  if (widget.activeEditCrtSecond)
                    CustomInput(
                        icon: Ionicons.lock_closed,
                        placeHolder: 'Contraseña',
                        textController: widget.passCtrl,
                        isPassword: true,
                        typeFormatters: 'todo',
                        validator: validatePassword,
                        enabled: !loading,
                        textInputAction: TextInputAction.next),
                  CustomBtn(
                      loading: loading,
                      textBtn: 'Crear cuenta',
                      onTap: () {
                        final user = UserModel(
                            usuario: widget.username.text,
                            email: widget.correo.text,
                            password: widget.passCtrl.text,
                            id: "",
                            status: true,
                            image: "https://firebasestorage.googleapis.com/v0/b/socialfast-395c8.appspot.com/o/Profile_avatar_placeholder_large%20(1).png?alt=media&token=70e09cc2-5e37-4d0b-a93a-6dd99d694249");
      
                        if (this.registerKey.currentState!.validate()) {
                          context
                              .read<AuthBloc>()
                              .add(RegisterSubmittingEvent(user: user));
                        }
                      })
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
