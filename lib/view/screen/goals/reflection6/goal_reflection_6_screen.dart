import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_goal_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/utill/system_utils.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';

import 'package:provider/provider.dart';

import '../../../../localization/language_constants.dart';

import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';

import '../../../basewidget/textfield/custom_textfield.dart';

class GoalReflection6Screen extends StatefulWidget {
  final String? defineGoal;
//  final String? whyDesc;
  final int? sphereId;
  final String? completionDate;
  String? pb, srn;
  List<TextEditingController>? freqCtrl;
  GoalReflection6Screen(
      {Key? key,
      required this.defineGoal,
      //  required this.whyDesc,
      this.completionDate,
      required this.freqCtrl,
      this.pb,
      this.srn,
      required this.sphereId})
      : super(key: key);

  @override
  State<GoalReflection6Screen> createState() => _GoalReflection6ScreenState();
}

class _GoalReflection6ScreenState extends State<GoalReflection6Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  List<String> getActionSteps() {
    List<String> list = sphere_emotional_goals;
    return list;
  }

  _onSubmitForm() async {
    CreateGoalModel? requestModel = getCreateModelDetails();
    log(requestModel);
    if (requestModel != null) {
      await Provider.of<GoalProvider>(context, listen: false)
          .createGoal(requestModel, updateForumCallback);
    }
  }

  CreateGoalModel? getCreateModelDetails() {
    print(Provider.of<GoalProvider>(context, listen: false).completionDate);
    CreateGoalModel createGoalModel = CreateGoalModel(
        sphere: widget.sphereId ?? 0,
        define_goal: widget.defineGoal ?? "",
        //  why: widget.whyDesc ?? "",
        actionFreq1: widget.freqCtrl![0].text.isEmpty
            ? 1
            : widget.freqCtrl![0].text.toInt(),
        actionFreq2: widget.freqCtrl![1].text.isEmpty
            ? 1
            : widget.freqCtrl![1].text.toInt(),
        actionFreq3: widget.freqCtrl![2].text.isEmpty
            ? 1
            : widget.freqCtrl![2].text.toInt(),
        actionFreq4: widget.freqCtrl![3].text.isEmpty
            ? 1
            : widget.freqCtrl![3].text.toInt(),
        actionFreq5: widget.freqCtrl![4].text.isEmpty
            ? 1
            : widget.freqCtrl![4].text.toInt(),
        actionFreq6: widget.freqCtrl![5].text.isEmpty
            ? 1
            : widget.freqCtrl![5].text.toInt(),
        action_step_1: Provider.of<GoalProvider>(context, listen: false)
                    .selectedDropDownVal[0] ==
                "Select"
            ? ""
            : Provider.of<GoalProvider>(context, listen: false)
                        .selectedDropDownVal[0] ==
                    "Other"
                ? Provider.of<GoalProvider>(context, listen: false)
                        .othersVal[0]
                        .isEmpty
                    ? ""
                    : Provider.of<GoalProvider>(context, listen: false)
                        .othersVal[0]
                : Provider.of<GoalProvider>(context, listen: false)
                    .selectedDropDownVal[0],
        completion_date_1: Provider.of<GoalProvider>(context, listen: false)
                .actionDateList[0] ??
            "",
        action_step_2: Provider.of<GoalProvider>(context, listen: false)
                    .selectedDropDownVal[1] ==
                "Select"
            ? ""
            : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[1] == "Other"
                ? Provider.of<GoalProvider>(context, listen: false).othersVal[1].isEmpty
                    ? ""
                    : Provider.of<GoalProvider>(context, listen: false).othersVal[1]
                : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[1],
        completion_date_2: Provider.of<GoalProvider>(context, listen: false).actionDateList[1] ?? "",
        action_step_3: Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[2] == "Select"
            ? ""
            : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[2] == "Other"
                ? Provider.of<GoalProvider>(context, listen: false).othersVal[2].isEmpty
                    ? ""
                    : Provider.of<GoalProvider>(context, listen: false).othersVal[2]
                : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[2],
        completion_date_3: Provider.of<GoalProvider>(context, listen: false).actionDateList[2] ?? "",
        action_step_4: Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[3] == "Select"
            ? ""
            : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[3] == "Other"
                ? Provider.of<GoalProvider>(context, listen: false).othersVal[3].isEmpty
                    ? ""
                    : Provider.of<GoalProvider>(context, listen: false).othersVal[3]
                : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[3],
        completion_date_4: Provider.of<GoalProvider>(context, listen: false).actionDateList[3] ?? "",
        action_step_5: Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[4] == "Select"
            ? ""
            : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[4] == "Other"
                ? Provider.of<GoalProvider>(context, listen: false).othersVal[4].isEmpty
                    ? ""
                    : Provider.of<GoalProvider>(context, listen: false).othersVal[4]
                : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[4],
        completion_date_5: Provider.of<GoalProvider>(context, listen: false).actionDateList[4] ?? "",
        action_step_6: Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[5] == "Select"
            ? ""
            : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[5] == "Other"
                ? Provider.of<GoalProvider>(context, listen: false).othersVal[5].isEmpty
                    ? ""
                    : Provider.of<GoalProvider>(context, listen: false).othersVal[5]
                : Provider.of<GoalProvider>(context, listen: false).selectedDropDownVal[5],
        completion_date_6: Provider.of<GoalProvider>(context, listen: false).actionDateList[5] ?? "",
        potential_barriers: widget.pb == null ? "" : widget.pb!.trim(),
        support_and_resources: widget.srn == null ? "" : widget.srn!.trim(),
        question1: _comfortZoneController.text ?? '',
        question2: _overcomeController.text ?? '',
        question3: _growthZoneController.text ?? '',
        question4: _yearzoneController.text ?? '',
        connection_sessions: Provider.of<GoalProvider>(context, listen: false).checkBoxConnectionSessions,
        networking_connecting: Provider.of<GoalProvider>(context, listen: false).checkBoxNetworking,
        accountablity_checkpoint: Provider.of<GoalProvider>(context, listen: false).checkBoxGoalAcc,
        self_paced_learning: Provider.of<GoalProvider>(context, listen: false).checkBoxSelfPaced,
        wducationnal_webinar: Provider.of<GoalProvider>(context, listen: false).checkBoxEducational,
        join_tribe: Provider.of<GoalProvider>(context, listen: false).checkBoxJointTheGoal,
        completion_date: widget.completionDate ?? '');
    return createGoalModel;
  }

  updateForumCallback(bool isStatusSuccess, CreateGoalModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Goal Created successfully'),
          backgroundColor: Colors.green));
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 6);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic action_step_1_Error =
              errorResponse?.errorJson["action_step_1"];
          dynamic completion_date_1_Error =
              errorResponse?.errorJson["completion_date_1"];
          dynamic potential_barriers_Error =
              errorResponse?.errorJson["potential_barriers"];
          dynamic support_and_resources_Error =
              errorResponse?.errorJson["support_and_resources"];

          if (action_step_1_Error != null && action_step_1_Error.length > 0) {
            errorDescription = (action_step_1_Error![0]! as String)
                .replaceAll("This field", "Action Step 1");
          } else if (completion_date_1_Error != null &&
              completion_date_1_Error.length > 0) {
            errorDescription = (completion_date_1_Error![0]! as String)
                .replaceAll("This field", "Action Step 1 Completion date");
          } else if (potential_barriers_Error != null &&
              potential_barriers_Error.length > 0) {
            errorDescription = (potential_barriers_Error![0]! as String)
                .replaceAll("This field", "Potential Barriers");
          } else if (support_and_resources_Error != null &&
              support_and_resources_Error.length > 0) {
            errorDescription = (support_and_resources_Error![0]! as String)
                .replaceAll("This field", "Support and Resources");
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
    _comfortZoneController = TextEditingController();
    _overcomeController = TextEditingController();
    _growthZoneController = TextEditingController();
    _yearzoneController = TextEditingController();

    super.initState();
  }

  final FocusNode _comfortZoneFocus = FocusNode();
  final FocusNode _overcomeFocus = FocusNode();
  final FocusNode _growthZoneFocus = FocusNode();
  final FocusNode _yearZoneFocus = FocusNode();

  late TextEditingController _comfortZoneController;
  late TextEditingController _overcomeController;
  late TextEditingController _growthZoneController;
  late TextEditingController _yearzoneController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goalProvider, child) {
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
                  Text(getTranslated('REFLECTION', context),
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    height: 65,
                    width: 65,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "6",
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
                padding: const EdgeInsets.only(top: 100),
                child: Column(
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
                            )),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            //for Description 1
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "Do you struggle to get out of your comfort zone? Why? What are your biggest fears about the things that are outof your comfort zone?",
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _comfortZoneController,
                                    focusNode: _comfortZoneFocus,
                                    nextNode: _yearZoneFocus,
                                    textInputAction: TextInputAction.next,
                                    hintText:
                                        "Do you struggle to get out of your comfort zone? Why? What are your biggest fears about the things that are outof your comfort zone?",
                                    maxLine: 5,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_SMALL,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_SMALL),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          Images
                                              .new_banner_goal_growth_not_perfection,
                                          matchTextDirection: true,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.fitWidth,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                        ),
                                        Positioned(
                                          bottom:
                                              10, // Set the 'bottom' property to position the text at the bottom.
                                          left:
                                              0, // You can also set 'left', 'right', and 'top' properties as needed.
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                8), // Add padding to the text if required.
                                            // color: Colors.black.withOpacity(
                                            //     0.5), // Add background color if needed.
                                            child: const Text(
                                              "Your life will change only when you become more committed to your dreams than you are to your comfort zone.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                            //for Description 2
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "How can you reframe/overcome the fears and obstacles you outlined in the previous question?",
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _overcomeController,
                                    focusNode: _overcomeFocus,
                                    textInputAction: TextInputAction.done,
                                    hintText:
                                        "How can you reframe/overcome the fears and obstacles you outlined in the previous question?",
                                    maxLine: 5,
                                  ),
                                ],
                              ),
                            ),
                            //for Description 2
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "How wil Iyour life look in1/3/IO years' time if you decide to ventu1re out intoyour learning and growth zone?",
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _growthZoneController,
                                    focusNode: _growthZoneFocus,
                                    textInputAction: TextInputAction.done,
                                    hintText:
                                        "How wil Iyour life look in1/3/IO years' time if you decide to ventu1re out intoyour learning and growth zone?",
                                    maxLine: 5,
                                  ),
                                ],
                              ),
                            ),
                            //for Description 2
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      "What might you miss out on ifyou stay inyour comfort & fear zone? How willyour life look in 1/3/10 years' time?",
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _yearzoneController,
                                    focusNode: _yearZoneFocus,
                                    textInputAction: TextInputAction.done,
                                    hintText:
                                        "What might you miss out on ifyou stay inyour comfort & fear zone? How willyour life look in 1/3/10 years' time?",
                                    maxLine: 5,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_LARGE,
                                        bottom: Dimensions.MARGIN_SIZE_LARGE),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: CustomButtonSecondary(
                                      buttonText:
                                          getTranslated("SUBMIT", context),
                                      borderColor:
                                          Theme.of(context).primaryColor,
                                      bgColor: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      textStyle: poppinsBold,
                                      fontSize: 16,
                                      onTap: () {
                                        _onSubmitForm();
                                        goalProvider.maincheckBoxState();
                                      },
                                    ),
                                  )),
                                ],
                              ),
                            )
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
