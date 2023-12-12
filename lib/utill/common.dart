

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/extensions/context_extensions.dart';

T? makeNullable<T>(T? value) => value;

enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }

bool hasMatch(String? s, String p) {
  return (s == null) ? false : RegExp(p).hasMatch(s);
}

/// Hide soft keyboard
void hideKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());

/// Returns a string from Clipboard
Future<String> paste() async {
  ClipboardData? data = await Clipboard.getData('text/plain');
  return data?.text?.toString() ?? "";
}

/// Returns a string from Clipboard
Future<dynamic> pasteObject() async {
  ClipboardData? data = await Clipboard.getData('text/plain');
  return data;
}

enum LinkProvider {
  PLAY_STORE,
  APPSTORE,
  FACEBOOK,
  INSTAGRAM,
  LINKEDIN,
  TWITTER,
  YOUTUBE,
  REDDIT,
  TELEGRAM,
  WHATSAPP,
  FB_MESSENGER,
  GOOGLE_DRIVE
}

const double degrees2Radians = pi / 180.0;

double radians(double degrees) => degrees * degrees2Radians;

void afterBuildCreated(Function()? onCreated) {
  makeNullable(SchedulerBinding.instance)!
      .addPostFrameCallback((_) => onCreated?.call());
}

Route<T> buildPageRoute<T>(
    Widget child, PageRouteAnimation? pageRouteAnimation, Duration? duration) {
  if (pageRouteAnimation != null) {
    if (pageRouteAnimation == PageRouteAnimation.Fade) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: duration ?? AppConstants.pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) =>
            RotationTransition(child: child, turns: ReverseAnimation(anim)),
        transitionDuration: duration ?? AppConstants.pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) =>
            ScaleTransition(child: child, scale: anim),
        transitionDuration: duration ?? AppConstants.pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          child: child,
          position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
              .animate(anim),
        ),
        transitionDuration: duration ?? AppConstants.pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          child: child,
          position: Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
              .animate(anim),
        ),
        transitionDuration: duration ?? AppConstants.pageRouteTransitionDurationGlobal,
      );
    }
  }
  return MaterialPageRoute<T>(builder: (_) => child);
}

EdgeInsets dynamicAppButtonPadding(BuildContext context) {
  if (context.isDesktop()) {
    return EdgeInsets.symmetric(vertical: 20, horizontal: 20);
  } else if (context.isTablet()) {
    return EdgeInsets.symmetric(vertical: 16, horizontal: 16);
  } else {
    return EdgeInsets.symmetric(vertical: 14, horizontal: 16);
  }
}

