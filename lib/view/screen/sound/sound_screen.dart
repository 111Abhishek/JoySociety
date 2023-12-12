import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:provider/provider.dart';

import '../../../localization/language_constants.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';

class SoundScreen extends StatefulWidget {
  @override
  _SoundScreenState createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isSwitched = false;

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
          //_phoneController.text = profile.userInfoModel?.phone ?? "";
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
                  Text(getTranslated('SOUND', context),
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
                          // title
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Column(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          getTranslated(
                                              'PUSH_NOTIFICATION_DENIED',
                                              context),
                                          style: poppinsBold.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_LARGE,)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          //for dsc
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
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
                                          'PUSH_NOTIFICATION_DENIED_DESC',
                                          context),
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: ColorResources.HINT_TEXT_COLOR
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                              ],
                            ),
                          ),
                          //switch1
                          Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Row(
                              children: [
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      print(isSwitched);
                                    });
                                  },
                                  activeTrackColor: ColorResources.SECONDARY_COLOR,
                                  activeColor: Colors.green,
                                ),
                                const SizedBox(
                                    width: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            getTranslated(
                                                'NOTIFICATION_TITLE', context),
                                            style: customTextFieldTitleMedium),
                                      ],
                                    ),
                                    Text(
                                        getTranslated(
                                            'NOTIFICATION_DESC', context),
                                        style: poppinsRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR,
                                            fontSize: Dimensions.FONT_SIZE_SMALL)),
                                    const SizedBox(height: 10),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          // divider1
                          const Divider(
                            color: ColorResources.DIVIDER_COLOR_LIGHT,
                            height: 25,
                            thickness: 1,
                            indent: 5,
                            endIndent: 5,
                          ),
                          //switch2
                          Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Row(
                              children: [
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      print(isSwitched);
                                    });
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                                const SizedBox(
                                    width: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'CHAT_TITLE', context),
                                                style: customTextFieldTitleMedium),
                                          ],
                                        ),
                                        Text(
                                            getTranslated(
                                                'CHAT_DESC', context),
                                            style: poppinsRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR,
                                                fontSize: Dimensions.FONT_SIZE_SMALL)),
                                        const SizedBox(height: 10),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          // divider2
                          const Divider(
                            color: ColorResources.DIVIDER_COLOR_LIGHT,
                            height: 25,
                            thickness: 1,
                            indent: 5,
                            endIndent: 5,
                          ),
                          //switch3
                          Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Row(
                              children: [
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      print(isSwitched);
                                    });
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                                const SizedBox(
                                    width: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'SYSTEM_TITLE', context),
                                                style: customTextFieldTitleMedium),
                                          ],
                                        ),
                                        Text(
                                            getTranslated(
                                                'SYSTEM_DESC', context),
                                            style: poppinsRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR,
                                                fontSize: Dimensions.FONT_SIZE_SMALL)),
                                        const SizedBox(height: 10),
                                      ],
                                    )),
                              ],
                            ),
                          ),
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
