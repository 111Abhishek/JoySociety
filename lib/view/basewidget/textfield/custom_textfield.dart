import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool? isPhoneNumber;
  final bool? isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Color blackBorderColor;

  CustomTextField(
      {this.controller,
      this.hintText,
      this.textInputType,
      this.maxLine,
      this.focusNode,
      this.nextNode,
      this.textInputAction,
      this.isPhoneNumber = false,
      this.isValidator = false,
      this.blackBorderColor= ColorResources.WHITE,
      this.validatorMessage,
      this.inputFormatters,
      this.capitalization = TextCapitalization.none,
      this.fillColor,
      this.onChanged});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        border: Border.all(color: blackBorderColor),
        borderRadius: isPhoneNumber!
            ? const BorderRadius.only(
                topRight: Radius.circular(10), bottomRight: Radius.circular(10))
            : BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1)) // changes position of shadow
        ],
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        controller: controller,

        maxLines: maxLine ?? 1,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber! ? 15 : null,
        style: poppinsRegular.copyWith(
            fontSize: Dimensions.FONT_SIZE_DEFAULT,
            color: ColorResources.BLACK),
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        //keyboardType: TextInputType.number,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        //autovalidate: true,
        inputFormatters: [
              isPhoneNumber!
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.singleLineFormatter
            ] +
            (inputFormatters ?? []),
        validator: (input) {
          if (input!.isEmpty) {
            if (isValidator!) {
              return validatorMessage ?? "";
            }
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          isDense: true,
          counterText: '',
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorResources.DARK_GREEN_COLOR)),
          hintStyle: poppinsRegular.copyWith(
              color: Theme.of(context).hintColor,
              fontSize: Dimensions.FONT_SIZE_DEFAULT),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
