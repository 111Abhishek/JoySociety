import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/create_event_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/screen/event/createEvent2/create_event2_screen.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop2/create_workshop2_screen.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class CreateEvent1Screen extends StatefulWidget {

  const CreateEvent1Screen({Key? key})
      : super(key: key);

  @override
  State<CreateEvent1Screen> createState() => _CreateEvent1ScreenState();
}

class _CreateEvent1ScreenState extends State<CreateEvent1Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  DateTime? selectedStartDate;
  String? startDate;
  TimeOfDay selectedStartTime = TimeOfDay.now();
  String? startTime;

  DateTime? selectedEndDate;
  String? endDate;
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String? endTime;

  String initValue = 'Secret';
  var itemList = ['Secret', 'Privacy 2', 'Privacy 3', 'Privacy 4'];

  final FocusNode _eventTitleFocus = FocusNode();

  final TextEditingController _eventTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStartDate = DateTime.now();
    selectedEndDate = DateTime.now();
  }

  void _updateCreateEvent() async {

    String title = _eventTitleController.text.toString();
    if(title.isEmpty) {
      final snackBar = SnackBar(content: Text("Event Title cannot be empty"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if(startDate == null) {
      final snackBar = SnackBar(content: Text("Please select start date"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if(startTime == null) {
      final snackBar = SnackBar(content: Text("Please select start time"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if(endDate == null) {
      final snackBar = SnackBar(content: Text("Please select end date"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if(endTime == null) {
      final snackBar = SnackBar(content: Text("Please select end time"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    //"$hour:$minute;
    CreateEventModel requestModel = CreateEventModel(
        title : title,
        start_datetime : (startDate ?? "") + "T" + (startTime ?? "") +":00.000+05:30",
        end_datetime : (endDate ?? "") + "T" + (endTime ?? "") +":00.000+05:30",
    );
    Provider.of<EventProvider>(context, listen: false).addCreateEventTitleAndTime(requestModel);
    Navigator.push(context, MaterialPageRoute(builder: (_) => CreateEvent2Screen()));
  }

  void _addStartCalendar(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        startDate = getFormattedDate(picked);
        var date = "${picked.year}-${picked.month}-${picked.day}";
        Provider.of<EventProvider>(context, listen: false).startDate = date;
        //showCustomSnackBar(date, context, isError: false);
      });
    }
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
        startTime = getFormattedTime(picked);
        //Provider.of<EventProvider>(context, listen: false).startTime = getFormattedTime(picked);
      });
    }
  }

  String getFormattedTime(TimeOfDay picked) {
    var hour = picked.hour.toString();
    if(picked.hour < 10){
      hour = "0${picked.hour}";
    }
    var minute = picked.minute.toString();
    if(picked.minute < 10){
      minute = "0${picked.minute}";
    }
    return "$hour:$minute";
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

  void _addEndCalendar(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        endDate = getFormattedDate(picked);
        var date = "${picked.year}-${picked.month}-${picked.day}";
        Provider.of<EventProvider>(context, listen: false).endDate = date;
        //showCustomSnackBar(date, context, isError: false);
      });
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedEndTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
        endTime = getFormattedTime(picked);
        //Provider.of<EventProvider>(context, listen: false).endTime = getFormattedTime(picked);
      });
    }
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

                            Text(
                                getTranslated(
                                    'EVENT_TITLE', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _eventTitleController,
                              focusNode: _eventTitleFocus,
                              textInputAction: TextInputAction.next,
                              hintText: getTranslated('ADD_A_TITLE', context),
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            Text(
                              "Start Date & Time",
                              style: customTextFieldTitle),

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
                                          child: Text(Provider.of<EventProvider>(context, listen: false).startDate,
                                              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                              color: ColorResources.TEXT_FORM_TEXT_COLOR),overflow: TextOverflow.ellipsis,),
                                        ),
                                        Icon(Icons.keyboard_arrow_down_outlined),
                                      ],
                                    ),
                                  ).onTap(() {
                                    _addStartCalendar(context);
                                  }),
                                ),
                                SizedBox(width: 16,),
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
                                            child: Text(startTime ?? "00:00",
                                              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                                  color: ColorResources.TEXT_FORM_TEXT_COLOR),overflow: TextOverflow.ellipsis,),
                                          ),
                                          Icon(Icons.keyboard_arrow_down_outlined),
                                        ],
                                      ),
                                    ).onTap(() {
                                      _selectStartTime(context);
                                    }),
                                ),
                              ],
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            Text(
                              "End Date & Time",
                              style: customTextFieldTitle),

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
                                          child: Text(Provider.of<EventProvider>(context, listen: false).endDate,
                                              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                              color: ColorResources.TEXT_FORM_TEXT_COLOR),overflow: TextOverflow.ellipsis,),
                                        ),
                                        Icon(Icons.keyboard_arrow_down_outlined),
                                      ],
                                    ),
                                  ).onTap(() {
                                    _addEndCalendar(context);
                                  }),
                                ),
                                SizedBox(width: 16,),
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
                                            child: Text(endTime ?? "00:00",
                                              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                                  color: ColorResources.TEXT_FORM_TEXT_COLOR),overflow: TextOverflow.ellipsis,),
                                          ),
                                          Icon(Icons.keyboard_arrow_down_outlined),
                                        ],
                                      ),
                                    ).onTap(() {
                                      _selectEndTime(context);
                                    }),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            CustomButton(
                                onTap: () {
                                  _updateCreateEvent();
                                },
                                buttonText: getTranslated('NEXT', context)),
                          ]))));
        },
      ),
    );
  }
}
