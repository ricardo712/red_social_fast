import 'package:clean_login/presentation/blocs/authBloc/auth_bloc.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_button_auth.dart';
import 'package:clean_login/presentation/screens/authentication/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_login/presentation/screens/widget/snackbar.dart';


class FormLoginPassword extends StatefulWidget {
  @override
  _FormLoginPasswordState createState() => _FormLoginPasswordState();
}

class _FormLoginPasswordState extends State<FormLoginPassword> {
  final codectr = TextEditingController();
  final newPssctr = TextEditingController();

  final passwordKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RecoverPasswordLoading) {
          loading = true;
        } else if (state is RecoverPasswordLoaded) {
           showSnackBar(context, 'Enviado', 'Revisa tu correo para la recuperacion de tu contraseña');
           codectr.text = "";
           loading = false;
          //  Navigator.pushReplacementNamed(context, Routes.LOGIN);
        } else if (state is RecoverPasswordDetailError) {
          loading = false;
          showSnackBar(context, 'ERROR', '${state.message}');
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 40.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: passwordKey,
              child: Column(
                children: [
                  CustomInput(
                      icon: Icons.email_outlined,
                      placeHolder: 'Correo eletronico',
                      keyboardType: TextInputType.text,
                      textController: codectr,
                      typeFormatters: 'todo',
                      enabled: !loading,
                      textInputAction: TextInputAction.next),
                  // CustomInput(
                  //     icon: Icons.email_outlined,
                  //     placeHolder: 'Nueva contraseña',
                  //     keyboardType: TextInputType.text,
                  //     textController: newPssctr,
                  //     typeFormatters: 'todo',
                  //     enabled: !loading,
                  //     textInputAction: TextInputAction.next),
                  CustomBtn(
                    textBtn: 'Enviar',
                    loading: loading,
                    onTap: () {
                      if (this.passwordKey.currentState!.validate()) {
                        context
                            .read<AuthBloc>()
                            .add(SendRecoverPasswordSubmittingEvent(
                              email: codectr.text,
                            ));
                        print("enviado");
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
