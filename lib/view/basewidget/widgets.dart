

import 'package:flutter/cupertino.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/system_utils.dart';
import 'package:joy_society/utill/text_utils.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';

/// Handle error and loading widget when using FutureBuilder or StreamBuilder
Widget snapWidgetHelper<T>(
    AsyncSnapshot<T> snap, {
      Widget? errorWidget,
      Widget? loadingWidget,
      String? defaultErrorMessage,
      @Deprecated('Do not use this') bool checkHasData = false,
      Widget Function(String)? errorBuilder,
    }) {
  if (snap.hasError) {
    log(snap.error);
    if (errorBuilder != null) {
      return errorBuilder.call(defaultErrorMessage ?? snap.error.toString());
    }
    return errorWidget ??
        Text(
          defaultErrorMessage ?? snap.error.toString(),
          style: poppinsRegular.copyWith(fontSize: 14),
        ).center();
  } else if (!snap.hasData) {
    return loadingWidget ?? Loader();
  } else {
    return SizedBox();
  }
}