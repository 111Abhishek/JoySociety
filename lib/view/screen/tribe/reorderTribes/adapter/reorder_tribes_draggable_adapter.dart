import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';

class ReorderTribesDraggableAdapter {
  List? items = <TribeModel>[];
  Function onReorder;

  ReorderTribesDraggableAdapter(this.items, this.onReorder);

  Widget getView() {
    return ReorderableListView(
      onReorder: _onReorder,
      scrollDirection: Axis.vertical,
      children: List.generate(
        this.items?.length ?? 0,
        (index) {
          return ItemTile(Key('$index'), index, this.items![index]);
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final TribeModel item = this.items!.removeAt(oldIndex);
    this.items!.insert(newIndex, item);
    this.onReorder();
  }
}


// ignore: must_be_immutable
class ItemTile extends StatelessWidget {
  final TribeModel object;
  final int index;
  final Key key;

  const ItemTile(this.key, this.index, this.object);

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
          decoration: baseWhiteBoxDecoration(context),
          child: Row(
            children: [
              Icon(Icons.menu, color: ColorResources.GRAY_BUTTON_BG_COLOR, ),
              SizedBox(width: 12,),
              Text(object.title ?? '', style: poppinsRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.TEXT_BLACK_COLOR),)
            ],
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

}
