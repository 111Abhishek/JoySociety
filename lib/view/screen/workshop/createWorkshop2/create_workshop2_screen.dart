import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/goal_reflection3_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/goals/reflection2/goal_reflection2_screen.dart';
import 'package:joy_society/view/screen/goals/reflection4/goal_reflection4_screen.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop3/create_workshop3_screen.dart';
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

class CreateWorkshop2Screen extends StatefulWidget {

  const CreateWorkshop2Screen({Key? key})
      : super(key: key);

  @override
  State<CreateWorkshop2Screen> createState() => _CreateWorkshop2ScreenState();
}

class _CreateWorkshop2ScreenState extends State<CreateWorkshop2Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  String tableOfContentsValue = 'Table of Content 1';
  var tableOfContentsList = ['Table of Content 1', 'Table of Content 2', 'PriTable of Content 3', 'Table of Content 4'];
  
  String lessonsValue = 'Lesson 1';
  var lessonsList = ['Lesson 1', 'Lesson 2', 'Lesson 3', 'Lesson 4'];

  String sectionValue = 'Section 1';
  var sectionsList = ['Section 1', 'Section 2', 'Section 3', 'Section 4'];

  @override
  void initState() {
    super.initState();

  }

  void _updateWorkshopData() async {
    CreateWorkshopModel? workshopModel = Provider.of<WorkshopProvider>(context, listen: false).createWorkshopModel;

    if(workshopModel != null) {
      CreateWorkshopModel requestModel = CreateWorkshopModel(
          order : 1,
          title : workshopModel.title,
          tagline : workshopModel.tagline,
          description : workshopModel.description,
          privacy : workshopModel.privacy,
          table_of_content : tableOfContentsValue,
          lessons : lessonsValue,
          sections : sectionValue,
          instructors : ""
      );

      Provider.of<WorkshopProvider>(context, listen: false)
          .saveWorkshopCreation1(requestModel);
    }

  }

  updateForumCallback(
      bool isStatusSuccess,
      GoalReflection3ModelModel? responseModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reflection updated successfully'),
          backgroundColor: Colors.green));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => GoalReflection4Screen()));
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

          //  _emailController.text = profile.userPhoneEmailModel?.email ?? "";
          return Scaffold(
              appBar:
                  appBar(context, getTranslated('CREATE_A_WORKSHOP', context)),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(getTranslated('workshop_structure', context),
                                style: poppinsBold.copyWith(
                                    fontSize:
                                        Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            Text(
                                getTranslated(
                                    'lets_setup_the_structure_of_your_workshop', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),


                            Text(getTranslated('TABLE_OF_CONTENTS', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            Text(
                                getTranslated(
                                    'table_of_contents_desc', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
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
                                    value: tableOfContentsValue,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                    items: tableOfContentsList.map((String items) {
                                      return DropdownMenuItem(
                                          value: items, child: Text(items));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        tableOfContentsValue = newValue!;
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),


                            Text(getTranslated('LESSONS', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            Text(
                                getTranslated(
                                    'lessons_desc_workshop', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
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
                                    value: lessonsValue,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                    items: lessonsList.map((String items) {
                                      return DropdownMenuItem(
                                          value: items, child: Text(items));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        lessonsValue = newValue!;
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),


                            Text(getTranslated('SECTIONS', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            Text(
                                getTranslated(
                                    'sections_desc_workshop', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
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
                                    value: sectionValue,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                    items: sectionsList.map((String items) {
                                      return DropdownMenuItem(
                                          value: items, child: Text(items));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        sectionValue = newValue!;
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(height: 44),

                            CustomButton(
                                onTap: () {
                                  _updateWorkshopData();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => CreateWorkshop3Screen()));
                                },
                                buttonText: getTranslated('NEXT', context)),
                          ]))));
        },
      ),
    );
  }
}
