import 'package:flutter/material.dart';

BoxDecoration baseWhiteBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme
        .of(context)
        .highlightColor,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1))
      // changes position of shadow
    ],
  );
}