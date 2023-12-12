


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop1/create_workshop1_screen.dart';
import 'package:joy_society/view/screen/workshop/reorderWorkshop/reorder_workshop_screen.dart';
import 'package:provider/provider.dart';

class CreateWorkshop3Screen extends StatefulWidget {
  const CreateWorkshop3Screen({Key? key}) : super(key: key);

  @override
  State<CreateWorkshop3Screen> createState() => _CreateWorkshop3ScreenState();
}

class _CreateWorkshop3ScreenState extends State<CreateWorkshop3Screen> {

  String initValue = 'Instructor';
  var itemList = ['Instructor', 'Professor', 'TA', 'Teacher', 'Add a Custom Name'];

  final FocusNode _singularNameFocus = FocusNode();
  final FocusNode _articleNameFocus = FocusNode();
  final FocusNode _pluralNameFocus = FocusNode();
  final FocusNode _possessivePluralNameFocus = FocusNode();

  final TextEditingController _singularNameController = TextEditingController();
  final TextEditingController _articleNameController = TextEditingController();
  final TextEditingController _pluralNameController = TextEditingController();
  final TextEditingController _possessivePluralNameController = TextEditingController();

  void _updateWorkshopData() async {
    CreateWorkshopModel? workshopModel = Provider.of<WorkshopProvider>(context, listen: false).createWorkshopModel;

    if(workshopModel != null) {
      CreateWorkshopModel requestModel = CreateWorkshopModel(
          order : 1,
          title : workshopModel.title,
          tagline : workshopModel.tagline,
          description : workshopModel.description,
          privacy : workshopModel.privacy,
          table_of_content : workshopModel.table_of_content,
          lessons : workshopModel.lessons,
          sections : workshopModel.sections,
          instructors : initValue
      );

      if(requestModel != null) {
        await Provider.of<WorkshopProvider>(context, listen: false)
            .createWorkshop(requestModel, updateForumCallback);
      }
    }

  }

  updateForumCallback(
      bool isStatusSuccess,
      CreateWorkshopModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Workshop Created successfully'),
          backgroundColor: Colors.green));
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 4);
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Create a Workshop"),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getTranslated("INSTRUCTORS", context),
                style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                color: ColorResources.TEXT_BLACK_COLOR),
                ),
                Text(getTranslated("workshop_step_3_subtitle", context),
                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                color: ColorResources.TEXT_BLACK_COLOR),
                ),

                Container(
                  margin: EdgeInsets.only(top: Dimensions.MARGIN_SIZE_LARGE),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                      vertical: 4),
                  width: MediaQuery.of(context).size.width,
                  decoration: baseWhiteBoxDecoration(context),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        isExpanded: true,
                        value: initValue,
                        icon: const Icon(Icons
                            .keyboard_arrow_down_outlined),
                        items: itemList.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: Text(items));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            initValue = newValue!;
                          });
                        }),
                  ),
                ),
                SizedBox(height: 25,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_LARGE,
                  vertical: Dimensions.MARGIN_SIZE_DEFAULT),
                  decoration: baseWhiteBoxDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          getTranslated(
                              'SINGULAR_NAME', context),
                          style: customTextFieldTitle),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      Text(
                          'For uses like “Lesson $initValue” or “$initValue: John Smith”',
                          style: poppinsRegular.copyWith(color: ColorResources.TEXT_BLACK_COLOR,
                          fontSize: Dimensions.FONT_SIZE_SMALL)),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      CustomTextField(
                        textInputType: TextInputType.text,
                        focusNode: _singularNameFocus,
                        nextNode: _articleNameFocus,
                        controller: _singularNameController,
                      ),

                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                      Text(
                          getTranslated(
                              'INDEFINITE_ARTICLE_NAME', context),
                          style: customTextFieldTitle),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      Text(
                          "For uses like “an $initValue Sent You a Message”",
                          style: poppinsRegular.copyWith(color: ColorResources.TEXT_BLACK_COLOR,
                          fontSize: Dimensions.FONT_SIZE_SMALL)),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      CustomTextField(
                        textInputType: TextInputType.text,
                        focusNode: _articleNameFocus,
                        nextNode: _pluralNameFocus,
                        controller: _articleNameController,
                      ),

                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                      Text(
                          getTranslated(
                              'PLURAL_NAME', context),
                          style: customTextFieldTitle),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      Text(
                          "For uses like “9 $initValue”",
                          style: poppinsRegular.copyWith(color: ColorResources.TEXT_BLACK_COLOR,
                          fontSize: Dimensions.FONT_SIZE_SMALL)),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      CustomTextField(
                        textInputType: TextInputType.text,
                        focusNode: _pluralNameFocus,
                        nextNode: _possessivePluralNameFocus,
                        controller: _pluralNameController,
                      ),

                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                      Text(
                          getTranslated(
                              'POSSESSIVE_PLURAL_NAME', context),
                          style: customTextFieldTitle),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      Text(
                          "For uses like “Meet Your $initValue”",
                          style: poppinsRegular.copyWith(color: ColorResources.TEXT_BLACK_COLOR,
                          fontSize: Dimensions.FONT_SIZE_SMALL)),
                      SizedBox(
                          height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      CustomTextField(
                        textInputType: TextInputType.text,
                        focusNode: _possessivePluralNameFocus,
                        controller: _possessivePluralNameController,
                      ),
                      SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,),
                CustomButton(
                    onTap: () {
                      _updateWorkshopData();
                    },
                    buttonText:
                    getTranslated('FINISH', context)),
                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,),
              ],
            ),
          )
        )
    );
  }

}