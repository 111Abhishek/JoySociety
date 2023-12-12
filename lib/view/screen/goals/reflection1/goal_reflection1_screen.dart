import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/success_evaluation_report_model.dart';
import 'package:joy_society/data/model/response/success_evaluation_report_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/screen/goals/reflection1/adapter/list_goal_reflection1_adapter.dart';
import 'package:joy_society/view/screen/goals/reflection2/goal_reflection2_screen.dart';
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

class GoalReflection1Screen extends StatefulWidget {
  final String? reportType;
  const GoalReflection1Screen({this.reportType, Key? key}) : super(key: key);

  @override
  State<GoalReflection1Screen> createState() => _GoalReflection1ScreenState();
}

class _GoalReflection1ScreenState extends State<GoalReflection1Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool isPrivateChatSwitched = false;
  bool isAllMemeberChatSwitched = false;

  @override
  void initState() {
    super.initState();
    getMemberContent();
  }

  getMemberContent() async {
    await Provider.of<GoalProvider>(context, listen: false)
        .getSuccessEvaluationReport(
            widget.reportType, getEvaluationReportCallback);
  }

  getEvaluationReportCallback(
      bool isStatusSuccess,
      SuccessEvaluationReportResponseModel? memberContent,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      //_templateController.text = memberContent?.template ?? "";
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

  void onItemClick(int index, SuccessEvaluationReportModel obj) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goal, child) {
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
                  Text(getTranslated('REFLECTION', context),
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(
                    width: 16,
                  ),
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "1",
                                style: poppinsBold.copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                "/6",
                                style: poppinsRegular.copyWith(
                                  fontSize: 12,
                                  color:
                                      ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: Dimensions.MARGIN_SIZE_LARGE,
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT),
                padding: const EdgeInsets.only(top: 90),
                //child: ListView(physics: BouncingScrollPhysics(), children: [
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Member Communication
                      Text(
                          getTranslated(
                              'tru_success_evaluation_1_title', context),
                          style: poppinsBold.copyWith(
                              fontSize: 16, color: Colors.black)),
                      Text(
                          getTranslated(
                              'tru_success_evaluation_1_desc', context),
                          style: poppinsRegular.copyWith(
                              fontSize: 14, color: Colors.black)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Success Sphere",
                                      style: poppinsBold.copyWith(
                                          fontSize: 12, color: Colors.black)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 26,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Part 1",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 12, color: Colors.black)),
                                  Text("General",
                                      style: poppinsBold.copyWith(
                                          fontSize: 12, color: Colors.black)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Part 2",
                                      style: poppinsRegular.copyWith(
                                          fontSize: 12, color: Colors.black)),
                                  Text("General",
                                      style: poppinsBold.copyWith(
                                          fontSize: 12, color: Colors.black)),
                                ],
                              ),
                            ),
                          ]),

                      Expanded(
                          child: ListGoalReflection1Adapter(
                                  goal.successEvaluationReport?.data,
                                  onItemClick)
                              .getView()),

                      Visibility(
                        visible: goal.successEvaluationReport!.data!.isNotEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: Dimensions.MARGIN_SIZE_LARGE,
                                    bottom: Dimensions.MARGIN_SIZE_LARGE,
                                    right: Dimensions.MARGIN_SIZE_SMALL),
                                alignment: AlignmentDirectional.centerEnd,
                                child: CustomButtonSecondary(
                                  buttonText: "SKIP",
                                  borderColor:
                                      ColorResources.GRAY_BUTTON_BG_COLOR,
                                  bgColor: ColorResources.GRAY_BUTTON_BG_COLOR,
                                  textColor: Colors.white,
                                  textStyle: poppinsBold,
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GoalReflection2Screen()));
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: Dimensions.MARGIN_SIZE_LARGE,
                                      bottom: Dimensions.MARGIN_SIZE_LARGE,
                                      left: Dimensions.MARGIN_SIZE_SMALL),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: CustomButtonSecondary(
                                    buttonText: "NEXT",
                                    borderColor: Theme.of(context).primaryColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    textStyle: poppinsBold,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  GoalReflection2Screen()));
                                    },
                                  ),
                                )),
                          ],
                        ),
                      )
                    ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
