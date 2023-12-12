import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/data/model/response/success_evaluation_report_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';

class ListGoalReflection1Adapter {
  List? items = <SuccessEvaluationReportModel>[];
  List itemsTile = <ItemTile>[];

  ListGoalReflection1Adapter(this.items, onItemClick) {
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
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemTile extends StatelessWidget {
  final SuccessEvaluationReportModel object;
  final int index;
  final Function onClick;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.onClick,
  }) : super(key: key);

  void onItemClick(SuccessEvaluationReportModel obj) {
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
                flex: 5,
                child: Text(object.label ?? "", style: poppinsRegular.copyWith(fontSize: 16, color: Colors.black)),
              ),
              SizedBox(width: 16,),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 27, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(object.score.toString() ?? "0", style: poppinsRegular.copyWith(fontSize: 15, color: Colors.black)),
                ),
              ),
              SizedBox(width: 26,),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 27, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(object.scorePart2.toString() ?? "0", style: poppinsRegular.copyWith(fontSize: 15, color: Colors.black)),
                ),
              ),
            ]),
      ),
    );
  }
}
