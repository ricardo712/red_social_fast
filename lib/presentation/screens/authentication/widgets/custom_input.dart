import 'package:clean_login/core/framework/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeHolder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final String typeFormatters;
  final TextInputAction? textInputAction;
  final bool enabled;

  const CustomInput(
      {Key? key,
      required this.icon,
      required this.placeHolder,
      required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      this.validator,
      this.typeFormatters = "text",
      this.textInputAction,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: TextFormField(
            controller: textController,
            obscureText: this.isPassword,
            autocorrect: false,
            // autofocus: true,
            
            textCapitalization: TextCapitalization.words,
            keyboardType: this.keyboardType,
            textInputAction: TextInputAction.next, // Moves focus to next.
            maxLength: this.placeHolder == 'Identificacion' ? 10 : 250,
            enabled: this.enabled,
            cursorColor: primary,
            inputFormatters: <TextInputFormatter>[
              if (typeFormatters == 'number')
                FilteringTextInputFormatter.digitsOnly,
              if (typeFormatters == 'text')
                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú]")),
              if (typeFormatters == 'todo')
                FilteringTextInputFormatter.singleLineFormatter,
            ],
            decoration: new InputDecoration(
                counterText: "",
                errorStyle: TextStyle(fontSize: 12.0, color: secondary),
                // labelText: this.placeHolder,
                prefixIcon: Icon(this.icon, color: primary),
                filled: true,

                
                fillColor: Colors.white,
                hintText: this.placeHolder,
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: new OutlineInputBorder(

                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                      color: primary,
                      width: 0.5,
                      // style: BorderStyle.none
                    )),
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color:  Colors.black, style: BorderStyle.none, width: 0.0))),
            style: new TextStyle(color: primary),
            validator: validator));
  }
}
