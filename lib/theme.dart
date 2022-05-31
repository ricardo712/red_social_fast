import 'package:flutter/material.dart';

import 'core/framework/colors.dart';

class AppTheme {
  static buildTheme() => ThemeData(
        fontFamily: "Poppins",
        primaryColor: primary,
        // accentColor: secondary,
        colorScheme: ColorScheme.fromSwatch(accentColor: secondary),

        brightness: Brightness.light,
        backgroundColor: claro,
        iconTheme: IconThemeData(
          color: oscuro,
        ),
      );
}
