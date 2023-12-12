
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
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

class CreateWorkshop1Screen extends StatefulWidget {

  const CreateWorkshop1Screen({Key? key})
      : super(key: key);

  @override
  State<CreateWorkshop1Screen> createState() => _CreateWorkshop1ScreenState();
}

class _CreateWorkshop1ScreenState extends State<CreateWorkshop1Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  String initValue = 'Secret';
  var itemList = ['Secret', 'Privacy 2', 'Privacy 3', 'Privacy 4'];

  final FocusNode _workshopTitleFocus = FocusNode();
  final FocusNode _workshopTaglineFocus = FocusNode();
  final FocusNode _workshopDescFocus = FocusNode();

  final TextEditingController _workshopTitleController = TextEditingController();
  final TextEditingController _workshopTaglineController = TextEditingController();
  final TextEditingController _workshopDescController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  void _updateGoalReflection() async {
    CreateWorkshopModel requestModel = CreateWorkshopModel(
        order : 1,
        title : _workshopTitleController.text.trim(),
        tagline : _workshopTaglineController.text.trim(),
        description : _workshopDescController.text.trim(),
        privacy : initValue,
        table_of_content : "",
        lessons : "",
        sections : "",
        instructors : ""
        );

    Provider.of<WorkshopProvider>(context, listen: false)
        .saveWorkshopCreation1(requestModel);
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
                                    'WORKSHOP_TITLE', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _workshopTitleController,
                              focusNode: _workshopTitleFocus,
                              nextNode: _workshopTaglineFocus,
                              textInputAction: TextInputAction.next,
                              hintText: getTranslated('hint_workshop_title', context),
                            ),


                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),
                            Text(
                                getTranslated(
                                    'WORKSHOP_TAGLINE', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _workshopTaglineController,
                              focusNode: _workshopTaglineFocus,
                              nextNode: _workshopDescFocus,
                              textInputAction: TextInputAction.next,
                              hintText: getTranslated('hint_workshop_tagline', context),
                              maxLine: 3,
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                            Text(
                                getTranslated(
                                    'WORKSHOP_DESCRIPTION', context),
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                            CustomTextField(
                              controller: _workshopDescController,
                              focusNode: _workshopDescFocus,
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
                                    'privacy_and_invites_desc', context),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => CreateWorkshop2Screen()));
                                },
                                buttonText: getTranslated('NEXT', context)),
                          ]))));
        },
      ),
    );
  }
}
