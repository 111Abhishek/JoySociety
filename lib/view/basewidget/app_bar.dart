

import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/system_utils.dart';

AppBar appBar(BuildContext context, String title, {List<Widget>? actions, bool showBack = true, Color? color, Color? iconColor, Color? textColor}) {
  return AppBar(
    toolbarHeight: 86,
    automaticallyImplyLeading: false,
    backgroundColor: color ?? ColorResources.APP_BACKGROUND_COLOR/* ?? appStore.appBarColor*/,
    leading: showBack
        ? IconButton(
      onPressed: () {
        finish(context);
      },
      icon: Icon(Icons.arrow_back_ios, color: ColorResources.GRAY_TEXT_COLOR),
    )
        : null,
    titleSpacing: 0,
    title: Row(
        children: [
          Image.asset(Images.logo_with_name_image,
              height: 40, width: 40),
          const SizedBox(width: 10),
          Text(title,
              style: poppinsBold.copyWith(
                  fontSize: 20, color: ColorResources.TEXT_BLACK_COLOR),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
    ),
    actions: actions,
    elevation: 0.5,

  );
}

