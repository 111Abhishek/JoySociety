import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';


class CustomButtonSecondary extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonText;
  final bool isBuy;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color bgColor;
  final double fontSize;
  final double height;
  final bool isCapital;
  CustomButtonSecondary({this.onTap, required this.buttonText, this.isBuy= false,
    this.borderColor, this.textColor, this.textStyle = poppinsBold,
    this.bgColor = ColorResources.SCREEN_BACKGROUND_COLOR, this.fontSize = 18, this.height = 48,
    this.isCapital= true});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorResources.getChatIcon(context),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1), ), // changes position of shadow
            ],
            gradient: LinearGradient(colors: [
              bgColor,
              bgColor,
              bgColor,
            ]),
            borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor ?? Theme.of(context).primaryColor),
        ),
        child: Text(isCapital ? buttonText.toUpperCase() : buttonText,
            style: textStyle?.copyWith(
              fontSize: fontSize,
              color: textColor ?? Theme.of(context).primaryColor,
            )),
      ),
    );
  }
}
