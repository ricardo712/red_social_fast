import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Image(image: AssetImage('assets/img/Login.png'), width: size.width * 0.3,),
          ],
        ),
      ),
    );
  }
}
