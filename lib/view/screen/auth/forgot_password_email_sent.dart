import 'package:flutter/material.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/theme_provider.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/screen/auth/auth_screen.dart';
import 'package:provider/provider.dart';

class ForgetPasswordEmailSentScreen extends StatefulWidget {
  @override
  State<ForgetPasswordEmailSentScreen> createState() =>
      _ForgetPasswordEmailSentState();
}

class _ForgetPasswordEmailSentState
    extends State<ForgetPasswordEmailSentScreen> {
  Future<bool> _onWillPop() async {
    return (await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => AuthScreen()),
            (route) => false)) ??
        false;
  }

  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        body: Container(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
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
                      onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => AuthScreen()),
                          (route) => false),
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
                            child: Column(children: [
                              SizedBox(height: 64),
                              Image.asset(Images.correct_yellow_circle,
                                  height: 80, width: 80),
                              SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                              Text(getTranslated('EMAIL_SENT', context),
                                  style: poppinsBold.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE)),
                              SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                              Text(
                                  textAlign: TextAlign.center,
                                  getTranslated('send_email_message', context),
                                  style: poppinsRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                  )),
                              SizedBox(
                                  height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                              CustomButton(
                                  buttonText:
                                      getTranslated('BACK_TO_SING_IN', context),
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AuthScreen()),
                                        (route) => false);
                                  }),
                            ]),
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
      ),
    );
  }
}
