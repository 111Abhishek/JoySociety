import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_goal_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';

import 'package:provider/provider.dart';

import '../../../../localization/language_constants.dart';

import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';

import '../../../basewidget/textfield/custom_textfield.dart';
import '../reflection6/goal_reflection_6_screen.dart';

class GoalReflection5Screen extends StatefulWidget {
  final String? defineGoal;
//  final String? whyDesc;
  final int? sphereId;
  final String? completionDate;
  List<TextEditingController>? freqCtrl;
  GoalReflection5Screen(
      {Key? key,
      required this.defineGoal,
      this.completionDate,
      //  required this.whyDesc,
      this.freqCtrl,
      required this.sphereId})
      : super(key: key);

  @override
  State<GoalReflection5Screen> createState() => _GoalReflection5ScreenState();
}

class _GoalReflection5ScreenState extends State<GoalReflection5Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  List<String> getActionSteps() {
    List<String> list = sphere_emotional_goals;
    return list;
  }

  _onSubmitForm() async {
    CreateGoalModel? requestModel = getCreateModelDetails();
    if (requestModel != null) {
      await Provider.of<GoalProvider>(context, listen: false)
          .createGoal(requestModel, updateForumCallback);
    }
  }

  CreateGoalModel? getCreateModelDetails() {
    List<String> str = [];
    str = Provider.of<GoalProvider>(context, listen: false).actionsList;

    CreateGoalModel createGoalModel = CreateGoalModel(
        sphere: widget.sphereId ?? 0,
        define_goal: widget.defineGoal ?? "",
        //  why: widget.whyDesc ?? "",
        action_step_1:
            Provider.of<GoalProvider>(context, listen: false).actionsList[0] ??
                "",
        completion_date_1: Provider.of<GoalProvider>(context, listen: false)
                .actionDateList[0] ??
            "",
        action_step_2:
            Provider.of<GoalProvider>(context, listen: false).actionsList[1] ??
                "",
        completion_date_2: Provider.of<GoalProvider>(context, listen: false)
                .actionDateList[1] ??
            "",
        action_step_3:
            Provider.of<GoalProvider>(context, listen: false).actionsList[2] ??
                "",
        completion_date_3:
            Provider.of<GoalProvider>(context, listen: false).actionDateList[2] ??
                "",
        action_step_4:
            Provider.of<GoalProvider>(context, listen: false).actionsList[3] ??
                "",
        completion_date_4:
            Provider.of<GoalProvider>(context, listen: false).actionDateList[3] ?? "",
        action_step_5: Provider.of<GoalProvider>(context, listen: false).actionsList[4] ?? "",
        completion_date_5: Provider.of<GoalProvider>(context, listen: false).actionDateList[4] ?? "",
        action_step_6: Provider.of<GoalProvider>(context, listen: false).actionsList[5] ?? "",
        completion_date_6: Provider.of<GoalProvider>(context, listen: false).actionDateList[5] ?? "",
        potential_barriers: _potentialBarriersController.text.trim() ?? "",
        support_and_resources: _supportAndResourcesController.text.trim() ?? "",
        connection_sessions: Provider.of<GoalProvider>(context, listen: false).checkBoxConnectionSessions,
        networking_connecting: Provider.of<GoalProvider>(context, listen: false).checkBoxNetworking,
        accountablity_checkpoint: Provider.of<GoalProvider>(context, listen: false).checkBoxGoalAcc,
        self_paced_learning: Provider.of<GoalProvider>(context, listen: false).checkBoxSelfPaced,
        wducationnal_webinar: Provider.of<GoalProvider>(context, listen: false).checkBoxEducational,
        join_tribe: Provider.of<GoalProvider>(context, listen: false).checkBoxJointTheGoal,
        //TODO:: NEED to Fix it will do it later
        completion_date: "2023-08-31");
    return createGoalModel;
  }

  updateForumCallback(bool isStatusSuccess, CreateGoalModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Goal Created successfully'),
          backgroundColor: Colors.green));
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 5);
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
    super.initState();
  }

  final FocusNode _potentialBarriersFocus = FocusNode();
  final FocusNode _supportAndResourcesFocus = FocusNode();

  final TextEditingController _potentialBarriersController =
      TextEditingController();
  final TextEditingController _supportAndResourcesController =
      TextEditingController();

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
                                "5",
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
                                  Text(
                                      getTranslated(
                                          'YOUR_POTENTIAL_BARRIERS', context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _potentialBarriersController,
                                    focusNode: _potentialBarriersFocus,
                                    nextNode: _supportAndResourcesFocus,
                                    textInputAction: TextInputAction.next,
                                    hintText: getTranslated(
                                        'reflection_5_potential_barriers_hint',
                                        context),
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
                                  Text(
                                      getTranslated(
                                          'SUPPORT_AND_RESOURCES_NEEDED',
                                          context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _supportAndResourcesController,
                                    focusNode: _supportAndResourcesFocus,
                                    textInputAction: TextInputAction.done,
                                    hintText: getTranslated(
                                        'reflection_5_support_n_resources_hint',
                                        context),
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
                                              .banner_goal_growth_not_perfection,
                                          matchTextDirection: true,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.fitWidth,
                                          // height: MediaQuery.of(context)
                                          //         .size
                                          //         .height /
                                          //     2,
                                        ),
                                        // Positioned(
                                        //   bottom:
                                        //       10, // Set the 'bottom' property to position the text at the bottom.
                                        //   left:
                                        //       0, // You can also set 'left', 'right', and 'top' properties as needed.
                                        //   right: 0,
                                        //   child: Container(
                                        //     padding: const EdgeInsets.all(
                                        //         8), // Add padding to the text if required.
                                        //     // color: Colors.black.withOpacity(
                                        //     //     0.5), // Add background color if needed.
                                        //     child: const Text(
                                        //       "Your life will change only when you become more committed to your dreams than you are to your comfort zone.",
                                        //       style: TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.bold,
                                        //       ),
                                        //       textAlign: TextAlign.center,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height:
                                            Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                    Text(
                                        getTranslated(
                                            'WHAT_JOY_SOCIETY_OFFERINGS',
                                            context),
                                        style: customTextFieldTitle),
                                    const SizedBox(
                                        height:
                                            Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                    Row(children: [
                                      Checkbox(
                                        checkColor: ColorResources.WHITE,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: goalProvider
                                            .checkBoxConnectionSessions,
                                        onChanged: goalProvider
                                            .updateCheckBoxConnectionSessions,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(
                                          getTranslated(
                                              'cb_title_connection_sessions',
                                              context),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL)),
                                    ]),
                                    Row(children: [
                                      Checkbox(
                                        checkColor: ColorResources.WHITE,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: goalProvider.checkBoxNetworking,
                                        onChanged: goalProvider
                                            .updateCheckBoxNetworking,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(
                                          getTranslated(
                                              'cb_title_networking', context),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL)),
                                    ]),
                                    Row(children: [
                                      Checkbox(
                                        checkColor: ColorResources.WHITE,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: goalProvider.checkBoxGoalAcc,
                                        onChanged:
                                            goalProvider.updateCheckBoxGoalAcc,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(
                                          getTranslated(
                                              'cb_title_goal_accountability',
                                              context),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL)),
                                    ]),
                                    Row(children: [
                                      Checkbox(
                                        checkColor: ColorResources.WHITE,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: goalProvider.checkBoxSelfPaced,
                                        onChanged: goalProvider
                                            .updateCheckBoxSelfPaced,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(
                                          getTranslated(
                                              'cb_title_self_paced', context),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL)),
                                    ]),
                                    Row(children: [
                                      Checkbox(
                                        checkColor: ColorResources.WHITE,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: goalProvider.checkBoxEducational,
                                        onChanged: goalProvider
                                            .updateCheckBoxEducational,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(
                                          getTranslated(
                                              'cb_title_educational', context),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL)),
                                    ]),
                                    Row(children: [
                                      Checkbox(
                                        checkColor: ColorResources.WHITE,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value:
                                            goalProvider.checkBoxJointTheGoal,
                                        onChanged: goalProvider
                                            .updateCheckBoxJointTheGoal,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Text(
                                          getTranslated(
                                              'cb_title_join_the_goal',
                                              context),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL)),
                                    ]),
                                  ]),
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
                                          getTranslated("NEXT", context),
                                      borderColor:
                                          Theme.of(context).primaryColor,
                                      bgColor: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      textStyle: poppinsBold,
                                      fontSize: 16,
                                      onTap: () {
                                        // goalProvider.maincheckBoxState();
                                        // _onSubmitForm();

                                        if (_potentialBarriersController
                                                .text.isEmpty ||
                                            _supportAndResourcesController
                                                .text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please fill all mandatory feilds Potential Barrier , support and resource'),
                                                  backgroundColor:
                                                      ColorResources.RED));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          GoalReflection6Screen(
                                                            freqCtrl:
                                                                widget.freqCtrl,
                                                            pb: _potentialBarriersController
                                                                .text,
                                                            srn:
                                                                _supportAndResourcesController
                                                                    .text,
                                                            completionDate: widget
                                                                .completionDate,
                                                            defineGoal: widget
                                                                .defineGoal,
                                                            // whyDesc:
                                                            //     widget.whyDesc,
                                                            sphereId:
                                                                widget.sphereId,
                                                          )));
                                        }
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
