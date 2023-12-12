import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/utill/system_utils.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/screen/goals/reflection4/widget/reminder_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/goals/reflection5/goal_reflection5_screen.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/response/base/error_response.dart';
import '../../../../data/model/response/create_goal_model.dart';
import '../../../../data/model/response/goal_model.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class ProgressCompletePage extends StatefulWidget {
  final GoalModel? goalMOdel;
  const ProgressCompletePage({Key? key, this.goalMOdel}) : super(key: key);

  @override
  State<ProgressCompletePage> createState() => _ProgressCompletePageState();
}

class _ProgressCompletePageState extends State<ProgressCompletePage> {
  CreateGoalModel? progressData;

  @override
  void initState() {
    // if (widget.goalMOdel != null) {
    //   sphere = CommonListData(
    //       id: widget.goalMOdel!.sphere!.id,
    //       name: widget.goalMOdel!.sphere!.name);
    // } else {
    //   sphere = CommonListData(id: -1, name: "");
    // }
    selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProgressDetail();
      getSuccessSphere();
    });

    super.initState();
  }

  getProgressDetail() async {
    progressData = await Provider.of<GoalProvider>(context, listen: false)
        .getProgressData(widget.goalMOdel!.id!, '/goal/');
    _defineGoalController.text = progressData!.define_goal!;
    _completionDateController.text = progressData!.completion_date ?? "";
  }

  getSuccessSphere() async {
    await Provider.of<GoalProvider>(context, listen: false)
        .getSuccessSphere(getSuccessSphereCallback);
  }

  List<CommonListData>? _spheresList = <CommonListData>[];

  getSuccessSphereCallback(bool isStatusSuccess,
      AppListingModel? successResponse, ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      _spheresList = successResponse?.data;
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

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final FocusNode _defineGoalFocus = FocusNode();
  final FocusNode _whyDescFocus = FocusNode();

  final TextEditingController _defineGoalController = TextEditingController();
  final TextEditingController _whyDescController = TextEditingController();
  final TextEditingController _completionDateController =
      TextEditingController();

  CommonListData sphere = CommonListData(id: -1, name: "");
  DateTime selectedDate = DateTime.now();

  void _addActionReminder(int actionPosition, BuildContext context) async {
    showModalBottomSheet<int>(
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        //for bottom post
        return ReminderBottomSheetWidget(
          child: ListView(
            shrinkWrap: true,
            children: const [
              Column(
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     _onActionReminderSelection(actionPosition, getTranslated('HOURLY', context));
                  //     Navigator.pop(context);
                  //   },
                  //   child: _buildListItem(
                  //     context,
                  //     title: Text(
                  //       getTranslated('HOURLY', context),
                  //       style: poppinsRegular.copyWith(
                  //           fontSize: Dimensions.FONT_SIZE_LARGE,
                  //           color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _onActionReminderSelection(
                  //         actionPosition, getTranslated('DAILY', context));
                  //     Navigator.pop(context);
                  //   },
                  //   child: _buildListItem(
                  //     context,
                  //     title: Text(
                  //       getTranslated('DAILY', context),
                  //       style: poppinsRegular.copyWith(
                  //           fontSize: Dimensions.FONT_SIZE_LARGE,
                  //           color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _onActionReminderSelection(
                  //         actionPosition, getTranslated('WEEKLY', context));
                  //     Navigator.pop(context);
                  //   },
                  //   child: _buildListItem(
                  //     context,
                  //     title: Text(
                  //       getTranslated('WEEKLY', context),
                  //       style: poppinsRegular.copyWith(
                  //           fontSize: Dimensions.FONT_SIZE_LARGE,
                  //           color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _onActionReminderSelection(actionPosition, getTranslated('FORTNIGHTLY', context));
                  //     Navigator.pop(context);
                  //   },
                  //   child: _buildListItem(
                  //     context,
                  //     title: Text(
                  //       getTranslated('FORTNIGHTLY', context),
                  //       style: poppinsRegular.copyWith(
                  //           fontSize: Dimensions.FONT_SIZE_LARGE,
                  //           color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _onActionReminderSelection(
                  //         actionPosition, getTranslated('MONTHLY', context));
                  //     Navigator.pop(context);
                  //   },
                  //   child: _buildListItem(
                  //     context,
                  //     title: Text(
                  //       getTranslated('MONTHLY', context),
                  //       style: poppinsRegular.copyWith(
                  //           fontSize: Dimensions.FONT_SIZE_LARGE,
                  //           color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _addActionCalendar(int actionPosition, BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date = "${picked?.year}-${picked?.month}-${picked?.day}";
        Provider.of<GoalProvider>(context, listen: false)
            .actionDateList[actionPosition] = date;
        //showCustomSnackBar(date, context, isError: false);
      });
    }
  }

  _onActionReminderSelection(int actionPosition, String reminder) {
    //showCustomSnackBar('Button Clicked $reminder', context, isError: false);
    Provider.of<GoalProvider>(context, listen: false)
        .actionReminderList[actionPosition] = reminder;
  }

  _onChangeSphere(CommonListData? changedSphere) {
    if (changedSphere != null) {
      setState(() {
        sphere = changedSphere;
      });
      updateActionSteps();
    }
  }

  void updateActionSteps() {
    Provider.of<GoalProvider>(context, listen: false)
        .updateActionList(sphere!.name!);
  }

  // void _validateAndMoveToReflection5() {
  //   String defineGoal = _defineGoalController.text.trim();
  //   String whyDesc = _whyDescController.text.trim();

  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) => GoalReflection5Screen(
  //           defineGoal: defineGoal, whyDesc: whyDesc, sphereId: sphere!.id)));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goal, child) {
          if (sphere.id! < 0 && _spheresList!.isNotEmpty) {
            // int index  = goal.successSphereResponse!.data!.indexOf(widget.goalMOdel!.sphere!);
            sphere = _spheresList![0];

            _spheresList!.forEach((element) {
              if (element.id == widget.goalMOdel!.sphere!.id) {
                // log("${element.id}  ${widget.goalMOdel!.sphere!.id}");
                sphere = element;
              }
            });
          }
          return goal.successSphereResponse!.data!.isEmpty || progressData == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
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
                        Text("In Progress",
                            style: poppinsBold.copyWith(
                                fontSize: 20, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(
                          width: 16,
                        ),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          const SizedBox(
                              height: Dimensions.MARGIN_SIZE_DEFAULT),
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
                                        top: Dimensions.MARGIN_SIZE_DEFAULT,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'FOCUS_SPHERE', context),
                                            style: customTextFieldTitle),
                                        const SizedBox(
                                            height:
                                                Dimensions.MARGIN_SIZE_SMALL),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration:
                                              baseWhiteBoxDecoration(context),
                                          child: AbsorbPointer(
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  isExpanded: true,
                                                  value: sphere,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down_outlined),
                                                  items: _spheresList!.map(
                                                      (CommonListData items) {
                                                    return DropdownMenuItem(
                                                        value: items,
                                                        child: Text(
                                                            items.name ??
                                                                _spheresList![1]
                                                                    .name!));
                                                  }).toList(),
                                                  onChanged: (CommonListData?
                                                      newValue) {
                                                    _onChangeSphere(newValue);
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AbsorbPointer(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: Dimensions
                                              .MARGIN_SIZE_EXTRA_LARGE,
                                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                                          right:
                                              Dimensions.MARGIN_SIZE_DEFAULT),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Completion Date:",
                                              style: customTextFieldTitle),
                                          const SizedBox(
                                              height:
                                                  Dimensions.MARGIN_SIZE_SMALL),
                                          CustomTextField(
                                            controller:
                                                _completionDateController,
                                            // focusNode: _defineGoalFocus,
                                            // nextNode: _whyDescFocus,
                                            fillColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                            textInputAction:
                                                TextInputAction.next,

                                            hintText: "Completion Date:",
                                            maxLine: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //for Description 1
                                  IgnorePointer(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: Dimensions
                                              .MARGIN_SIZE_EXTRA_LARGE,
                                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                                          right:
                                              Dimensions.MARGIN_SIZE_DEFAULT),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'DEFINE_YOUR_GOAL', context),
                                              style: customTextFieldTitle),
                                          const SizedBox(
                                              height:
                                                  Dimensions.MARGIN_SIZE_SMALL),
                                          CustomTextField(
                                            controller: _defineGoalController,
                                            focusNode: _defineGoalFocus,
                                            nextNode: _whyDescFocus,
                                            textInputAction:
                                                TextInputAction.next,
                                            hintText: getTranslated(
                                                'reflection_4_define_goal_hint',
                                                context),
                                            maxLine: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // //for Description 2
                                  // Container(
                                  //   margin: const EdgeInsets.only(
                                  //       top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                                  //       left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  //       right: Dimensions.MARGIN_SIZE_DEFAULT),
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text(
                                  //           getTranslated(
                                  //               'THIS_IS_YOUR_WHY', context),
                                  //           style: customTextFieldTitle),
                                  //       const SizedBox(
                                  //           height: Dimensions.MARGIN_SIZE_SMALL),
                                  //       CustomTextField(
                                  //         controller: _whyDescController,
                                  //         focusNode: _whyDescFocus,
                                  //         textInputAction: TextInputAction.done,
                                  //         hintText: getTranslated(
                                  //             'reflection_4_define_goal_why_hint',
                                  //             context),
                                  //         maxLine: 4,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_LARGE,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'YOUR_ACTION_MAP', context),
                                            style: customTextFieldTitle),
                                        const SizedBox(
                                            height: Dimensions
                                                .MARGIN_SIZE_EXTRA_SMALL),
                                        Text(
                                            getTranslated(
                                                'action_map_desc', context),
                                            style: poppinsRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_SMALL)),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_LARGE,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'ACTION_STEP', context),
                                            style: customTextFieldTitle),
                                        const SizedBox(
                                            height: Dimensions
                                                .MARGIN_SIZE_EXTRA_SMALL),

                                        // Action 1
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child: Text(
                                                  
                                                  progressData!.action_step_1!,
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              // child: IconButton(
                                              //   onPressed: () {
                                              //     _addActionReminder(0, context);
                                              //   },
                                              //   padding: const EdgeInsets.all(0),
                                              //   icon: const Icon(
                                              //       Icons.watch_later_outlined,
                                              //       color: ColorResources.WHITE,
                                              //       size: 30),
                                              //   color:
                                              //       ColorResources.DARK_GREEN_COLOR,
                                              // ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  _addActionCalendar(
                                                      0, context);
                                                },
                                                padding:
                                                    const EdgeInsets.all(0),
                                                icon: const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: ColorResources.WHITE,
                                                    size: 28),
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height:
                                              Dimensions.MARGIN_SIZE_DEFAULT,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child: Text(
                                                  progressData!.action_step_2!,
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              // child: IconButton(
                                              //   onPressed: () {
                                              //     _addActionReminder(1, context);
                                              //   },
                                              //   padding: const EdgeInsets.all(0),
                                              //   icon: const Icon(
                                              //       Icons.watch_later_outlined,
                                              //       color: ColorResources.WHITE,
                                              //       size: 30),
                                              //   color:
                                              //       ColorResources.DARK_GREEN_COLOR,
                                              // ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  _addActionCalendar(
                                                      1, context);
                                                },
                                                padding:
                                                    const EdgeInsets.all(0),
                                                icon: const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: ColorResources.WHITE,
                                                    size: 28),
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height:
                                              Dimensions.MARGIN_SIZE_DEFAULT,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child: Text(
                                                  progressData!.action_step_3!,
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              // child: IconButton(
                                              //   onPressed: () {
                                              //     _addActionReminder(2, context);
                                              //   },
                                              //   padding: const EdgeInsets.all(0),
                                              //   icon: const Icon(
                                              //       Icons.watch_later_outlined,
                                              //       color: ColorResources.WHITE,
                                              //       size: 30),
                                              //   color:
                                              //       ColorResources.DARK_GREEN_COLOR,
                                              // ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  _addActionCalendar(
                                                      2, context);
                                                },
                                                padding:
                                                    const EdgeInsets.all(0),
                                                icon: const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: ColorResources.WHITE,
                                                    size: 28),
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height:
                                              Dimensions.MARGIN_SIZE_DEFAULT,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child: Text(
                                                  progressData!.action_step_4!,
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              // child: IconButton(
                                              //   onPressed: () {
                                              //     _addActionReminder(3, context);
                                              //   },
                                              //   padding: const EdgeInsets.all(0),
                                              //   icon: const Icon(
                                              //       Icons.watch_later_outlined,
                                              //       color: ColorResources.WHITE,
                                              //       size: 30),
                                              //   color:
                                              //       ColorResources.DARK_GREEN_COLOR,
                                              // ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  _addActionCalendar(
                                                      3, context);
                                                },
                                                padding:
                                                    const EdgeInsets.all(0),
                                                icon: const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: ColorResources.WHITE,
                                                    size: 28),
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height:
                                              Dimensions.MARGIN_SIZE_DEFAULT,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child: Text(
                                                  progressData!.action_step_5!,
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              // child: IconButton(
                                              //   onPressed: () {
                                              //     _addActionReminder(4, context);
                                              //   },
                                              //   padding: const EdgeInsets.all(0),
                                              //   icon: const Icon(
                                              //       Icons.watch_later_outlined,
                                              //       color: ColorResources.WHITE,
                                              //       size: 30),
                                              //   color:
                                              //       ColorResources.DARK_GREEN_COLOR,
                                              // ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  _addActionCalendar(
                                                      4, context);
                                                },
                                                padding:
                                                    const EdgeInsets.all(0),
                                                icon: const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: ColorResources.WHITE,
                                                    size: 28),
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height:
                                              Dimensions.MARGIN_SIZE_DEFAULT,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child: Text(
                                                  progressData!.action_step_6!,
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              // child: IconButton(
                                              //   onPressed: () {
                                              //     _addActionReminder(5, context);
                                              //   },
                                              //   padding: const EdgeInsets.all(0),
                                              //   icon: const Icon(
                                              //       Icons.watch_later_outlined,
                                              //       color: ColorResources.WHITE,
                                              //       size: 30),
                                              //   color:
                                              //       ColorResources.DARK_GREEN_COLOR,
                                              // ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .MARGIN_SIZE_DEFAULT,
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1)) // changes position of shadow
                                                ],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  _addActionCalendar(
                                                      5, context);
                                                },
                                                padding:
                                                    const EdgeInsets.all(0),
                                                icon: const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: ColorResources.WHITE,
                                                    size: 28),
                                                color: ColorResources
                                                    .DARK_GREEN_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              top: Dimensions.MARGIN_SIZE_LARGE,
                                              bottom:
                                                  Dimensions.MARGIN_SIZE_LARGE),
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: CustomButtonSecondary(
                                            buttonText: "Make it Complete",
                                            borderColor:
                                                Theme.of(context).primaryColor,
                                            bgColor:
                                                Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                            textStyle: poppinsBold,
                                            fontSize: 16,
                                            onTap: () {
                                              completeGoal();

                                              // ScaffoldMessenger.of(context)
                                              //     .showSnackBar(const SnackBar(
                                              //   content: Text(
                                              //     "Work In Progress",
                                              //   ),
                                              //   backgroundColor: Colors.red,
                                              // ));
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

  completeGoal() async {
    await Provider.of<GoalProvider>(context, listen: false).achieveGoal(
        (bool check) {
      if (check) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }, widget.goalMOdel!.id!, '/goal/');
  }

  Widget _buildListItem(
    BuildContext context, {
    Widget? title,
    Widget? leading,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 10.0,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorResources.NAVIGATION_DIVIDER_COLOR,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (leading != null) leading,
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: DefaultTextStyle(
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.black),
                child: title,
              ),
            ),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
