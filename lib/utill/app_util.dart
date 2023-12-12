import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/utill/extensions/extensions.dart';

class AppUtil {
  static showToast(
      {required BuildContext context,
      required String message,
      required bool isSuccess}) {
    Get.snackbar(
        isSuccess == true
            ? 'Success'
            : 'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isSuccess == true
            ? Theme.of(context).primaryColor
            : Theme.of(context).errorColor.lighten(),
        icon: Icon(Icons.error, color: Theme.of(context).iconTheme.color));
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Widget addProgressIndicator(BuildContext context, double? size) {
    return Center(
        child: SizedBox(
      width: size ?? 50,
      height: size ?? 50,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Colors.black12,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
    ));
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
