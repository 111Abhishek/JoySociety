import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/screen/goals/reflection3/goal_reflection3_screen.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/goal_sphere.dart';
import '../../../../data/model/response/request_achieved_goal_accountibility.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class AccountibilityCheckpointPage extends StatefulWidget {
  const AccountibilityCheckpointPage({Key? key}) : super(key: key);

  @override
  State<AccountibilityCheckpointPage> createState() =>
      _AccountibilityCheckpointPageState();
}

class _AccountibilityCheckpointPageState
    extends State<AccountibilityCheckpointPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  List<bool>? _selected = <bool>[];
  List<bool>? _selectedSpheres = <bool>[];

  //List<CommonListData>? _spheresList = <CommonListData>[];
  GoalSphereResponse achievedList = GoalSphereResponse();
  bool _isSelectable = false;
  //List<bool>? _selected = List.generate(8, (i) => false);

  void onItemClick(int index, CommonListData obj) {}
  List<TextEditingController> txtCtrls = [];
  List<FocusNode> focusNodes = [];
  bool selectedGoalAchieved = false;
  bool disableFeilds = false;
  Result? selectedCheckboxValue;

  @override
  void initState() {
    super.initState();
    getSuccessSphere();

    for (int i = 0; i < 9; i++) {
      txtCtrls.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  List<bool> _checkboxStates = [];

  void _updateCheckboxState(int index, bool newValue) {
    setState(() {
      for (int i = 0; i < _checkboxStates.length; i++) {
        _checkboxStates[i] = i == index ? newValue : false;
      }
    });
  }

  getSuccessSphere() async {
    await Provider.of<GoalProvider>(context, listen: false)
        .getSphere(getSuccessSphereCallback)
        .then((value) => {
              for (int i = 0; i < achievedList.results!.length; i++)
                {_checkboxStates.add(false)}
            });
    setState(() {});
  }

  getSuccessSphereCallback(bool isStatusSuccess,
      GoalSphereResponse? successResponse, ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      achievedList = successResponse!;
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

  void _onSphereSelection(int index) {
    _selectedSpheres = _selected?.where((i) => i).toList();

    if (_selected![index]) {
      setState(() => _selected![index] = false);
      return;
    }

    if (_selectedSpheres!.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You can't select more than 2 Spheres"),
          backgroundColor: Colors.red));
    } else {
      setState(() => _selected![index] = !_selected![index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.APP_BACKGROUND_COLOR,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Stack(
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
                  Text(getTranslated('AccountabilityCheckPoint', context),
                      style: poppinsBold.copyWith(
                          fontSize: 15, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(
                    width: 20,
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: Dimensions.MARGIN_SIZE_LARGE,
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT),
                padding: const EdgeInsets.only(top: 90),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorResources.WHITE,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Text("What spheres you selected to focus on?",
                              style: poppinsBold.copyWith(
                                  fontSize: 16, color: Colors.black)),
                          ListView.builder(
                            itemCount: achievedList.results == null
                                ? 0
                                : achievedList.results!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_DEFAULT,
                                  ),
                                  Row(children: [
                                    Checkbox(
                                      checkColor: ColorResources.WHITE,
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: _checkboxStates[index],
                                      onChanged: (value) {
                                        _updateCheckboxState(index, value!);
                                        disableFeilds = true;
                                        selectedCheckboxValue =
                                            achievedList.results![index];
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    Text(achievedList.results![index].name!,
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL)),
                                  ]),
                                ],
                              );
                            },
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorResources.WHITE,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Checkbox(
                                checkColor: ColorResources.WHITE,
                                activeColor: Theme.of(context).primaryColor,
                                value: selectedGoalAchieved,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGoalAchieved =
                                        !selectedGoalAchieved;
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text("For Goal(s) you achieved",
                                  style: poppinsBold.copyWith(
                                      fontSize: 14, color: Colors.black)),
                            ]),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                                "Is there anything you set out to do that you fully completed?",
                                style: customTextFieldTitle),
                            const SizedBox(
                                height: Dimensions.MARGIN_SIZE_SMALL),
                            CustomTextField(
                                controller: txtCtrls[0],
                                focusNode: focusNodes[0],
                                nextNode: focusNodes[1],
                                textInputAction: TextInputAction.next,
                                maxLine: 1,
                                blackBorderColor: ColorResources.BLACK),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text("To what do you attribute your success?",
                                style: customTextFieldTitle),
                            const SizedBox(
                                height: Dimensions.MARGIN_SIZE_SMALL),
                            CustomTextField(
                                controller: txtCtrls[1],
                                focusNode: focusNodes[1],
                                nextNode: focusNodes[2],
                                textInputAction: TextInputAction.next,
                                maxLine: 1,
                                blackBorderColor: ColorResources.BLACK),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                                "What will you do to maintain your success?",
                                style: customTextFieldTitle),
                            const SizedBox(
                                height: Dimensions.MARGIN_SIZE_SMALL),
                            CustomTextField(
                                controller: txtCtrls[2],
                                focusNode: focusNodes[2],
                                nextNode: focusNodes[3],
                                textInputAction: TextInputAction.next,
                                maxLine: 1,
                                blackBorderColor: ColorResources.BLACK),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AbsorbPointer(
                        absorbing: disableFeilds,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: disableFeilds
                                  ? ColorResources.GRAY_BUTTON_BG_COLOR
                                  : ColorResources.WHITE,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Checkbox(
                                  checkColor: ColorResources.WHITE,
                                  activeColor: Theme.of(context).primaryColor,
                                  value: false,
                                  onChanged: (value) {},
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                Expanded(
                                  child: Text(
                                      "For Goal(s) you made progress on, but did not achieve",
                                      maxLines: 2,
                                      softWrap: true,
                                      style: poppinsBold.copyWith(
                                          fontSize: 14, color: Colors.black)),
                                ),
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                  "What prevented you from fully achieving what you set out to accomplish?",
                                  style: customTextFieldTitle),
                              const SizedBox(
                                  height: Dimensions.MARGIN_SIZE_SMALL),
                              CustomTextField(
                                  controller: txtCtrls[3],
                                  focusNode: focusNodes[3],
                                  nextNode: focusNodes[4],
                                  textInputAction: TextInputAction.next,
                                  maxLine: 1,
                                  blackBorderColor: ColorResources.BLACK),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                  "Is the progress enough for now or do you want to continue to challenge yourself to go higher?",
                                  style: customTextFieldTitle),
                              const SizedBox(
                                  height: Dimensions.MARGIN_SIZE_SMALL),
                              CustomTextField(
                                  controller: txtCtrls[4],
                                  focusNode: focusNodes[4],
                                  nextNode: focusNodes[5],
                                  textInputAction: TextInputAction.next,
                                  maxLine: 1,
                                  blackBorderColor: ColorResources.BLACK),
                              const SizedBox(
                                height: 15,
                              ),
                              ///////////////////////////////////////////////
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AbsorbPointer(
                        absorbing: disableFeilds,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: disableFeilds
                                  ? ColorResources.GRAY_BUTTON_BG_COLOR
                                  : ColorResources.WHITE,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Checkbox(
                                  checkColor: ColorResources.WHITE,
                                  activeColor: Theme.of(context).primaryColor,
                                  value: false,
                                  onChanged: (value) {},
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                Expanded(
                                  child: Text(
                                      "For Goal(s) you did not made progress towards",
                                      maxLines: 2,
                                      softWrap: true,
                                      style: poppinsBold.copyWith(
                                          fontSize: 14, color: Colors.black)),
                                ),
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("What reason(s) was no progress made?",
                                  style: customTextFieldTitle),
                              const SizedBox(
                                  height: Dimensions.MARGIN_SIZE_SMALL),
                              CustomTextField(
                                  controller: txtCtrls[5],
                                  focusNode: focusNodes[5],
                                  nextNode: focusNodes[6],
                                  textInputAction: TextInputAction.next,
                                  maxLine: 1,
                                  blackBorderColor: ColorResources.BLACK),
                              const SizedBox(
                                height: 15,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Did you discover any new barriers?",
                                  style: customTextFieldTitle),
                              const SizedBox(
                                  height: Dimensions.MARGIN_SIZE_SMALL),
                              CustomTextField(
                                  controller: txtCtrls[6],
                                  focusNode: focusNodes[6],
                                  nextNode: focusNodes[7],
                                  textInputAction: TextInputAction.next,
                                  maxLine: 1,
                                  blackBorderColor: ColorResources.BLACK),
                              // SizedBox(
                              //   height: 500,
                              //   child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Row(children: [
                              //           Checkbox(
                              //             checkColor: ColorResources.WHITE,
                              //             activeColor:
                              //                 Theme.of(context).primaryColor,
                              //             value: false,
                              //             onChanged: (value) {},
                              //             materialTapTargetSize:
                              //                 MaterialTapTargetSize.shrinkWrap,
                              //           ),
                              //           Expanded(
                              //             child: Text("Adjust my action plan",
                              //                 maxLines: 2,
                              //                 softWrap: true,
                              //                 style: poppinsBold.copyWith(
                              //                     fontSize: 14,
                              //                     color: Colors.black)),
                              //           ),
                              //         ]),
                              //         Row(children: [
                              //           Checkbox(
                              //             checkColor: ColorResources.WHITE,
                              //             activeColor:
                              //                 Theme.of(context).primaryColor,
                              //             value: false,
                              //             onChanged: (value) {},
                              //             materialTapTargetSize:
                              //                 MaterialTapTargetSize.shrinkWrap,
                              //           ),
                              //           Expanded(
                              //             child: Text(
                              //                 "Identify & seek extra support",
                              //                 maxLines: 2,
                              //                 softWrap: true,
                              //                 style: poppinsBold.copyWith(
                              //                     fontSize: 14,
                              //                     color: Colors.black)),
                              //           ),
                              //         ]),
                              //         Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Row(children: [
                              //                 Checkbox(
                              //                   checkColor: ColorResources.WHITE,
                              //                   activeColor: Theme.of(context)
                              //                       .primaryColor,
                              //                   value: false,
                              //                   onChanged: (value) {},
                              //                   materialTapTargetSize:
                              //                       MaterialTapTargetSize
                              //                           .shrinkWrap,
                              //                 ),
                              //                 Expanded(
                              //                   child: Text(
                              //                       "pivot to new goal(s)",
                              //                       maxLines: 2,
                              //                       softWrap: true,
                              //                       style: poppinsBold.copyWith(
                              //                           fontSize: 14,
                              //                           color: Colors.black)),
                              //                 ),
                              //               ]),
                              //               Row(children: [
                              //                 Checkbox(
                              //                   checkColor: ColorResources.WHITE,
                              //                   activeColor: Theme.of(context)
                              //                       .primaryColor,
                              //                   value: false,
                              //                   onChanged: (value) {},
                              //                   materialTapTargetSize:
                              //                       MaterialTapTargetSize
                              //                           .shrinkWrap,
                              //                 ),
                              //                 Expanded(
                              //                   child: Text("others",
                              //                       maxLines: 2,
                              //                       softWrap: true,
                              //                       style: poppinsBold.copyWith(
                              //                           fontSize: 14,
                              //                           color: Colors.black)),
                              //                 ),
                              //               ]),
                              //             ])
                              //       ]),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Expanded(
                          //   flex: 2,
                          //   child: Container(
                          //     margin: const EdgeInsets.only(
                          //         top: Dimensions.MARGIN_SIZE_LARGE,
                          //         bottom: Dimensions.MARGIN_SIZE_LARGE,
                          //         right: Dimensions.MARGIN_SIZE_SMALL),
                          //     alignment: AlignmentDirectional.centerEnd,
                          //     child: CustomButtonSecondary(
                          //       buttonText: "SKIP",
                          //       borderColor: ColorResources.GRAY_BUTTON_BG_COLOR,
                          //       bgColor: ColorResources.GRAY_BUTTON_BG_COLOR,
                          //       textColor: Colors.white,
                          //       textStyle: poppinsBold,
                          //       onTap: () {
                          //         Navigator.of(context).push(MaterialPageRoute(
                          //             builder: (BuildContext context) =>
                          //                 const GoalReflection3Screen(
                          //                     selectedSphere: <CommonListData>[])));
                          //       },
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: Dimensions.MARGIN_SIZE_LARGE,
                                    bottom: Dimensions.MARGIN_SIZE_LARGE,
                                    left: Dimensions.MARGIN_SIZE_SMALL),
                                alignment: AlignmentDirectional.centerEnd,
                                child: CustomButtonSecondary(
                                  buttonText: "Submit",
                                  borderColor: Theme.of(context).primaryColor,
                                  bgColor: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  textStyle: poppinsBold,
                                  onTap: () async {
                                    if (selectedGoalAchieved) {
                                      RequestAchievedGoal reqstmodel =
                                          RequestAchievedGoal(
                                        aQuestionSet1: txtCtrls[0].text,
                                        aQuestionSet2: txtCtrls[1].text,
                                        aQuestionSet3: txtCtrls[2].text,
                                        goalId: selectedCheckboxValue!.goalId,
                                        selectedNextId: "",
                                        sphereId: selectedCheckboxValue!.id
                                            .toString(),
                                        step: "1",
                                      );
                                      await Provider.of<GoalProvider>(context,
                                              listen: false)
                                          .goalComplte(reqstmodel,
                                              (bool isStatusSuccess,
                                                  ErrorResponse?
                                                      errorResponse) async {
                                        if (isStatusSuccess) {
                                          Navigator.pop(context);
                                        } else {
                                          String? errorDescription =
                                              errorResponse?.errorDescription;
                                          if (errorResponse?.non_field_errors !=
                                              null) {
                                            errorDescription = errorResponse
                                                ?.non_field_errors![0];
                                          } else {
                                            errorDescription ??=
                                                'Technical error, Please try again later!';
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(errorDescription!),
                                                  backgroundColor: Colors.red));
                                        }
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Select any check point"),
                                              backgroundColor: Colors.red));
                                    }
                                  },
                                ),
                              )),
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ));
  }
}
