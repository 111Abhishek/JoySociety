import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';

class TwoTextRowWidget extends StatelessWidget {
  final String title;
  final String value;

  TwoTextRowWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Text(title,
              style: poppinsRegular.copyWith(
                  fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        Expanded(
          child: Text(value,
              style: poppinsRegular.copyWith(
                  fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
      ]),
    );
  }
}
