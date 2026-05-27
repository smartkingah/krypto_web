import 'package:flutter/material.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';

Widget contItem({icon, title, onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFF353945),
          radius: 25,
          child: Icon(
            icon,
            color: white,
            size: kTextSmallHigh,
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: white,
            fontWeight: fWLargeFont,
            fontSize: kTextTinyHigh,
          ),
        )
      ],
    ),
  );
}
