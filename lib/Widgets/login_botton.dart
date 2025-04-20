import 'package:flutter/material.dart';

import '../Utils/color/color.dart';
import '../Utils/dimens.dart';

class ContinueButton extends StatelessWidget {
  final String title;
  final dynamic onTap;
  const ContinueButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: amber,
        ),
        height: 40,
        width: double.infinity,
        // width: ,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: black, fontWeight: fWxLargeFont),
          ),
        ),
      ),
    );
  }
}
