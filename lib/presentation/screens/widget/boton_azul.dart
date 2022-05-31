import 'package:clean_login/core/framework/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BotonPrincipal extends StatelessWidget {
  final String  titulo;
  final double height;
  final double widtgh;
  final Function()? onPressed;

  const BotonPrincipal({Key? key, 
  required this.titulo, 
  required this.onPressed,
   required this.height,
   required this.widtgh}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: primary,// background
        onPrimary: Colors.white, // foreground
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      onPressed: this.onPressed,
      child: Container(
        height: height,
        width: widtgh,
        child: Center(
            child: Text(
          this.titulo,
          style: TextStyle(fontSize: 17),
        )),
      ),
    );
  }
}
