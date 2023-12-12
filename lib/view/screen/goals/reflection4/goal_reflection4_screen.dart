import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/screen/goals/reflection4/widget/reminder_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/goals/reflection5/goal_reflection5_screen.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class GoalReflection4Screen extends StatefulWidget {
  final TopicModel? topicModel;
  final CommonListData? sphere1;
  GoalReflection4Screen({Key? key, this.topicModel, this.sphere1})
      : super(key: key);

  @override
  State<GoalReflection4Screen> createState() => _GoalReflection4ScreenState();
}

class _GoalReflection4ScreenState extends State<GoalReflection4Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final FocusNode _defineGoalFocus = FocusNode();
  final FocusNode _whyDescFocus = FocusNode();

  final TextEditingController _defineGoalController = TextEditingController();

  final TextEditingController _completionDateController =
      TextEditingController();

  CommonListData sphere = CommonListData(id: -1, name: "");
  DateTime? selectedDate;

  // List<String> frequency = ["Select", "Days", "Week", "Month", "year"];
  List<String> staticDdValue = [
    "Select",
    "Seek out new opportunities to connect with my community",
    "Improve my communication skills ",
    "Engage in a new social or recreational activity",
    "Seek out new, healthy social connection(s)/friends",
    "Gain clarity on what I value in friends and social connection",
    "Spend more time with my friends",
    "Other"
  ];

  List<TextEditingController> selectedDateCtrl = [];
  List<TextEditingController> othersCtrl = [];
  List<TextEditingController> freqCtrl = [];

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
            children: [
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
                  GestureDetector(
                    onTap: () {
                      _onActionReminderSelection(
                          actionPosition, getTranslated('DAILY', context));
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('DAILY', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _onActionReminderSelection(
                          actionPosition, getTranslated('WEEKLY', context));
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('WEEKLY', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
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
                  GestureDetector(
                    onTap: () {
                      _onActionReminderSelection(
                          actionPosition, getTranslated('MONTHLY', context));
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('MONTHLY', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _onActionReminderSelection(
                          actionPosition, getTranslated('YEARLY', context));
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('YEARLY', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date = "${picked?.year}-${picked?.month}-${picked?.day}";
        Provider.of<GoalProvider>(context, listen: false)
            .actionDateList[actionPosition] = date;
        selectedDateCtrl[actionPosition].text = date;

        if (_completionDateController.text.isEmpty) {
          _completionDateController.text = date;
        }

        // Define the date format
        final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        // Convert date string to a DateTime object
        DateTime? selectedDateTime = dateFormat.parse(date);
        DateTime? completionDateTime =
            dateFormat.parse(_completionDateController.text);

        if (_completionDateController.text.isEmpty ||
            selectedDateTime.isAfter(completionDateTime)) {
          _completionDateController.text = date;
          Provider.of<GoalProvider>(context, listen: false).completionDate =
              date;
        }

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

//  List<String> action = ["", '', '', '', '', ''];

  _onchangeAction(String value, int number) {
    if (value.isNotEmpty) {
      setState(() {
        Provider.of<GoalProvider>(context, listen: false)
            .selectedDropDownVal[number] = value;
        //  action[number] = value;
      });
    }
  }

  void updateActionSteps() {
    Provider.of<GoalProvider>(context, listen: false)
        .updateActionList(sphere.name!);
  }

  void _validateAndMoveToReflection5() {
    if (_completionDateController.text.isNotEmpty &&
        _defineGoalController.text.isNotEmpty &&
        Provider.of<GoalProvider>(context, listen: false)
            .selectedDropDownVal
            .any((element) => element != "Select")) {
      String defineGoal = _defineGoalController.text.trim();
      //  String whyDesc = _whyDescController.text.trim();

      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => GoalReflection5Screen(
              freqCtrl: freqCtrl,
              completionDate: _completionDateController.text,
              defineGoal: defineGoal,
              //  whyDesc: whyDesc,
              sphereId: sphere.id)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Please fill all mandatory feilds (complete goal , This is Your Why & one Action Step)'),
          backgroundColor: ColorResources.RED));
    }
  }

  @override
  void initState() {
    sphere = widget.sphere1!;
    for (int i = 0; i < 6; i++) {
      selectedDateCtrl.add(TextEditingController());
      othersCtrl.add(TextEditingController());
      freqCtrl.add(TextEditingController());
    }
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goal, child) {
          if (sphere.id! < 0 || widget.sphere1 == null) {
            sphere = goal.successSphereResponse!.data![0];
          }
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
                                "4",
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
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('FOCUS_SPHERE', context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: baseWhiteBoxDecoration(context),
                                    child: DropdownButtonHideUnderline(
                                      child: AbsorbPointer(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            value: sphere,
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
                                    top: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                                    right: Dimensions.MARGIN_SIZE_DEFAULT),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Completion Date:",
                                        style: customTextFieldTitle),
                                    const SizedBox(
                                        height: Dimensions.MARGIN_SIZE_SMALL),
                                    CustomTextField(
                                      controller: _completionDateController,
                                      // focusNode: _defineGoalFocus,
                                      // nextNode: _whyDescFocus,
                                      fillColor:
                                          ColorResources.APP_BACKGROUND_COLOR,
                                      textInputAction: TextInputAction.next,

                                      hintText: "Completion Date:",
                                      maxLine: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),

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
                                    "${getTranslated('DEFINE_YOUR_GOAL', context)} and why is that goal important to you?",
                                    style: customTextFieldTitle,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _defineGoalController,
                                    focusNode: _defineGoalFocus,
                                    nextNode: _whyDescFocus,
                                    textInputAction: TextInputAction.next,
                                    hintText: getTranslated(
                                        'reflection_4_define_goal_hint',
                                        context),
                                    maxLine: 4,
                                  ),
                                ],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated('YOUR_ACTION_MAP', context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height:
                                          Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                  Text(
                                      getTranslated('action_map_desc', context),
                                      style: poppinsRegular.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_SMALL)),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_LARGE,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('ACTION_STEP', context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height:
                                          Dimensions.MARGIN_SIZE_EXTRA_SMALL),

                                  Container(
                                    margin: const EdgeInsets.only(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                            height:
                                                Dimensions.MARGIN_SIZE_SMALL),
                                        Provider.of<GoalProvider>(context,
                                                        listen: false)
                                                    .selectedDropDownVal[0] ==
                                                "Other"
                                            ? CustomTextField(
                                                controller: othersCtrl[0],
                                                hintText: "Enter Custom Option",
                                                // focusNode: _sphere1DescFocus,
                                                // nextNode: _sphere2DescFocus,
                                                textInputAction:
                                                    TextInputAction.next,
                                                maxLine: 1,
                                                onChanged: (value) {
                                                  Provider.of<GoalProvider>(
                                                          context,
                                                          listen: false)
                                                      .othersVal[0] = value;
                                                },
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          goal.selectedDropDownVal[
                                                              0],
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down_outlined),
                                                      items: staticDdValue
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items ??
                                                                staticDdValue[
                                                                    0]));
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        _onchangeAction(
                                                            newValue!, 0);
                                                      }),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // Action 1
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionReminder(0, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.watch_later_outlined,
                                              color: ColorResources.WHITE,
                                              size: 30,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: CustomTextField(
                                            controller: freqCtrl[0],
                                            fillColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            hintText: "Frequency Count:",
                                            maxLine: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionCalendar(0, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: ColorResources.WHITE,
                                              size: 28,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            child: CustomTextField(
                                              controller: selectedDateCtrl[0],
                                              fillColor: ColorResources
                                                  .APP_BACKGROUND_COLOR,
                                              textInputAction:
                                                  TextInputAction.next,
                                              hintText: "yyyy-mm-dd",
                                              maxLine: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_DEFAULT,
                                  ),

                                  Provider.of<GoalProvider>(context,
                                                  listen: false)
                                              .selectedDropDownVal[1] ==
                                          "Other"
                                      ? CustomTextField(
                                          controller: othersCtrl[1],
                                          hintText: "Enter Custom Option",
                                          // focusNode: _sphere1DescFocus,
                                          // nextNode: _sphere2DescFocus,
                                          textInputAction: TextInputAction.next,
                                          maxLine: 1,
                                          onChanged: (value) {
                                            Provider.of<GoalProvider>(context,
                                                    listen: false)
                                                .othersVal[1] = value;
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  height: Dimensions
                                                      .MARGIN_SIZE_SMALL),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          goal.selectedDropDownVal[
                                                              1],
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down_outlined),
                                                      items: staticDdValue
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items ??
                                                                staticDdValue[
                                                                    0]));
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        _onchangeAction(
                                                            newValue!, 1);
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // Action 1
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionReminder(1, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.watch_later_outlined,
                                              color: ColorResources.WHITE,
                                              size: 30,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: CustomTextField(
                                            controller: freqCtrl[1],
                                            fillColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            hintText: "Frequency Count:",
                                            maxLine: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionCalendar(1, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: ColorResources.WHITE,
                                              size: 28,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            child: CustomTextField(
                                              controller: selectedDateCtrl[1],
                                              fillColor: ColorResources
                                                  .APP_BACKGROUND_COLOR,
                                              textInputAction:
                                                  TextInputAction.next,
                                              hintText: "yyyy-mm-dd",
                                              maxLine: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_DEFAULT,
                                  ),

                                  Provider.of<GoalProvider>(context,
                                                  listen: false)
                                              .selectedDropDownVal[2] ==
                                          "Other"
                                      ? CustomTextField(
                                          controller: othersCtrl[2],
                                          hintText: "Enter Custom Option",
                                          // focusNode: _sphere1DescFocus,
                                          // nextNode: _sphere2DescFocus,
                                          textInputAction: TextInputAction.next,
                                          maxLine: 1,
                                          onChanged: (value) {
                                            Provider.of<GoalProvider>(context,
                                                    listen: false)
                                                .othersVal[2] = value;
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  height: Dimensions
                                                      .MARGIN_SIZE_SMALL),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          goal.selectedDropDownVal[
                                                              2],
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down_outlined),
                                                      items: staticDdValue
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items ??
                                                                staticDdValue[
                                                                    0]));
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        _onchangeAction(
                                                            newValue!, 2);
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionReminder(2, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.watch_later_outlined,
                                              color: ColorResources.WHITE,
                                              size: 30,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: CustomTextField(
                                            controller: freqCtrl[2],
                                            fillColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            hintText: "Frequency Count:",
                                            maxLine: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionCalendar(2, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: ColorResources.WHITE,
                                              size: 28,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            child: CustomTextField(
                                              controller: selectedDateCtrl[2],
                                              fillColor: ColorResources
                                                  .APP_BACKGROUND_COLOR,
                                              textInputAction:
                                                  TextInputAction.next,
                                              hintText: "yyyy-mm-dd",
                                              maxLine: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_DEFAULT,
                                  ),
                                  Provider.of<GoalProvider>(context,
                                                  listen: false)
                                              .selectedDropDownVal[3] ==
                                          "Other"
                                      ? CustomTextField(
                                          controller: othersCtrl[3],
                                          hintText: "Enter Custom Option",
                                          // focusNode: _sphere1DescFocus,
                                          // nextNode: _sphere2DescFocus,
                                          textInputAction: TextInputAction.next,
                                          maxLine: 1,
                                          onChanged: (value) {
                                            Provider.of<GoalProvider>(context,
                                                    listen: false)
                                                .othersVal[3] = value;
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  height: Dimensions
                                                      .MARGIN_SIZE_SMALL),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          goal.selectedDropDownVal[
                                                              3],
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down_outlined),
                                                      items: staticDdValue
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items ??
                                                                staticDdValue[
                                                                    0]));
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        _onchangeAction(
                                                            newValue!, 3);
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionReminder(3, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.watch_later_outlined,
                                              color: ColorResources.WHITE,
                                              size: 30,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: CustomTextField(
                                            controller: freqCtrl[3],
                                            fillColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            hintText: "Frequency Count:",
                                            maxLine: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionCalendar(3, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: ColorResources.WHITE,
                                              size: 28,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            child: CustomTextField(
                                              controller: selectedDateCtrl[3],
                                              fillColor: ColorResources
                                                  .APP_BACKGROUND_COLOR,
                                              textInputAction:
                                                  TextInputAction.next,
                                              hintText: "yyyy-mm-dd",
                                              maxLine: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_DEFAULT,
                                  ),

                                  Provider.of<GoalProvider>(context,
                                                  listen: false)
                                              .selectedDropDownVal[4] ==
                                          "Other"
                                      ? CustomTextField(
                                          controller: othersCtrl[4],
                                          hintText: "Enter Custom Option",
                                          // focusNode: _sphere1DescFocus,
                                          // nextNode: _sphere2DescFocus,
                                          textInputAction: TextInputAction.next,
                                          maxLine: 1,
                                          onChanged: (value) {
                                            Provider.of<GoalProvider>(context,
                                                    listen: false)
                                                .othersVal[4] = value;
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  height: Dimensions
                                                      .MARGIN_SIZE_SMALL),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          goal.selectedDropDownVal[
                                                              4],
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down_outlined),
                                                      items: staticDdValue
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items ??
                                                                staticDdValue[
                                                                    0]));
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        _onchangeAction(
                                                            newValue!, 4);
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionReminder(4, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.watch_later_outlined,
                                              color: ColorResources.WHITE,
                                              size: 30,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: CustomTextField(
                                            controller: freqCtrl[4],
                                            fillColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            hintText: "Frequency Count:",
                                            maxLine: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionCalendar(4, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: ColorResources.WHITE,
                                              size: 28,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            child: CustomTextField(
                                              controller: selectedDateCtrl[4],
                                              fillColor: ColorResources
                                                  .APP_BACKGROUND_COLOR,
                                              textInputAction:
                                                  TextInputAction.next,
                                              hintText: "yyyy-mm-dd",
                                              maxLine: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_DEFAULT,
                                  ),
                                  Provider.of<GoalProvider>(context,
                                                  listen: false)
                                              .selectedDropDownVal[5] ==
                                          "Other"
                                      ? CustomTextField(
                                          controller: othersCtrl[5],
                                          hintText: "Enter Custom Option",
                                          // focusNode: _sphere1DescFocus,
                                          // nextNode: _sphere2DescFocus,
                                          textInputAction: TextInputAction.next,
                                          maxLine: 1,
                                          onChanged: (value) {
                                            Provider.of<GoalProvider>(context,
                                                    listen: false)
                                                .othersVal[5] = value;
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  height: Dimensions
                                                      .MARGIN_SIZE_SMALL),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:
                                                    baseWhiteBoxDecoration(
                                                        context),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          goal.selectedDropDownVal[
                                                              5],
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down_outlined),
                                                      items: staticDdValue
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items ??
                                                                staticDdValue[
                                                                    0]));
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        _onchangeAction(
                                                            newValue!, 5);
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionReminder(5, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.watch_later_outlined,
                                              color: ColorResources.WHITE,
                                              size: 30,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: CustomTextField(
                                            controller: freqCtrl[5],
                                            fillColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            hintText: "Frequency Count:",
                                            maxLine: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 1),
                                              ), // changes position of shadow
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _addActionCalendar(5, context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: ColorResources.WHITE,
                                              size: 28,
                                            ),
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.MARGIN_SIZE_SMALL,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            child: CustomTextField(
                                              controller: selectedDateCtrl[5],
                                              fillColor: ColorResources
                                                  .APP_BACKGROUND_COLOR,
                                              textInputAction:
                                                  TextInputAction.next,
                                              hintText: "yyyy-mm-dd",
                                              maxLine: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_DEFAULT,
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
                                          getTranslated("NEXT", context),
                                      borderColor:
                                          Theme.of(context).primaryColor,
                                      bgColor: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      textStyle: poppinsBold,
                                      fontSize: 16,
                                      onTap: () {
                                        _validateAndMoveToReflection5();
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
