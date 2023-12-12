
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/create_plan_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/plan_provider.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/screen/plans/createPlan/create_plan2_screen.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop2/create_workshop2_screen.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class CreatePlan1Screen extends StatefulWidget {

  const CreatePlan1Screen({Key? key})
      : super(key: key);

  @override
  State<CreatePlan1Screen> createState() => _CreatePlan1ScreenState();
}

class _CreatePlan1ScreenState extends State<CreatePlan1Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  File? file = null;
  final picker = ImagePicker();

  final FocusNode _planNameFocus = FocusNode();
  final FocusNode _internalNoteFocus = FocusNode();
  final FocusNode _salesPitchFocus = FocusNode();
  final FocusNode _benefitListFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _internalNoteController = TextEditingController();
  final TextEditingController _salesPitchController = TextEditingController();
  final TextEditingController _benefitListController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  void _updateGoalReflection() async {
    if (_planNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Plan Name cannot be Empty"),
          backgroundColor: Colors.red));
      return;
    } else if (_internalNoteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Internal Note cannot be Empty"),
          backgroundColor: Colors.red));
      return;
    } else if (_salesPitchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sales Pitch cannot be Empty"),
          backgroundColor: Colors.red));
      return;
    } else if (_benefitListController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Benefits cannot be Empty"),
          backgroundColor: Colors.red));
      return;
    } else if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Description cannot be Empty"),
          backgroundColor: Colors.red));
      return;
    }
      //showCustomSnackBar("Plan Name cannot be Empty", context);


    CreatePlanModel requestModel = CreatePlanModel(
        name : _planNameController.text.trim(),
        internal_note : _internalNoteController.text.trim(),
        sales_pitch : _salesPitchController.text.trim(),
        description : _descController.text.trim(),
        benefits : _benefitListController.text.trim(),
        image : ""
        );

    Provider.of<PlanProvider>(context, listen: false)
        .updateCreatePlan1(requestModel, file);

    Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePlan2Screen()));

  }

  void _addPersonalLink() async {
    //showCustomSnackBar('Button Clicked', context, isError: false);
  }

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goal, child) {

          //  _emailController.text = profile.userPhoneEmailModel?.email ?? "";
          return Scaffold(
              appBar:
                  appBar(context, getTranslated('CREATE_A_NEW_PLAN', context)),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fill in the Details',
                                style: poppinsBold.copyWith(
                                    fontSize:
                                        Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            Text(
                                'Choose to include Joy Society access, premium Tribes and/or Workshops access in this plan.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            Text(
                                'Plan Name',
                                style: customTextFieldTitle),
                            Text(
                                'This will be the plan name existing members see.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _planNameController,
                              focusNode: _planNameFocus,
                              nextNode: _internalNoteFocus,
                              textInputAction: TextInputAction.next,
                              hintText: getTranslated('hint_workshop_title', context),
                            ),


                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),
                            Text(
                                'Internal Note',
                                style: customTextFieldTitle),
                            Text(
                                'This note can only be seen by the Hosts. It’s helpful for differentiating plans.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _internalNoteController,
                              focusNode: _internalNoteFocus,
                              nextNode: _salesPitchFocus,
                              textInputAction: TextInputAction.next,
                              hintText: 'e.g. Plans for member who joined in 2020',
                              maxLine: 1,
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            Container(
                              margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                              height: 190,
                              //color: ColorResources.DARK_GREEN_COLOR,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: ColorResources.DARK_GREEN_COLOR,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(Images.icon_placeholder_image,
                                    height: 66, width: 80,),
                                  SizedBox(height: 16,),
                                  Text(
                                    'Upload Image',
                                    style: poppinsBold.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Minimum 1600 x 900px',
                                    style: poppinsBold.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ).onTap(_choose),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),
                            Text(
                                'Sales Pitch',
                                style: customTextFieldTitle),
                            Text(
                                'A short tagline will appear with the plan name. Use it to explain why prospective members should buy this plan.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _salesPitchController,
                              focusNode: _salesPitchFocus,
                              nextNode: _benefitListFocus,
                              textInputAction: TextInputAction.next,
                              hintText: 'e.g. Join us to meet people like you and learn how to make better more well-informed decisions in your work',
                              maxLine: 3,
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),
                            Text(
                                'Benefits List',
                                style: customTextFieldTitle),
                            Text(
                                'Create a bulleted list of the benefits prospective members will receive when they choose this plan. We recommend adding at least three.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),

                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      textInputType: TextInputType.text,
                                      focusNode: _benefitListFocus,
                                      nextNode: _descFocus,
                                      hintText: 'e.g. Be the first to hear about special offers and annoucements',
                                      controller: _benefitListController,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.MARGIN_SIZE_DEFAULT,),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: ColorResources.DARK_GREEN_COLOR,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)) // changes position of shadow
                                      ],
                                    ),
                                    child:IconButton(
                                      onPressed: _addPersonalLink,
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(Icons.add,
                                          color: ColorResources.WHITE,
                                          size: 18),
                                      color: ColorResources.DARK_GREEN_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                            Text(
                                'Description',
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                            CustomTextField(
                              controller: _descController,
                              focusNode: _descFocus,
                              textInputAction: TextInputAction.done,
                              hintText: 'Write a custom description just for this plan.',
                              maxLine: 4,
                            ),


                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            CustomButton(
                                onTap: () {
                                  _updateGoalReflection();
                                },
                                buttonText: 'Next configure'),
                          ]))));
        },
      ),
    );
  }
}
