import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/provider/members_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constants.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class InviteNewMembersScreen extends StatefulWidget {
  const InviteNewMembersScreen({Key? key}) : super(key: key);

  @override
  State<InviteNewMembersScreen> createState() => _InviteNewMembersScreenState();
}

class _InviteNewMembersScreenState extends State<InviteNewMembersScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  CommonListData? initValue ;
  List<CommonListData> itemList = [];

  _inviteMembers() async {
    String emails = _emailController.text.trim();
    String content  =  _templateController.text.trim();

    if(emails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email can not be empty."), backgroundColor: Colors.red));
    } else {
      MemberContentResponseModel memberContent = MemberContentResponseModel(template: content);
      await Provider.of<MembersProvider>(context, listen: false)
          .updateMemberContent(memberContent, updateContentCallback);

      final emailsArr = emails.split(',');
      await Provider.of<MembersProvider>(context, listen: false)
          .createInvite(emailsArr, initValue?.id! , createInviteCallback);
    }

  }

  /*MemberContentResponseModel? getContent() {
    if(widget.topicModel?.id != null) {
      TopicModel topicModel = TopicModel(id: widget.topicModel?.id ?? 0,
          order: widget.topicModel?.order ?? 0, name: _topicNameController.text,
          description : _topicDescController.text,
        color: _topicColorController.text, background_image: widget.topicModel?.background_image ?? ''
      );
      return topicModel;
    }
  }*/

  updateContentCallback(
      bool isStatusSuccess,
      MemberContentResponseModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {

      //Navigator.pop(context);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic templateError = errorResponse?.errorJson["template"];

          if (templateError != null && templateError.length > 0) {
            errorDescription = "Template field may not be blank.";
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  createInviteCallback(
      bool isStatusSuccess,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invite request sent to new members."), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic templateError = errorResponse?.errorJson["email"];

          if (templateError != null && templateError.length > 0) {
            errorDescription = "Template field may not be blank.";
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  @override
  void initState() {
    super.initState();
    getMemberContent();
    itemList = Provider.of<MembersProvider>(context, listen: false)
        .getRolesList();
    initValue = itemList[0];
  }

  getMemberContent() async {
    await Provider.of<MembersProvider>(context, listen: false)
        .getMemberContent(getMemberContentCallback);
  }

  getMemberContentCallback(
      bool isStatusSuccess,
      MemberContentResponseModel? memberContent,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      _templateController.text = memberContent?.template ?? "";
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

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _templateFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _templateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<MembersProvider>(
        builder: (context, member, child) {
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
                  Text(getTranslated('INVITE_NEW_MEMBERS', context),
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
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            // for topic name
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      getTranslated('INVITE_BY_LINK', context),
                                      style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.black)),
                                  Text(
                                      getTranslated('copy_link_to_invite_people', context),
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).highlightColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0, 1))
                                        // changes position of shadow
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            member.memberContent?.invite_link ?? "",
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                                color: ColorResources
                                                    .TEXT_FORM_TEXT_COLOR),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Image.asset(Images.icon_copy,
                                          height: 24,
                                          width: 24).onTap(() async {
                                          Clipboard.setData(ClipboardData(text: member.memberContent?.invite_link ?? ""));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Your invite link has been copied"), backgroundColor: Colors.grey));
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                                  vertical: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: const Divider(color: ColorResources.NAVIGATION_DIVIDER_COLOR),
                            ),
                            // Invite by email
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          getTranslated(
                                              'INVITE_BY_EMAIL', context),
                                          style: customTextFieldTitle),
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.name,
                                    focusNode: _emailFocus,
                                    nextNode: _templateFocus,
                                    hintText: getTranslated('hint_add_multiple_email_addr', context),
                                    controller: _emailController,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _templateController,
                                    focusNode: _templateFocus,
                                    textInputAction: TextInputAction.done,
                                    /*hintText: getTranslated(
                                        'hint_current_password', context),*/
                                    maxLine: 4,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                              vertical: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: const Divider(color: ColorResources.NAVIGATION_DIVIDER_COLOR),
                            ),

                            //for contribute
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated('NETWORK_PERMISSIONS', context),
                                      style: customTextFieldTitle),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                  Text(
                                      getTranslated('choose_what_permissions_these_memebers', context),
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),

                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT,
                                        top: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                                        bottom: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
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
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          value: initValue,
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                          items: itemList.map((CommonListData items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(items.name!));
                                          }).toList(),
                                          onChanged: (CommonListData? newValue) {
                                            setState(() {
                                              initValue = newValue!;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal:
                                          Dimensions.MARGIN_SIZE_DEFAULT,
                                          vertical:
                                          Dimensions.MARGIN_SIZE_LARGE),
                                      child: !Provider.of<ProfileProvider>(
                                          context)
                                          .isLoading
                                          ? CustomButtonSecondary(
                                          onTap: () {},
                                          buttonText: getTranslated(
                                              'IMPORT_CONTACT', context),
                                        borderColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                                        textColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                                        textStyle: poppinsRegular,

                                        fontSize: 14,)
                                          : Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                              AlwaysStoppedAnimation<
                                                  Color>(
                                                  Theme.of(context)
                                                      .primaryColor))),
                                    ),
                                  ],
                                )),
                            Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                                          right: Dimensions.MARGIN_SIZE_DEFAULT,
                                          bottom: Dimensions.MARGIN_SIZE_DEFAULT
                                      ),
                                      child: !Provider.of<ProfileProvider>(
                                          context)
                                          .isLoading
                                          ? CustomButton(
                                          onTap: () {
                                            _inviteMembers();
                                          },
                                          buttonText: getTranslated(
                                              'SEND', context))
                                          : Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                              AlwaysStoppedAnimation<
                                                  Color>(
                                                  Theme.of(context)
                                                      .primaryColor))),
                                    ),
                                  ],
                                ))
                          ],
                        ),
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
