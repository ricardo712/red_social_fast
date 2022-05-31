import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

 void showSnackBar(
    BuildContext context, String titulo, String descripcion) async {
  await Flushbar(
    title: titulo,
    flushbarPosition: FlushbarPosition.BOTTOM,
    message: descripcion,
    duration: Duration(seconds: 3),
  ).show(context);
}
