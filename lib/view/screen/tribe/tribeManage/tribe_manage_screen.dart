


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/screen/tribe/createTribe/create_tribe_screen.dart';
import 'package:joy_society/view/screen/tribe/reorderTribes/reorder_tribes_screen.dart';
import 'package:joy_society/view/screen/tribe/tribe_list_screen.dart';

class TribeManageScreen extends StatefulWidget {
  const TribeManageScreen({Key? key}) : super(key: key);

  @override
  State<TribeManageScreen> createState() => _TribeManageScreenState();
}

class _TribeManageScreenState extends State<TribeManageScreen> {

  String initValue = 'Group';
  var itemList = ['Group', 'Team', 'Chapter', 'Region', 'Circle', 'Section',
    'Committee', 'Space', 'Tribe', 'Channel' , 'Cohort', 'Add a Custom Name…'];

  final FocusNode _singularNameFocus = FocusNode();
  final FocusNode _articleNameFocus = FocusNode();
  final FocusNode _pluralNameFocus = FocusNode();
  final FocusNode _possessivePluralNameFocus = FocusNode();

  final TextEditingController _singularNameController = TextEditingController();
  final TextEditingController _articleNameController = TextEditingController();
  final TextEditingController _pluralNameController = TextEditingController();
  final TextEditingController _possessivePluralNameController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Manage Tribes"),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getTranslated("what_do_you_want_your_groups_to_be", context),
                style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                color: ColorResources.TEXT_BLACK_COLOR),
                ),
                Text(getTranslated("manage_tribes_desc", context),
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
                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,),
                CustomButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ReorderTribesScreen()));
                    },
                    buttonText:
                    getTranslated('REORDER_TRIBES_LIST', context)),
                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,),
                CustomButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TribeListScreen()));
                    },
                    buttonText:
                    getTranslated('VIEW_TRIBES_LIST', context)),
                SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,),
                CustomButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CreateTribeScreen()));
                    },
                    buttonText:
                    getTranslated('CREATE_A_TRIBE', context)),
              ],
            ),
          )
        )
    );
  }

}