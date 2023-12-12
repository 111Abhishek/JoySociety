

// Primary Text Style
import 'dart:ui';

import 'package:joy_society/utill/app_constants.dart';

TextStyle? primaryTextStyle({
  int? size,
  Color? color,
  FontWeight? weight,
  String? fontFamily,
  double? letterSpacing,
  FontStyle? fontStyle,
  double? wordSpacing,
  TextDecoration? decoration,
  TextDecorationStyle? textDecorationStyle,
  TextBaseline? textBaseline,
  Color? decorationColor,
  Color? backgroundColor,
  double? height,
}) {
  return TextStyle(
    fontSize: size != null ? size.toDouble() : AppConstants.textPrimarySizeGlobal,
    color: color ?? AppConstants.textPrimaryColorGlobal,
    fontWeight: weight ?? AppConstants.fontWeightPrimaryGlobal,
    fontFamily: fontFamily ?? AppConstants.fontFamilyPrimaryGlobal,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    decoration: decoration,
    decorationStyle: textDecorationStyle,
    decorationColor: decorationColor,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    height: height,
  );
}