import 'package:flutter/material.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/theme_provider.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/auth/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final int initialPage;

  SignUpScreen({this.initialPage = 0});

  @override
  Widget build(BuildContext context) {
    //Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<AuthProvider>(context, listen: false).isRemember;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Provider.of<ThemeProvider>(context).darkTheme
                      ? SizedBox()
                      : Image.asset(Images.background_login,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width),

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
                          child: Image.asset(Images.logo_with_name_image, height: 82, width: 82),
                        ),

                        SizedBox(height: 77),

                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(62),
                            ),
                          ),
                          child: SignUpWidget(),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
        ],
        ),
      ),
    );
  }
}
