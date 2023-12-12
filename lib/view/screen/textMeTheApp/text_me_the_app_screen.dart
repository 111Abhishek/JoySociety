import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:provider/provider.dart';

import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/show_custom_snakbar.dart';
import '../../basewidget/textfield/custom_textfield.dart';

class TextMeTheAppScreen extends StatefulWidget {

  @override
  _TextMeTheAppScreenState createState() => _TextMeTheAppScreenState();
}

class _TextMeTheAppScreenState extends State<TextMeTheAppScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _btnClick() async {
    showCustomSnackBar('Button Clicked', context, isError: false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          _phoneController.text = profile.userInfoModel?.phone ?? "";
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 48, left: 8),
                child: Row(children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(Images.logo_with_name_image,
                      height: 40, width: 40),
                  const SizedBox(width: 10),
                  Text(getTranslated('TEXT_ME_THE_APP', context),
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]),
              ),
              Container(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // for title
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        getTranslated(
                                            'TEXT_ME_THE_APP_TITLe', context),
                                        style: poppinsBold.copyWith(
                                            fontSize: 16, color: Colors.black),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                              ],
                            ),
                          ),
                          //for mobile number
                          Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT,
                                top: Dimensions.MARGIN_SIZE_SMALL),
                            child: CustomTextField(
                              hintText: getTranslated('number_hint', context),
                              focusNode: _phoneFocus,
                              textInputType: TextInputType.number,
                              controller: _phoneController,
                            ),
                          ),
                          //for valid title
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        getTranslated(
                                            'TEXT_ME_THE_APP_TITLe_2', context),
                                        style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.black
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_LARGE,
                                vertical: Dimensions.MARGIN_SIZE_SMALL),
                            child:
                                !Provider.of<ProfileProvider>(context).isLoading
                                    ? CustomButton(
                                        onTap: _btnClick,
                                        buttonText: getTranslated(
                                            'TEXT_ME_THE_APP_CAPITAL', context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor))),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_SMALL,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(
                                          'TEXT_ME_THE_APP_TITLe_3', context),
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
