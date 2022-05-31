import 'package:clean_login/core/framework/colors.dart';
import 'package:flutter/material.dart';


class CustomBtn extends StatelessWidget {
  const CustomBtn({
    Key? key,
    required this.loading,
    required this.textBtn,
    required this.onTap,
  }) : super(key: key);

  final bool loading;
  final String textBtn;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        child: AnimatedContainer(
          width: loading ? 60 : size.width,
          height: 55,
          duration: Duration(milliseconds: 400),
          decoration: BoxDecoration(
              color: primary, borderRadius: BorderRadius.circular(50)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loading
                  ? Center(
                      child: Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          )))
                  : Center(
                      child:
                          Text(textBtn, style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
        onTap: onTap);
  }
}
