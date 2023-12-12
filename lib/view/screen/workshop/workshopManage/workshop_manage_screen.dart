import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop1/create_workshop1_screen.dart';

import 'package:joy_society/view/screen/workshop/reorderWorkshop/reorder_workshop_screen.dart';

class WorkshopManageScreen extends StatefulWidget {
  const WorkshopManageScreen({Key? key}) : super(key: key);

  @override
  State<WorkshopManageScreen> createState() => _WorkshopManageScreenState();
}

class _WorkshopManageScreenState extends State<WorkshopManageScreen> {
  String initValue = 'All Workshop';
  var itemList = [
    'All Workshop',
    'Class',
    'Course',
    'Seminar',
    'Workshop',
    'Add a Custom Name'
  ];

  final FocusNode _singularNameFocus = FocusNode();
  final FocusNode _articleNameFocus = FocusNode();
  final FocusNode _pluralNameFocus = FocusNode();
  final FocusNode _possessivePluralNameFocus = FocusNode();

  final TextEditingController _singularNameController = TextEditingController();
  final TextEditingController _articleNameController = TextEditingController();
  final TextEditingController _pluralNameController = TextEditingController();
  final TextEditingController _possessivePluralNameController =
      TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, "Courses (Workshop)"),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslated("what_do_you_want_your_courses_to_be", context),
                style: poppinsBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    color: ColorResources.TEXT_BLACK_COLOR),
              ),
              Text(
                getTranslated("manage_workspace_desc", context),
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: ColorResources.TEXT_BLACK_COLOR),
              ),
              Container(
                margin: EdgeInsets.only(top: Dimensions.MARGIN_SIZE_LARGE),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.MARGIN_SIZE_DEFAULT, vertical: 4),
                width: MediaQuery.of(context).size.width,
                decoration: baseWhiteBoxDecoration(context),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      isExpanded: true,
                      value: initValue,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
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
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.MARGIN_SIZE_LARGE,
                    vertical: Dimensions.MARGIN_SIZE_DEFAULT),
                decoration: baseWhiteBoxDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getTranslated('SINGULAR_NAME', context),
                        style: customTextFieldTitle),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    Text(getTranslated('singular_name_desc', context),
                        style: poppinsRegular.copyWith(
                            color: ColorResources.TEXT_BLACK_COLOR,
                            fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    CustomTextField(
                      textInputType: TextInputType.text,
                      focusNode: _singularNameFocus,
                      nextNode: _articleNameFocus,
                      controller: _singularNameController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                    Text(getTranslated('INDEFINITE_ARTICLE_NAME', context),
                        style: customTextFieldTitle),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    Text(getTranslated('indefinite_article_name_desc', context),
                        style: poppinsRegular.copyWith(
                            color: ColorResources.TEXT_BLACK_COLOR,
                            fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    CustomTextField(
                      textInputType: TextInputType.text,
                      focusNode: _articleNameFocus,
                      nextNode: _pluralNameFocus,
                      controller: _articleNameController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                    Text(getTranslated('PLURAL_NAME', context),
                        style: customTextFieldTitle),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    Text(getTranslated('plural_name_desc', context),
                        style: poppinsRegular.copyWith(
                            color: ColorResources.TEXT_BLACK_COLOR,
                            fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    CustomTextField(
                      textInputType: TextInputType.text,
                      focusNode: _pluralNameFocus,
                      nextNode: _possessivePluralNameFocus,
                      controller: _pluralNameController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                    Text(getTranslated('POSSESSIVE_PLURAL_NAME', context),
                        style: customTextFieldTitle),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    Text(getTranslated('possessive_plural_name_desc', context),
                        style: poppinsRegular.copyWith(
                            color: ColorResources.TEXT_BLACK_COLOR,
                            fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    CustomTextField(
                      textInputType: TextInputType.text,
                      focusNode: _possessivePluralNameFocus,
                      controller: _possessivePluralNameController,
                    ),
                    /*fSizedBox(
                      height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                    ),
                    CustomButton(
                          onTap: () {},
                          buttonText:
                          getTranslated('SAVE', context),),*/
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
              ),
              CustomButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReorderWorkshopScreen()));
                  },
                  buttonText: getTranslated('REORDER_WORKSHOP_LIST', context)),
              SizedBox(
                height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
              ),
              CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonText: getTranslated('VIEW_WORKSHOP_LIST', context)),
              SizedBox(
                height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
              ),
              CustomButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CreateWorkshop1Screen()));
                  },
                  buttonText: getTranslated('CREATE_A_WORKSHOP', context)),
            ],
          ),
        )));
  }
}
