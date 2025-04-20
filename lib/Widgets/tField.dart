import 'package:flutter/material.dart';

import '../Utils/color/color.dart';
import '../Utils/dimens.dart';

class Tfield extends StatelessWidget {
  final String title, hint;
  final dynamic preIcon, suffixIcon;
  final bool obscure;
  final dynamic hor;
  final dynamic contr;
  const Tfield({
    super.key,
    this.obscure = false,
    this.hor = 10,
    required this.preIcon,
    required this.contr,
    required this.suffixIcon,
    required this.title,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hor),
      height: 37,
      child: TextField(
        controller: contr,
        style: TextStyle(color: white),
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF23262F),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: fWSmallFont,
            fontSize: kTextMini,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: preIcon,
          label: Text(title),
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: amber,
            ),
          ),
        ),
      ),
    );
  }
}
