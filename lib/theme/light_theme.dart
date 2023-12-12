import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';

ThemeData light = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: Color(0xFF23D88B),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: Color(0xff696969),
  scaffoldBackgroundColor: ColorResources.SCREEN_BACKGROUND_COLOR,
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);