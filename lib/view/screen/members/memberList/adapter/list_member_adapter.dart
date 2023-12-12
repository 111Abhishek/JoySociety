import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';

class ListMemberAdapter {
  List? items = <MemberModel>[];
  List itemsTile = <ItemTile>[];

  ListMemberAdapter(this.items, onItemClick) {
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
  final MemberModel object;
  final int index;
  final Function onClick;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.onClick,
  }) : super(key: key);

  void onItemClick(MemberModel obj) {
    onClick(index, obj);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick(object);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        child: CircleAvatar(
                          backgroundImage: AssetImage(object.background_image),
                        ),
                        width: 40,
                        height: 40),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            object.name!,
                            style: poppinsRegular.copyWith(
                                fontSize: 12, color: ColorResources.GREEN),
                          ),
                          Text(
                            object.name!,
                            style: poppinsRegular.copyWith(
                                fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            object.name!,
                            style: poppinsRegular.copyWith(
                                fontSize: 12,
                                color: ColorResources.TEXT_FORM_TEXT_COLOR),
                          ),
                        ],
                      ),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: ColorResources.DARK_GREEN_COLOR)),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated('FOLLOW', context),
                                      style: poppinsRegular.copyWith(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Image.asset(
                              Images.icon_menu,
                              height: 24,
                              width: 24,
                            ),
                          )
                        ]),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
