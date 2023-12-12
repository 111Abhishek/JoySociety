import 'package:flutter/material.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/theme_provider.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/basewidget/animated_custom_dialog.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/my_dialog.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/auth/auth_screen.dart';
import 'package:provider/provider.dart';

class ResetPasswordWithOtpScreen extends StatefulWidget {
  final String mobileNumber;

  //final String otp;
  const ResetPasswordWithOtpScreen({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  _ResetPasswordWithOtpState createState() => _ResetPasswordWithOtpState();
}

class _ResetPasswordWithOtpState extends State<ResetPasswordWithOtpScreen> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _otpController;
  FocusNode _otpNode = FocusNode();
  FocusNode _newPasswordNode = FocusNode();
  FocusNode _confirmPasswordNode = FocusNode();

  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _otpController = TextEditingController();
    super.initState();
  }

  void resetPassword() async {
    // if (_formKeyReset.currentState.validate()) {
    //   _formKeyReset.currentState.save();

    showAnimatedDialog(
        context,
        MyDialog(
          icon: Icons.send,
          title: getTranslated(
              'ALERT_PASS_RESET_SUCCESSFULLY', context),
          description: '',
          rotateAngle: 5.5,
        ),
        dismissible: false);

    String _otp = _otpController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('input_valid_otp', context)),
        backgroundColor: Colors.red,
      ));
    } else if (_password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('PASSWORD_MUST_BE_REQUIRED', context)),
        backgroundColor: Colors.red,
      ));
    } else if (_confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(getTranslated('CONFIRM_PASSWORD_MUST_BE_REQUIRED', context)),
        backgroundColor: Colors.red,
      ));
    } else if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)),
        backgroundColor: Colors.red,
      ));
    } else {
      //reset Condition here
      Provider.of<AuthProvider>(context, listen: false)
          .resetPassword(
              widget.mobileNumber, "widget.otp", _password, _confirmPassword)
          .then((value) {
        if (value.isSuccess!) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(getTranslated('password_reset_successfully', context)),
            backgroundColor: Colors.green,
          ));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => AuthScreen()),
              (route) => false);
        } else {
          showCustomSnackBar(value.message!, context);
        }
      });
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(children: [
            Stack(clipBehavior: Clip.none, children: [
              Provider.of<ThemeProvider>(context).darkTheme
                  ? SizedBox()
                  : Image.asset(
                      Images.background_login,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ),
              SafeArea(
                  child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Theme.of(context).cardColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 130),
                    // for logo with text
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(Images.logo_with_name_image,
                          height: 82, width: 82),
                    ),

                    SizedBox(height: 77),

                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(62),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: Dimensions.MARGIN_SIZE_DEFAULT,
                            right: Dimensions.MARGIN_SIZE_DEFAULT),
                        child: Column(
                          //padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 34),
                            Center(
                                child: Text(
                                    getTranslated('RESET_PASSWORD', context),
                                    style: poppinsBold.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_LARGE))),
                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
                            Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.MARGIN_SIZE_SMALL,
                                    right: Dimensions.MARGIN_SIZE_SMALL,
                                    bottom: Dimensions.MARGIN_SIZE_SMALL),
                                child: CustomTextField(
                                  hintText:
                                      getTranslated('ENTER_OTP', context),
                                  focusNode: _otpNode,
                                  nextNode: _newPasswordNode,
                                  controller: _otpController,
                                )),

                            Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.MARGIN_SIZE_SMALL,
                                    right: Dimensions.MARGIN_SIZE_SMALL,
                                    bottom: Dimensions.MARGIN_SIZE_SMALL),
                                child: CustomPasswordTextField(
                                  hintTxt:
                                      getTranslated('NEW_PASSWORD', context),
                                  focusNode: _newPasswordNode,
                                  nextNode: _confirmPasswordNode,
                                  controller: _passwordController,
                                )),

                            // for confirm Password
                            Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.MARGIN_SIZE_SMALL,
                                    right: Dimensions.MARGIN_SIZE_SMALL,
                                    bottom: Dimensions.MARGIN_SIZE_DEFAULT),
                                child: CustomPasswordTextField(
                                  hintTxt: getTranslated(
                                      'hint_re_enter_password', context),
                                  textInputAction: TextInputAction.done,
                                  focusNode: _confirmPasswordNode,
                                  controller: _confirmPasswordController,
                                )),

                            // for reset button
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20, top: 0),
                              child: Provider.of<AuthProvider>(context)
                                      .isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  : CustomButton(
                                      onTap: resetPassword,
                                      buttonText:
                                          getTranslated('SEND', context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
