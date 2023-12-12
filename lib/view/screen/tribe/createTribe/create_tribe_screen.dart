import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop2/create_workshop2_screen.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class CreateTribeScreen extends StatefulWidget {

  const CreateTribeScreen({Key? key})
      : super(key: key);

  @override
  State<CreateTribeScreen> createState() => _CreateTribeScreenState();
}

class _CreateTribeScreenState extends State<CreateTribeScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  String initValue = 'Secret';
  var itemList = ['Public', 'Private', 'Secret'];

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _taglineFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  void _updateGoalReflection() async {
    TribeModel requestModel = TribeModel(
        order : 1,
        title : _titleController.text.trim(),
        tagline : _taglineController.text.trim(),
        description : _descController.text.trim(),
        privacy : initValue
        );

    Provider.of<TribeProvider>(context, listen: false)
        .createTribe(requestModel, updateForumCallback);
  }

  updateForumCallback(
      bool isStatusSuccess,
      TribeModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Tribe Created successfully'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<TribeProvider>(
        builder: (context, goal, child) {

          //  _emailController.text = profile.userPhoneEmailModel?.email ?? "";
          return Scaffold(
              appBar:
                  appBar(context, getTranslated('CREATE_A_TRIBE', context)),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(getTranslated('the_big_stuff', context),
                                style: poppinsBold.copyWith(
                                    fontSize:
                                        Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            Text(
                                getTranslated(
                                    'adjust_basic_info_about', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            Text(
                                getTranslated(
                                    'TRIBE_TITLE', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _titleController,
                              focusNode: _titleFocus,
                              nextNode: _taglineFocus,
                              textInputAction: TextInputAction.next,
                              hintText: getTranslated('hint_workshop_title', context),
                            ),


                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),
                            Text(
                                getTranslated(
                                    'TRIBE_TAGLINE', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _taglineController,
                              focusNode: _taglineFocus,
                              nextNode: _descFocus,
                              textInputAction: TextInputAction.next,
                              hintText: getTranslated('hint_workshop_tagline', context),
                              maxLine: 3,
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                            Text(
                                getTranslated(
                                    'TRIBE_DESCRIPTION', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                            CustomTextField(
                              controller: _descController,
                              focusNode: _descFocus,
                              textInputAction: TextInputAction.next,
                              hintText: getTranslated('hint_workshop_desc', context),
                              maxLine: 8,
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                            Text(getTranslated('PRIVACY_AND_INVITES', context),
                                style: poppinsBold.copyWith(
                                    fontSize:
                                    Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            Text(
                                getTranslated(
                                    'tribe_privacy_and_invites_desc', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                            Text(getTranslated('privacy', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
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
                                    value: initValue,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                    items: itemList.map((String items) {
                                      return DropdownMenuItem(
                                          value: items, child: Text(items));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        initValue = newValue!;
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            CustomButton(
                                onTap: () {
                                  _updateGoalReflection();
                                  //Navigator.push(context, MaterialPageRoute(builder: (_) => CreateWorkshop2Screen()));
                                },
                                buttonText: getTranslated('CREATE_A_TRIBE', context)),
                          ]))));
        },
      ),
    );
  }
}
