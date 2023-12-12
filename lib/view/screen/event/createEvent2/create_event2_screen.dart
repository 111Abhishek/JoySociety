import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_event_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/event_config_model.dart';
import 'package:joy_society/data/model/response/event_frequency_model.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_util.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop2/create_workshop2_screen.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class CreateEvent2Screen extends StatefulWidget {

  const CreateEvent2Screen({Key? key})
      : super(key: key);

  @override
  State<CreateEvent2Screen> createState() => _CreateEvent2ScreenState();
}

class _CreateEvent2ScreenState extends State<CreateEvent2Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  DateTime? selectedRepeatEndOnDate;
  String? repeatEndOnDate;
  TimeOfDay selectedStartTime = TimeOfDay.now();

  bool isSwitched = false;
  var eventOnlineOrOffline = "Online";
  bool isEventOnline = true;

  String eventRepeatValue = 'Daily';
  var eventRepeatList = ['Daily', 'Weekly', 'Monthly', 'Custom'];

  String eventOccuranceValue = 'Day';
  var eventOccuranceList = ['Day', 'Week', 'Month', 'Year'];

  String eventRepeatInMonthValue = 'Monthly on day 13';
  var eventRepeatInMonthList = ['Monthly on day 13', 'Monthly on the second Friday'];

  var repeatEndsOnRadioGroupValue = "On Date";

  final FocusNode _occuranceCountFocus = FocusNode();
  final FocusNode _repeatEndsOccurencesFocus = FocusNode();
  final FocusNode _workshopTaglineFocus = FocusNode();
  final FocusNode _venueNameFocus = FocusNode();
  final FocusNode _streetAddressFocus = FocusNode();
  final FocusNode _cityStateZipFocus = FocusNode();
  final FocusNode _optionalLinkFocus = FocusNode();

  final TextEditingController _occuranceCountController = TextEditingController();
  final TextEditingController _repeatEndsOccurencesController = TextEditingController();
  final TextEditingController _venueNameController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityStateZipController = TextEditingController();
  final TextEditingController _optionalLinkController = TextEditingController();

  List<String> weekDays = [
    "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
  ];
  List<String> selectedChoices = [];
  List<Widget?> choices = [];

  @override
  void initState() {
    super.initState();
    selectedRepeatEndOnDate = DateTime.now();
    _occuranceCountController.text = "1";
    _repeatEndsOccurencesController.text = "10";
  }

  void _createEvent() async {
    CreateEventModel? createEvent = Provider.of<EventProvider>(context, listen: false).createEventModel;
    dynamic repeatOn ;
    String? repeatEnds ;
    String? repeatEndsValue ;
    if(createEvent != null) {
      if(eventRepeatValue == "Custom") {


        if(eventOccuranceValue == "Week") {
          repeatOn = selectedChoices;
        } else if(eventOccuranceValue == "Month") {
          repeatOn = eventRepeatInMonthValue;
        } else {
          repeatOn = null;
        }


        if(repeatEndsOnRadioGroupValue == "On Date") {
          repeatEnds = "Date";
          repeatEndsValue = repeatEndOnDate;
        } else if(repeatEndsOnRadioGroupValue == "After") {
          repeatEnds = "AFTER";
          repeatEndsValue = _repeatEndsOccurencesController.text.trim();
        } else if(repeatEndsOnRadioGroupValue == "Never") {
          repeatEnds = "NEVER";
          repeatEndsValue = null;
        }
      }


      EventFrequencyModel eventFrequencyModel = EventFrequencyModel();
      if(isSwitched) {
        eventFrequencyModel = EventFrequencyModel(
            frequency : eventRepeatValue.toUpperCase(),
            occurrence : _occuranceCountController.text.isNotEmpty ? _occuranceCountController.text.trim() : null,
            occurrence_frequency : eventOccuranceValue,
            repeat_on : repeatOn,
            repeat_ends : repeatEnds,
            repeat_ends_value : repeatEndsValue,
        );
      }

      EventConfigModel? eventConfig = EventConfigModel(
        event_frequency: eventFrequencyModel
      );

      CreateEventModel requestModel = CreateEventModel(
          title: createEvent.title,
          start_datetime: createEvent.start_datetime,
          end_datetime: createEvent.end_datetime,
          event_type: eventOnlineOrOffline.toUpperCase(),
          repeat_event: isSwitched,
          event_config: eventConfig,
          event_image: "http://35.84.158.122/media/Event/pexels-anjana-c-674010.jpg",
          description: "event description ..."
      );

      Provider.of<EventProvider>(context, listen: false).createEvent(requestModel, updateForumCallback);
    }
  }

  updateForumCallback(
      bool isStatusSuccess,
      CreateEventModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Event Created successfully'),
          backgroundColor: Colors.green));
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic titleError = errorResponse?.errorJson["title"];
          dynamic taglineError = errorResponse?.errorJson["tagline"];
          dynamic descriptionError = errorResponse?.errorJson["description"];
          dynamic privacyError = errorResponse?.errorJson["privacy"];

          if (titleError != null && titleError.length > 0) {
            errorDescription = (titleError![0]! as String).replaceAll("This field", "Title");
          } else if (taglineError != null && taglineError.length > 0) {
            errorDescription = (taglineError![0]! as String).replaceAll("This field", "Tagline");
          } else if (descriptionError != null && descriptionError.length > 0) {
            errorDescription = (descriptionError![0]! as String).replaceAll("This field", "Description");
          } else if (privacyError != null && privacyError.length > 0) {
            errorDescription = (privacyError![0]! as String).replaceAll("This field", "Privacy");
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  String getFormattedDate(DateTime picked) {
    var year = picked.year.toString();
    var month = picked.month.toString();
    if(picked.month < 10){
      month = "0${picked.month}";
    }
    var day = picked.day.toString();
    if(picked.day < 10){
      day = "0${picked.day}";
    }
    return "$year-$month-$day";
  }

  void _addRepeatEndsOnCalendar(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedRepeatEndOnDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedRepeatEndOnDate) {
      setState(() {
        selectedRepeatEndOnDate = picked;
        repeatEndOnDate = getFormattedDate(picked);
        //showCustomSnackBar(date, context, isError: false);
      });
    }
  }

  _onEventRepeatDropDownChange(String? newValue) {
    setState(() {
      eventRepeatValue = newValue!;
      /*if(eventRepeatValue == "Multiple Choice") {
        choicesVisibility = true;
      } else {
        choicesVisibility = false;
      }*/
    });

  }

  _onEventOccuranceDropDownChange(String? newValue) {
    setState(() {
      eventOccuranceValue = newValue!;
    });
  }
  _onMonthOccurenceDropDownChange(String? newValue) {
    setState(() {
      eventRepeatInMonthValue = newValue!;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<EventProvider>(
        builder: (context, goal, child) {

          //  _emailController.text = profile.userPhoneEmailModel?.email ?? "";
          return Scaffold(
              appBar:
                  appBar(context, getTranslated('EVENT_SETTINGS', context)),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                          Row(

                          children: [
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  print(isSwitched);
                                });
                              },
                              activeTrackColor: ColorResources.SECONDARY_COLOR,
                              activeColor: Colors.green,
                            ),
                            Text(
                                "Repeat Event",
                                style: customTextFieldTitle),
                            ]
                          ),

                            // Event Type
                            Visibility(
                              visible: isSwitched,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    top: Dimensions.MARGIN_SIZE_SMALL,
                                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                                    right: Dimensions.MARGIN_SIZE_DEFAULT),
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
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      isExpanded: true,
                                      value: eventRepeatValue,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      items: eventRepeatList.map((String items) {
                                        return DropdownMenuItem(
                                            value: items, child: Text(items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        _onEventRepeatDropDownChange(newValue);
                                      }),
                                ),
                              ),
                            ),

                          SizedBox(height: 16,),

                          // Occurrence
                          Visibility(
                            visible: isSwitched && eventRepeatValue == "Custom",
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Occurs Every *",
                                      style: customTextFieldTitle),
                                  //SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child:CustomTextField(
                                          controller: _occuranceCountController,
                                          focusNode: _occuranceCountFocus,
                                          nextNode: _workshopTaglineFocus,
                                          textInputAction: TextInputAction.next,
                                            textInputType: TextInputType.number
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(
                                              top: Dimensions.MARGIN_SIZE_SMALL,
                                              left: Dimensions.MARGIN_SIZE_DEFAULT,
                                              right: Dimensions.MARGIN_SIZE_DEFAULT),
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
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                isExpanded: true,
                                                value: eventOccuranceValue,
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down_outlined),
                                                items: eventOccuranceList.map((String items) {
                                                  return DropdownMenuItem(
                                                      value: items, child: Text(items));
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  _onEventOccuranceDropDownChange(newValue);
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                            // Week Repeat on
                            Visibility(
                              visible: (isSwitched  && eventRepeatValue == "Custom"
                                  && eventOccuranceValue == "Week"),
                              child: Wrap(children: weekDays.map(
                                    (hobby) {
                                  bool isSelected = false;
                                  if (selectedChoices.contains(hobby)) {
                                    isSelected = true;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (!selectedChoices.contains(hobby)) {
                                        if (selectedChoices.length < 7) {
                                          selectedChoices.add(hobby);
                                          setState(() {});
                                          print(selectedChoices);
                                        }
                                      } else {
                                        selectedChoices
                                            .removeWhere((element) => element == hobby);
                                        setState(() {});
                                        print(selectedChoices);
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 4),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: isSelected
                                                      ? ColorResources.GREEN
                                                      : Colors.grey,
                                                  width: 2)),
                                          child: Text(
                                            hobby,
                                            style: poppinsRegular.copyWith(fontSize: 16, ),
                                          ),
                                        )),
                                  );
                                },
                              ).toList(),
                              ).marginOnly(top: 10),
                            ),


                            Visibility(
                              visible: (isSwitched  && eventRepeatValue == "Custom"
                                  && eventOccuranceValue == "Month"),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Repeats *",
                                    style: customTextFieldTitle,
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_SMALL,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
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

                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          value: eventRepeatInMonthValue,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_outlined),
                                          items: eventRepeatInMonthList.map((String items) {
                                            return DropdownMenuItem(
                                                value: items, child: Text(items));
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            _onMonthOccurenceDropDownChange(newValue);
                                          }),
                                    ),
                                  ),

                                ],
                              ),
                            ).marginOnly(top: 16),

                            Visibility(
                              visible: isSwitched && eventRepeatValue == "Custom",
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Repeats Ends",
                                    style: customTextFieldTitle,
                                  ),

                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    children: [
                                      Radio(
                                        value: 'On Date',
                                        groupValue: repeatEndsOnRadioGroupValue,
                                        onChanged: (dynamic value) {
                                          setState(() {
                                            repeatEndsOnRadioGroupValue = value;
                                            //isEventOnline = true;
                                          });
                                        },
                                      ),
                                      Text('On Date', style: poppinsRegular),
                                      Radio(
                                        value: 'After',
                                        groupValue: repeatEndsOnRadioGroupValue,
                                        onChanged: (dynamic value) {
                                          setState(() {
                                            repeatEndsOnRadioGroupValue = value;
                                            //isEventOnline = false;
                                          });
                                        },
                                      ),
                                      Text('After', style: poppinsRegular),
                                      Radio(
                                        value: 'Never',
                                        groupValue: repeatEndsOnRadioGroupValue,
                                        onChanged: (dynamic value) {
                                          setState(() {
                                            repeatEndsOnRadioGroupValue = value;
                                            //isEventOnline = false;
                                          });
                                        },
                                      ),
                                      Text('Never', style: poppinsRegular),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child:Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).highlightColor,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text( repeatEndOnDate ?? "YYYY-MM-DD",
                                                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                                      color: ColorResources.TEXT_FORM_TEXT_COLOR),overflow: TextOverflow.ellipsis,),
                                              ),
                                              Icon(Icons.keyboard_arrow_down_outlined),
                                            ],
                                          ),
                                        ).onTap(() {
                                          _addRepeatEndsOnCalendar(context);
                                        }).visible(repeatEndsOnRadioGroupValue == "On Date" ),
                                      ),
                                    ],
                                  ).marginOnly(top: 10),

                                  CustomTextField(
                                    controller: _repeatEndsOccurencesController,
                                    focusNode: _repeatEndsOccurencesFocus,
                                    nextNode: _workshopTaglineFocus,
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.number,
                                  ).marginOnly(top: 10)
                                      .visible(repeatEndsOnRadioGroupValue == "After" ),
                                ],
                              ),
                            ).marginOnly(top: 16),

                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              direction: Axis.horizontal,
                              children: [
                                Radio(
                                  value: 'Online',
                                  groupValue: eventOnlineOrOffline,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      eventOnlineOrOffline = value;
                                      isEventOnline = true;
                                    });
                                  },
                                ),
                                Text('Online', style: poppinsRegular),
                                Radio(
                                  value: 'Local',
                                  groupValue: eventOnlineOrOffline,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      eventOnlineOrOffline = value;
                                      isEventOnline = false;
                                    });
                                  },
                                ),
                                Text('Local', style: poppinsRegular),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Location",
                                  style: customTextFieldTitle,
                                ),
                                CustomTextField(
                                  controller: _venueNameController,
                                  focusNode: _venueNameFocus,
                                  //nextNode: _workshopTaglineFocus,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  hintText: "Venue Name",
                                ).marginOnly(top: 10),

                                CustomTextField(
                                  controller: _streetAddressController,
                                  focusNode: _streetAddressFocus,
                                  //nextNode: _workshopTaglineFocus,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  hintText: "Street Address",
                                ).marginOnly(top: 10),

                                CustomTextField(
                                  controller: _cityStateZipController,
                                  focusNode: _cityStateZipFocus,
                                  //nextNode: _workshopTaglineFocus,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  hintText: "City, State, Zip Code",
                                ).marginOnly(top: 10),

                                Text(
                                  "Add an optional link",
                                  style: customTextFieldTitle,
                                ).marginOnly(top: 10),

                                CustomTextField(
                                  controller: _optionalLinkController,
                                  focusNode: _optionalLinkFocus,
                                  //nextNode: _workshopTaglineFocus,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  hintText: "E.g. https://www.eventbrite.com/events...",
                                ).marginOnly(top: 10),

                              ],
                            ).visible(eventOnlineOrOffline == "Local"),


                            Visibility(
                              visible: isEventOnline,
                              child:
                              Container(
                              padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: ColorResources.ZOOM_BUTTON_COLOR,
                                  borderRadius: BorderRadius.all( Radius.circular(10)),
                                  /*boxShadow: [
                                    BoxShadow(color: ColorResources.ZOOM_BUTTON_COLOR, spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                                  ],*/
                                ),
                              child: Row(
                                children: [
                                  Image.asset(Images.icon_zoom_meeting_btn , width: 37, height: 37, ),
                                  SizedBox(width: 70,),
                                  Text("Zoom Meetings", style: poppinsRegular.copyWith(color: Colors.white, fontSize: 16),)
                                ],
                              ),
                            ),
                            ).marginOnly(bottom: 16),

                            SizedBox(height : 16 ),


                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            CustomButton(
                                onTap: () {
                                  _createEvent();
                                  //Navigator.push(context, MaterialPageRoute(builder: (_) => CreateWorkshop2Screen()));
                                },
                                buttonText: getTranslated('NEXT', context)),
                          ]))));
        },
      ),
    );
  }

  _buildChoiceList() {
    weekDays.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              //widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
  }
}
