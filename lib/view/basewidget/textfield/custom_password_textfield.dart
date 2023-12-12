import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';

class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;

  CustomPasswordTextField({this.controller, this.hintTxt, this.focusNode, this.nextNode, this.textInputAction});

  @override
  _CustomPasswordTextFieldState createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)) // changes position of shadow
        ],
      ),
        child: TextFormField(
          cursorColor: Theme.of(context).primaryColor,
          controller: widget.controller,
          obscureText: _obscureText,
          focusNode: widget.focusNode,
          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
              color: ColorResources.BLACK),
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          onFieldSubmitted: (v) {
            setState(() {
              widget.textInputAction == TextInputAction.done
                  ? FocusScope.of(context).consumeKeyboardToken()
                  : FocusScope.of(context).requestFocus(widget.nextNode);
            });
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility), onPressed: _toggle,
                  color: Theme.of(context).hintColor),
              hintText: widget.hintTxt ?? '',
              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              isDense: true,
              fillColor: Theme.of(context).highlightColor,
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.DARK_GREEN_COLOR)),
              hintStyle: poppinsRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_DEFAULT),
              border: InputBorder.none),
        ),
    );
  }
}
