/*import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/social_login_model.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/facebook_login_provider.dart';
import 'package:joy_society/provider/apple_login.dart';
import 'package:joy_society/provider/google_sign_in_provider.dart';
import 'package:joy_society/provider/splash_provider.dart';
import 'package:joy_society/provider/theme_provider.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'mobile_verify_screen.dart';
import 'otp_verification_screen.dart';

class SocialLoginWidget extends StatefulWidget {
  @override
  _SocialLoginWidgetState createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();

  route(bool isRoute, String token, String temporaryToken,
      String errorMessage) async {
    if (isRoute) {
      if (token != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DashBoardScreen()),
            (route) => false);
      } else if (temporaryToken != null && temporaryToken.isNotEmpty) {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .emailVerification!) {
          Provider.of<AuthProvider>(context, listen: false)
              .checkEmail(socialLogin.email.toString(), temporaryToken)
              .then((value) async {
            if (value.isSuccess!) {
              Provider.of<AuthProvider>(context, listen: false)
                  .updateEmail(socialLogin.email.toString());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => VerificationScreen(
                          temporaryToken, '', socialLogin.email.toString())),
                  (route) => false);
            }
          });
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => MobileVerificationScreen(temporaryToken)),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .socialLogin![0]
                .status
            ? Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .socialLogin![1]
                    .status
                ? Center()
                : Center()
            :*/
        SizedBox(),
        Container(
          color: Provider.of<ThemeProvider>(context).darkTheme
              ? Theme.of(context).canvasColor
              : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .socialLogin![0]
                      .status
                  ?*/
              InkWell(
                onTap: () async {
                  String id, token, email, medium;
                  String errorMessage =
                      ''; // Initialize errorMessage with an empty string

                  await Provider.of<GoogleSignInProvider>(context,
                          listen: false)
                      .login();

                  if (Provider.of<GoogleSignInProvider>(context, listen: false)
                          .googleAccount !=
                      null) {
                    id = Provider.of<GoogleSignInProvider>(context,
                            listen: false)
                        .googleAccount!
                        .id;
                    email = Provider.of<GoogleSignInProvider>(context,
                            listen: false)
                        .googleAccount!
                        .email;
                    token = Provider.of<GoogleSignInProvider>(context,
                            listen: false)
                        .auth!
                        .accessToken!;
                    medium = 'google';

                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;

                    print(
                        '===>info ===> $email   ====> $medium ====> $token   ==>$id');
                  } else {
                    // Handle the case where Google Sign-In fails and set an appropriate error message
                    errorMessage = 'Google Sign-In failed.';
                  }

                  /* await Provider.of<AuthProvider>(context, listen: false)
                      .socialLogin(
                    socialLogin,
                    route,
                    errorMessage: errorMessage ?? 'Default Error Message',
                  );*/
                },
                child: Ink(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          child: Image.asset(Images.google),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /*: SizedBox(),
              Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .socialLogin![1]
                      .status
                  ?*/
              InkWell(
                onTap: () async {
                  await Provider.of<FacebookLoginProvider>(context,
                          listen: false)
                      .login();

                  String id, token, email, medium;
                  if (Provider.of<FacebookLoginProvider>(context, listen: false)
                          .userData !=
                      null) {
                    id = Provider.of<FacebookLoginProvider>(context,
                            listen: false)
                        .result!
                        .accessToken!
                        .userId;
                    email = Provider.of<FacebookLoginProvider>(context,
                            listen: false)
                        .userData!['email'];
                    token = Provider.of<FacebookLoginProvider>(context,
                            listen: false)
                        .result!
                        .accessToken!
                        .token;
                    medium = 'facebook';

                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;
                    print(
                        '===>info ===> $email   ====> $medium ====> $token   ==>$id');

                    await Provider.of<AuthProvider>(context, listen: false)
                        .socialLogin(socialLogin, route);
                  }
                },
                child: Ink(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                            height: 56,
                            width: 56,
                            child: Image.asset(Images.facebook)),
                      ],
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: () async {
                  final credential = await AppleSignInHelper.signInWithApple();
                  if (credential != null) {
                    String id, token, email, medium;

                    // Extract information from the Apple credential
                    id = credential.userIdentifier ?? '';
                    email = credential.email ?? '';
                    token = credential.authorizationCode!;
                    medium = 'apple';

                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;
                    print(
                        '===>info ===> $email   ====> $medium ====> $token   ==>$id');

                    // Assuming you have an AuthProvider for handling authentication
                    await Provider.of<AuthProvider>(context, listen: false)
                        .socialLogin(socialLogin, route);
                  } else {
                    // Handle Apple Sign-In error or cancellation
                    print('Apple Sign-In Error: Sign-In cancelled or failed.');
                  }
                },
                child: Ink(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                          height: 56,
                          width: 56,
                          child: Image.asset(Images.apple)),
                    ],
                  ),
                )),
              ),
              //: SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}*/
