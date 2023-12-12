import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/data/model/response/success_evaluation_report_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';

class ListGoalReflection2Adapter {
  List? items = <CommonListData>[];
  List itemsTile = <ItemTile>[];

  ListGoalReflection2Adapter(this.items, onItemClick) {
    for (var i = 0; i < items!.length; i++) {
      itemsTile
          .add(ItemTile(index: i, object: items![i], onClick: onItemClick));
    }
  }

  Widget getView() {
    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => itemsTile[index],
        itemCount: itemsTile.length,
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemTile extends StatelessWidget {
  final CommonListData object;
  final int index;
  final Function onClick;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.onClick,
  }) : super(key: key);

  void onItemClick(CommonListData obj) {
    onClick(index, obj);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick(object);
      },
      child: Container(
        margin: EdgeInsets.only(top: Dimensions.MARGIN_SIZE_LARGE),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [

                    CustomButtonSecondary(
                      buttonText: object.name ?? "",
                      borderColor: Theme.of(context).primaryColor,
                      bgColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      textStyle: poppinsRegular,
                      fontSize: 16,
                      isCapital: false,
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
