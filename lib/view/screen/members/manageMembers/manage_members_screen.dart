import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/view/screen/members/InviteNewMembers/invite_new_members_screen.dart';
import 'package:joy_society/view/screen/members/requestToJoin/requests_to_join_screen.dart';
import 'package:joy_society/view/screen/members/sentInvites/sent_invites_screen.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constants.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class ManageMembersScreen extends StatefulWidget {
  final TopicModel? topicModel;

  const ManageMembersScreen({Key? key, this.topicModel}) : super(key: key);

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool isPrivateChatSwitched = false;
  bool isAllMemeberChatSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          //  _emailController.text = profile.userPhoneEmailModel?.email ?? "";
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
                  Image.asset(Images.logo_with_name_image,
                      height: 40, width: 40),
                  const SizedBox(width: 10),
                  Text(getTranslated('ALL_NETWORK_MEMBERS', context),
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]),
              ),
              Container(
                padding: const EdgeInsets.only(top: 90),
                child: ListView(physics: BouncingScrollPhysics(), children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(left: 16, right: 8),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1))
                                // changes position of shadow
                              ],
                            ),
                            child: Column(
                              children: [
                                Text('36', style: poppinsBold.copyWith(fontSize: 34, color: Colors.black)),
                                Text('Members', style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8, right: 16),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1))
                                // changes position of shadow
                              ],
                            ),
                            child: Column(
                              children: [
                                Text('32', style: poppinsBold.copyWith(fontSize: 34, color: Colors.black)),
                                Text('Referred Members', style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ]),

                  // Buttons for member list and invite new members
                  Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: CustomButton(
                                onTap: () { Navigator.pop(context); },
                                buttonText:
                                getTranslated('MEMBER_LIST', context)),
                          ),
                        ],
                      )),
                  Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                                vertical: Dimensions.MARGIN_SIZE_LARGE),
                            child: CustomButton(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => InviteNewMembersScreen()));
                                },
                                buttonText: getTranslated('INVITE_NEW_MEMBERS', context)),
                          ),
                        ],
                      )),

                  // Member Communication
                  Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Text(
                        getTranslated(
                            'MEMBER_COMMUNICATION', context),
                        style: poppinsBold.copyWith(fontSize: 16, color: Colors.black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Text(
                        getTranslated(
                            'member_communication_desc', context),
                        style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                  ),

                  // Private Chat
                  Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Text(
                        getTranslated(
                            'PRIVATE_CHAT', context),
                        style: poppinsBold.copyWith(fontSize: 16, color: Colors.black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Text(
                        getTranslated(
                            'private_chat_desc', context),
                        style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Switch(
                      value: isPrivateChatSwitched,
                      onChanged: (value) {
                        setState(() {
                          isPrivateChatSwitched = value;
                          print(isPrivateChatSwitched);
                        });
                      },
                      activeTrackColor: ColorResources.SECONDARY_COLOR,
                      activeColor: Colors.green,
                    ),
                  ),

                  // All Member Chat
                  Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Text(
                        getTranslated(
                            'ALL_MEMBER_CHAT', context),
                        style: poppinsBold.copyWith(fontSize: 16, color: Colors.black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Text(
                        getTranslated(
                            'all_memeber_chat_desc', context),
                        style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Switch(
                      value: isAllMemeberChatSwitched,
                      onChanged: (value) {
                        setState(() {
                          isAllMemeberChatSwitched = value;
                          print(isAllMemeberChatSwitched);
                        });
                      },
                      activeTrackColor: ColorResources.SECONDARY_COLOR,
                      activeColor: Colors.green,
                    ),
                  ),

                  // Incoming Members
                  Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Text(
                        getTranslated('INCOMING_MEMBERS', context),
                        style: poppinsBold.copyWith(fontSize: 20, color: Colors.black)),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                            left: Dimensions.MARGIN_SIZE_DEFAULT,
                            right: Dimensions.MARGIN_SIZE_DEFAULT),
                        child: CustomButton(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RequestsToJoinScreen()));
                            },
                            buttonText:
                                getTranslated('REQUEST_TO_JOIN', context)),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                            vertical: Dimensions.MARGIN_SIZE_LARGE),
                        child: CustomButton(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SentInvitesScreen()));
                            },
                            buttonText: getTranslated('SENT_INVITES', context), isCapital: true,),
                      ),
                    ],
                  )),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
