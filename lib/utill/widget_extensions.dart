

import 'package:flutter/material.dart';
import 'package:joy_society/utill/common.dart';
import 'package:joy_society/utill/decorations.dart';


double? defaultInkWellRadius;
Color? defaultInkWellSplashColor;
Color? defaultInkWellHoverColor;
Color? defaultInkWellHighlightColor;


extension WidgetExtension on Widget? {
  /// add tap to parent widget
  Widget onTap(Function? function, {
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? hoverColor,
    Color? highlightColor,
  }) {
    return InkWell(
      onTap: function as void Function()?,
      borderRadius: borderRadius ??
          (defaultInkWellRadius != null ? radius(defaultInkWellRadius) : null),
      child: this,
      splashColor: splashColor ?? defaultInkWellSplashColor,
      hoverColor: hoverColor ?? defaultInkWellHoverColor,
      highlightColor: highlightColor ?? defaultInkWellHighlightColor,
    );
  }

  /// return padding all
  Padding paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// add Expanded to parent widget
  Widget expand({flex = 1}) => Expanded(child: this!, flex: flex);

  /// set parent widget in center
  Widget center({double? heightFactor, double? widthFactor}) {
    return Center(
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      child: this,
    );
  }

  /// set visibility
  Widget visible(bool visible, {Widget? defaultWidget}) {
    return visible ? this! : (defaultWidget ?? SizedBox());
  }
}