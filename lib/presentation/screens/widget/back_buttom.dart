import 'package:clean_login/core/framework/colors.dart';
import 'package:flutter/material.dart';

class BackButtomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: EdgeInsets.all(8),
      child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primary,
                  width: 1,
                ),
              ),
              child: BackButton(
                color: primary,
              ))),
    );
  }
}
