import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/content/content_list_screen.dart';
import 'package:joy_society/view/screen/goals/goals_home_screen.dart';
import 'package:joy_society/view/screen/members/memberList/members_list_screen.dart';

import '../../../localization/language_constants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';

class NetworkSettingScreen extends StatefulWidget {
  const NetworkSettingScreen({Key? key}) : super(key: key);

  @override
  State<NetworkSettingScreen> createState() => _NetworkSettingScreenState();
}

class _NetworkSettingScreenState extends State<NetworkSettingScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _onContentClick() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ContentListScreen()));
  }

  void _onMembersClick() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MembersListScreen()));
  }

  void _onGoalSettingsClick() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => GoalsHomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
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
              Image.asset(Images.logo_with_name_image, height: 40, width: 40),
              const SizedBox(width: 10),
              Text(getTranslated('NETWORK_SETTINGS', context),
                  style:
                      poppinsBold.copyWith(fontSize: 20, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
         Container(
           padding: const EdgeInsets.only(top: 80),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
               Expanded(
                 child: Container(
                   decoration: BoxDecoration(
                       color: ColorResources.getIconBg(context),
                       borderRadius: const BorderRadius.only(
                         topLeft: Radius.circular(
                             Dimensions.MARGIN_SIZE_DEFAULT),
                         topRight: Radius.circular(
                             Dimensions.MARGIN_SIZE_DEFAULT),
                       ),
                   ),
                   child: ListView(
                     physics: const BouncingScrollPhysics(),
                     children: [
                       // general setting
                       Container(
                         height: 100,
                         margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
                         decoration: const BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                         ),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Image.asset(
                                   Images.icon_general_setting,
                                   height: 48,
                                   width: 48,
                                 ),
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Text(
                                   getTranslated('GENERAL_SETTINGS', context),
                                   style: poppinsRegular.copyWith(
                                       fontSize: 16, color: Colors.black),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                       const SizedBox(
                         height: 20,
                       ),
                       Container(
                         height: 100,
                         margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
                         decoration: const BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                         ),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Image.asset(
                                   Images.icon_content,
                                   height: 48,
                                   width: 48,
                                 ),
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Text(
                                   getTranslated('CONTENT', context),
                                   style: poppinsRegular.copyWith(
                                       fontSize: 16, color: Colors.black),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ).onTap(_onContentClick),
                       const SizedBox(
                         height: 20,
                       ),
                       Container(
                         height: 100,
                         margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
                         decoration: const BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                         ),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Image.asset(
                                   Images.icon_member,
                                   height: 48,
                                   width: 48,
                                 ),
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Text(
                                   getTranslated('MEMBERS', context),
                                   style: poppinsRegular.copyWith(
                                       fontSize: 16, color: Colors.black),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ).onTap(_onMembersClick),
                       const SizedBox(
                         height: 20,
                       ),
                       Container(
                         height: 100,
                         margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
                         decoration: const BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                         ),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Image.asset(
                                   Images.icon_goal,
                                   height: 48,
                                   width: 48,
                                 ),
                                 const SizedBox(
                                   width: 30,
                                 ),
                                 Text(
                                   getTranslated('GOAL_SETTINGS', context),
                                   style: poppinsRegular.copyWith(
                                       fontSize: 16, color: Colors.black),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ).onTap(_onGoalSettingsClick),
                     ],
                   ),
                 ),
               ),
             ],
           ),
         )
        ],
      ),
    );
  }
}
