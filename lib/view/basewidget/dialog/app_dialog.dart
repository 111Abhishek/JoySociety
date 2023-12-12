import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';

class AppDialog extends StatelessWidget {
  String? title;
  String? content;
  String errorMessage ;
  Function()? cancelOnPressed;
  Function()? submitOnPressed;
  String? cancelButtonText;
  String? submitButtonText;
  bool isButtonLayoutVertical;
  String? dialogIcon;
  bool dialogIconVisibility;

  BuildContext context;

  AppDialog(
      {required this.context,
      this.title,
      this.content,
      this.errorMessage = "",
      required this.cancelOnPressed,
      required this.submitOnPressed,
      this.cancelButtonText,
      this.submitButtonText,
      this.isButtonLayoutVertical = false,
      this.dialogIcon = Images.icon_delete_dialog,
      this.dialogIconVisibility = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(Dimensions.MARGIN_SIZE_LARGE),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_DEFAULT),
              child: Center(
                child: Image.asset(dialogIcon!,
                    fit: BoxFit.fitWidth,
                    width: 80,
                    height: 80,)
              ),
            ).visible(dialogIconVisibility),
            Center(
              child: Text(
                title ?? "",
                style: poppinsBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_SMALL,
            ),
            Center(
              child: Text(
                content ?? "",
                style: poppinsRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                errorMessage ?? "",
                style: poppinsRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  color: Colors.red
                ),
                textAlign: TextAlign.center,
              ),
            ).visible(errorMessage.isNotEmpty).marginOnly(top: 20),
            // Vertical buttons
            Visibility(
                visible: isButtonLayoutVertical,
                child: Column(
                  children: [
                    Visibility(
                      visible: cancelButtonText != null,
                      child: Container(
                        margin:
                            EdgeInsets.only(top: Dimensions.MARGIN_SIZE_LARGE),
                        alignment: AlignmentDirectional.centerEnd,
                        child: CustomButtonSecondary(
                          buttonText: cancelButtonText ?? "",
                          borderColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          textColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          textStyle: poppinsRegular,
                          onTap: cancelOnPressed,
                        ),
                      ),
                    ),
                    Visibility(
                        visible: submitButtonText != null,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: Dimensions.MARGIN_SIZE_DEFAULT),
                          alignment: AlignmentDirectional.centerEnd,
                          child: CustomButton(
                            buttonText: submitButtonText ?? "",
                            onTap: submitOnPressed,
                          ),
                        )),
                  ],
                )),
            // Horizontal buttons
            Visibility(
                visible: !isButtonLayoutVertical,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: cancelButtonText != null,
                        child: Expanded(
                          flex: 1,
                          child:Container(
                          margin: EdgeInsets.only(
                              top: Dimensions.MARGIN_SIZE_LARGE,
                          right: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          alignment: AlignmentDirectional.centerEnd,
                          child: CustomButtonSecondary(
                            buttonText: cancelButtonText ?? "",
                            borderColor:
                                ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                            textColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                            textStyle: poppinsRegular,
                            onTap: cancelOnPressed,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                          visible: submitButtonText != null,
                          child: Expanded(
                              flex: 1,
                              child:Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_LARGE,
                                left: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            alignment: AlignmentDirectional.centerEnd,
                            child: CustomButtonSecondary(
                              buttonText: submitButtonText ?? "",
                              borderColor: Theme.of(context).primaryColor,
                              bgColor: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              textStyle: poppinsBold,
                              onTap: submitOnPressed,
                            ),
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
