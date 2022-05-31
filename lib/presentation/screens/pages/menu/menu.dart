import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/core/preferences/preferences.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/routes/app_routes.dart';
import 'package:clean_login/presentation/screens/widget/back_buttom.dart';
import 'package:clean_login/presentation/screens/widget/boton_azul.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../injection_dependency.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _preferences = getIt<Preferences>();
    return Container(
        color: claro,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Cerrar Sesión",
                      style: TextStyle(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Spacer(),
                BackButtomContainer()
              ],
            ),
            Expanded(
              child: Container(
                color: claro,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BotonPrincipal(
                titulo: 'Cerrar sesion',
                onPressed: () async {
                  await _preferences.removeUser();
                  Provider.of<PostProvider>(context, listen: false).data.clear();
                  
                  Navigator.pushReplacementNamed(context, Routes.LOGIN);
                },
                height: 55,
                widtgh: double.infinity,
              ),
            )
          ],
        ));
  }
}
