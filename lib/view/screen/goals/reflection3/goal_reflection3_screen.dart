import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/goal_reflection3_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/goals/reflection2/goal_reflection2_screen.dart';
import 'package:joy_society/view/screen/goals/reflection4/goal_reflection4_screen.dart';
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

class GoalReflection3Screen extends StatefulWidget {
  final List<CommonListData>? selectedSphere/*=  <CommonListData>[]*/;
  const GoalReflection3Screen({Key? key, this.selectedSphere})
      : super(key: key);

  @override
  State<GoalReflection3Screen> createState() => _GoalReflection3ScreenState();
}

class _GoalReflection3ScreenState extends State<GoalReflection3Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<CommonListData> _selectedSphere = <CommonListData>[];
  CommonListData sphere1 = CommonListData(id: -1, name: "");
  CommonListData sphere2 = CommonListData(id: -1, name: "");

  final FocusNode _sphere1DescFocus = FocusNode();
  final FocusNode _sphere2DescFocus = FocusNode();

  final TextEditingController _sphere1DescController = TextEditingController();
  final TextEditingController _sphere2DescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedSphere != null) {
      _selectedSphere = widget.selectedSphere!;

      if (_selectedSphere.length > 0) sphere1 = _selectedSphere[0];

      if (_selectedSphere.length > 1) sphere2 = _selectedSphere[1];
    }
  }

  void _updateGoalReflection() async {
    GoalReflection3ModelModel requestModel = GoalReflection3ModelModel(
      sphere_1: sphere1.id, sphere_2: sphere2.id,
      sphere_1_answer: _sphere1DescController.text,
      // sphere_2_answer: _sphere2DescController.text
    );

    await Provider.of<GoalProvider>(context, listen: false)
        .saveReflection3(requestModel, updateForumCallback);
  }

  updateForumCallback(
      bool isStatusSuccess,
      GoalReflection3ModelModel? responseModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Reflection updated successfully'),
          backgroundColor: Colors.green));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => GoalReflection4Screen(sphere1: sphere1)));
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic sphere1Error = errorResponse?.errorJson["sphere_1"];
          dynamic sphere2Error = errorResponse?.errorJson["sphere_2"];
          dynamic sphere1AnswerError =
              errorResponse?.errorJson["sphere_1_answer"];
          dynamic sphere2AnswerError =
              errorResponse?.errorJson["sphere_2_answer"];

          if (sphere1Error != null && sphere1Error.length > 0) {
            errorDescription = (sphere1Error![0]! as String)
                .replaceAll("This field", "Sphere 1");
          } else if (sphere2Error != null && sphere2Error.length > 0) {
            errorDescription = (sphere2Error![0]! as String)
                .replaceAll("This field", "Sphere 2");
          } else if (sphere1AnswerError != null &&
              sphere1AnswerError.length > 0) {
            errorDescription = (sphere1AnswerError![0]! as String)
                .replaceAll("This field", "Sphere 1 Answer");
          } else if (sphere2AnswerError != null &&
              sphere2AnswerError.length > 0) {
            errorDescription = (sphere2AnswerError![0]! as String)
                .replaceAll("This field", "Sphere 2 Answer");
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goal, child) {
          if (sphere1.id! < 0) {
            sphere1 = goal.successSphereResponse!.data![0];
          }
          if (sphere2.id! < 0) {
            sphere2 = goal.successSphereResponse!.data![1];
          }

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
                                "3",
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
                            Container(
                              margin: const EdgeInsets.only(
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Text(
                                  getTranslated(
                                      'your_main_objectives', context),
                                  style: poppinsBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                            ),
                            //for contribute
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated(
                                          'i_want_to_improve_my_success_in_the',
                                          context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                    padding: const EdgeInsets.all(4),
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
                                          value: sphere1,
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                          items: goal
                                              .successSphereResponse!.data!
                                              .map((CommonListData items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(items.name ??
                                                    goal.successSphereResponse!
                                                        .data![1].name!));
                                          }).toList(),
                                          onChanged:
                                              (CommonListData? newValue) {
                                            setState(() {
                                              sphere1 = newValue!;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_SMALL,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Text(
                                  getTranslated('sphere_you_ranked_1', context),
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL)),
                            ),

                            // //for sphere 2
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       top: Dimensions.MARGIN_SIZE_DEFAULT,
                            //       left: Dimensions.MARGIN_SIZE_DEFAULT,
                            //       right: Dimensions.MARGIN_SIZE_DEFAULT),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //           getTranslated(
                            //               'i_want_to_improve_my_success_in_the', context),
                            //           style: customTextFieldTitle),
                            //       SizedBox(
                            //           height: Dimensions.MARGIN_SIZE_SMALL),
                            //       Container(
                            //         padding: const EdgeInsets.all(4),
                            //         width: MediaQuery.of(context).size.width,
                            //         decoration: BoxDecoration(
                            //           color: Theme.of(context).highlightColor,
                            //           borderRadius: BorderRadius.circular(10),
                            //           boxShadow: [
                            //             BoxShadow(
                            //                 color: Colors.grey.withOpacity(0.1),
                            //                 spreadRadius: 1,
                            //                 blurRadius: 3,
                            //                 offset: const Offset(0, 1))
                            //             // changes position of shadow
                            //           ],
                            //         ),
                            //         child: DropdownButtonHideUnderline(
                            //           child: DropdownButton(
                            //               isExpanded: true,
                            //               value: sphere2,
                            //               icon: const Icon(Icons
                            //                   .keyboard_arrow_down_outlined),
                            //               items: goal.successSphereResponse!.data!.map((CommonListData items) {
                            //                 return DropdownMenuItem(
                            //                     value: items,
                            //                     child: Text(items.name ?? goal.successSphereResponse!.data![0].name!));
                            //               }).toList(),
                            //               onChanged: (CommonListData? newValue) {
                            //                 setState(() {
                            //                   sphere2 = newValue!;
                            //                 });
                            //               }),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // Container(
                            //   margin: EdgeInsets.only(
                            //       top: Dimensions.MARGIN_SIZE_SMALL,
                            //       left: Dimensions.MARGIN_SIZE_DEFAULT,
                            //       right: Dimensions.MARGIN_SIZE_DEFAULT),
                            //   child: Text(
                            //       getTranslated(
                            //           'sphere_you_ranked_2', context),
                            //       style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                            // ),

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
                                          'reflection_1_sphere1_desc_title',
                                          context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _sphere1DescController,
                                    focusNode: _sphere1DescFocus,
                                    nextNode: _sphere2DescFocus,
                                    textInputAction: TextInputAction.next,
                                    maxLine: 4,
                                  ),
                                ],
                              ),
                            ),

                            // //for Description 2
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            //       left: Dimensions.MARGIN_SIZE_DEFAULT,
                            //       right: Dimensions.MARGIN_SIZE_DEFAULT),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //           getTranslated(
                            //               'reflection_2_sphere1_desc_title', context),
                            //           style: customTextFieldTitle),
                            //       SizedBox(
                            //           height: Dimensions.MARGIN_SIZE_SMALL),
                            //       CustomTextField(
                            //         controller: _sphere2DescController,
                            //         focusNode: _sphere2DescFocus,
                            //         textInputAction: TextInputAction.next,
                            //         maxLine: 4,
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: Dimensions.MARGIN_SIZE_LARGE,
                                          bottom: Dimensions.MARGIN_SIZE_LARGE,
                                          right: Dimensions.MARGIN_SIZE_SMALL),
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: CustomButtonSecondary(
                                        buttonText: "SKIP",
                                        borderColor:
                                            ColorResources.GRAY_BUTTON_BG_COLOR,
                                        bgColor:
                                            ColorResources.GRAY_BUTTON_BG_COLOR,
                                        textColor: Colors.white,
                                        textStyle: poppinsBold,
                                        fontSize: 16,
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      GoalReflection4Screen( sphere1: sphere1,)));
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: Dimensions.MARGIN_SIZE_LARGE,
                                            bottom:
                                                Dimensions.MARGIN_SIZE_LARGE,
                                            left: Dimensions.MARGIN_SIZE_SMALL),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: CustomButtonSecondary(
                                          buttonText: "SO, WHAT'S THE GOAL?",
                                          borderColor:
                                              Theme.of(context).primaryColor,
                                          bgColor:
                                              Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          textStyle: poppinsBold,
                                          fontSize: 16,
                                          onTap: () {
                                            _updateGoalReflection();
                                            //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => GoalReflection4Screen()));
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
              Loader().visible(goal.isLoading),
            ],
          );
        },
      ),
    );
  }
}
