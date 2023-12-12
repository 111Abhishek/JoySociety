import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/provider/need_help_provider.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/base/error_response.dart';

class NeedHelpScreen extends StatefulWidget {
  const NeedHelpScreen({super.key});

  @override
  State<NeedHelpScreen> createState() => _NeedHelpScreenState();
}

class _NeedHelpScreenState extends State<NeedHelpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.black,
            ),
            const SizedBox(width: 10),
            Image.asset(
              Images.logo_with_name_image,
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 16),
            Text(
              "Contact Us",
              style: poppinsBold.copyWith(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:',
                        style: poppinsSemiBold.copyWith(
                            fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: _nameController,
                        focusNode: nameFocusNode,
                        nextNode: emailFocusNode,
                        hintText: 'Enter your name',
                        textInputType: TextInputType.text,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:',
                        style: poppinsSemiBold.copyWith(
                            fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        focusNode: emailFocusNode,
                        nextNode: phoneFocusNode,
                        hintText: 'Enter your Email',
                        textInputType: TextInputType.emailAddress,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone no:',
                        style: poppinsSemiBold.copyWith(
                            fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: _phoneController,
                        focusNode: phoneFocusNode,
                        nextNode: messageFocusNode,
                        hintText: 'Enter your Phone No',
                        textInputType: TextInputType.number,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Message:',
                        style: poppinsSemiBold.copyWith(
                            fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: _messageController,
                        focusNode: messageFocusNode,
                        hintText: 'Enter your message',
                        textInputType: TextInputType.text,
                        maxLine: 4,
                        textInputAction: TextInputAction.done,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  child: CustomButton(
                    onTap: () {
                      Provider.of<NeedHelpProvider>(context, listen: false)
                          .NeedHelp(
                              _nameController.text,
                              _emailController.text,
                              _messageController.text,
                              _phoneController.text,
                              getNeedHelpContentCallback);
                    },
                    buttonText: 'Send Message',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getNeedHelpContentCallback(
      bool isStatusSuccess, ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Form submitted successFully"),
          backgroundColor: Colors.green));
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        errorDescription ??= 'Technical error, Please try again later!';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }
}
