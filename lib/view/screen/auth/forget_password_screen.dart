import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/splash_provider.dart';
import 'package:joy_society/provider/theme_provider.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/basewidget/animated_custom_dialog.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/my_dialog.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/auth/forgot_password_email_sent.dart';
import 'package:joy_society/view/screen/auth/reset_password_with_otp_screen.dart';
import 'package:joy_society/view/screen/auth/widget/code_picker_widget.dart';
import 'package:joy_society/view/screen/auth/widget/otp_verification_screen.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();
  String? _countryDialCode = '+880';

  @override
  void initState() {
    _countryDialCode = '+91';
    /*_countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .countryCode!)
        .dialCode;*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Provider.of<ThemeProvider>(context).darkTheme
                    ? SizedBox()
                    : Image.asset(Images.background_login,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,),
                SafeArea(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_outlined, color: Theme.of(context).cardColor,),
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
                            children: [
                              SizedBox(height: 34),
                              Center(
                                  child: Text(
                                      getTranslated('FORGOT_PASSWORD', context),
                                      style: poppinsBold.copyWith(
                                          fontSize: Dimensions
                                              .FONT_SIZE_EXTRA_LARGE))),
                              SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
                              Padding(
                                  padding:EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                child: Provider.of<SplashProvider>(context, listen: false)
                                    .configModel
                                    ?.forgetPasswordVerification ==
                                    "phone"
                                    ? Text(
                                    textAlign: TextAlign.center,
                                    getTranslated(
                                        'enter_phone_number_for_password_reset',
                                        context),
                                    style: poppinsRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                        fontSize:
                                        Dimensions.FONT_SIZE_LARGE))
                                    : Text(
                                    textAlign: TextAlign.center,
                                    getTranslated(
                                        'enter_email_for_password_reset', context),
                                    style: poppinsRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                        fontSize: Dimensions
                                            .FONT_SIZE_LARGE, )),
                              ),
                              SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                              Provider.of<SplashProvider>(context,
                                              listen: false)
                                          .configModel
                                          ?.forgetPasswordVerification ==
                                      "phone"
                                  ? Row(children: [
                                      CodePickerWidget(
                                        onChanged: (CountryCode countryCode) {
                                          _countryDialCode =
                                              countryCode.dialCode;
                                        },
                                        initialSelection: _countryDialCode,
                                        favorite: [_countryDialCode!],
                                        showDropDownButton: true,
                                        padding: EdgeInsets.zero,
                                        showFlagMain: true,
                                        textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                ?.color),
                                      ),
                                      Expanded(
                                          child: CustomTextField(
                                        hintText: getTranslated(
                                            'number_hint', context),
                                        controller: _numberController,
                                        focusNode: _numberFocus,
                                        isPhoneNumber: true,
                                        textInputAction: TextInputAction.done,
                                        textInputType: TextInputType.phone,
                                      )),
                                    ])
                                  : CustomTextField(
                                      controller: _controller,
                                      hintText: getTranslated(
                                          'ENTER_EMAIL_OR_MOBILE', context),
                                      textInputAction: TextInputAction.done,
                                      textInputType: TextInputType.emailAddress,
                                    ),
                              SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                              Builder(
                                builder: (context) => !Provider.of<
                                            AuthProvider>(context)
                                        .isLoading
                                    ? CustomButton(
                                        buttonText: Provider.of<SplashProvider>(
                                                        context,
                                                        listen: false)
                                                    .configModel
                                                    ?.forgetPasswordVerification ==
                                                "phone"
                                            ? getTranslated('send_otp', context)
                                            : getTranslated('SEND', context),
                                        onTap: () {

                                          /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => ForgetPasswordEmailSentScreen()),
                                                  (route) => false);*/

                                          Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordWithOtpScreen(mobileNumber : _numberController.text.trim())));

                                          if (Provider.of<SplashProvider>(
                                                      context,
                                                      listen: false)
                                                  .configModel
                                                  ?.forgetPasswordVerification ==
                                              "phone") {
                                            if (_numberController
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(getTranslated(
                                                    'PHONE_MUST_BE_REQUIRED',
                                                    context)),
                                                backgroundColor: Colors.red,
                                              ));
                                            } else {
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .forgetPassword(
                                                      _countryDialCode! +
                                                          _numberController.text
                                                              .trim())
                                                  .then((value) {
                                                if (value.isSuccess!) {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              //VerificationScreen('', _countryDialCode! + _numberController.text.trim(), '')),
                                                          ResetPasswordWithOtpScreen( mobileNumber : _numberController.text.trim())),
                                                      (route) => false);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(getTranslated(
                                                        'input_valid_phone_number',
                                                        context)),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                }
                                              });
                                            }
                                          } else {
                                            if (_controller.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(getTranslated(
                                                    'EMAIL_MUST_BE_REQUIRED',
                                                    context)),
                                                backgroundColor: Colors.red,
                                              ));
                                            } else {
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .forgetPassword(
                                                      _controller.text)
                                                  .then((value) {
                                                if (value.isSuccess!) {
                                                  FocusScopeNode currentFocus =
                                                      FocusScope.of(context);
                                                  if (!currentFocus
                                                      .hasPrimaryFocus) {
                                                    currentFocus.unfocus();
                                                  }
                                                  _controller.clear();

                                                  showAnimatedDialog(
                                                      context,
                                                      MyDialog(
                                                        icon: Icons.send,
                                                        title: getTranslated(
                                                            'sent', context),
                                                        description: getTranslated(
                                                            'recovery_link_sent',
                                                            context),
                                                        rotateAngle: 5.5,
                                                      ),
                                                      dismissible: false);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content:
                                                        Text(value.message!),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                }
                                              });
                                            }
                                          }
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      )
    );
  }
}
