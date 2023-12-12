import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/topic_delete_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/topic/editTopic/edit_topics_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/response/base/error_response.dart';
import '../../../../basewidget/button/custom_button.dart';

class TopicListDraggableAdapter {
  List? items = <TopicModel>[];
  Function onReorder;

  TopicListDraggableAdapter(this.items, this.onReorder);

  Widget getView() {
    return ReorderableListView(
      onReorder: _onReorder,
      scrollDirection: Axis.vertical,
      children: List.generate(
        this.items!.length,
        (index) {
          return ItemTile(Key('$index'), index, this.items![index]);
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final TopicModel item = this.items!.removeAt(oldIndex);
    this.items!.insert(newIndex, item);
    this.onReorder();
  }
}

 _deleteTopic(BuildContext context, int? id) async {
  if(id != null) {
    await Provider.of<TopicProvider>(context, listen: false)
        .deleteTopic(context, id, deleteCallback);

  }
}

TopicDeleteModel getTopicInfo(String? name) {
  TopicDeleteModel topicDeleteModel = TopicDeleteModel();
  topicDeleteModel.name = name;
  return topicDeleteModel;
}

deleteCallback(BuildContext context,bool isStatusSuccess,
    TopicModel? topicDeleteModel, ErrorResponse? errorResponse) async {
  if (isStatusSuccess) {

  }
  /*if (isStatusSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Topic delete successfully'),
        backgroundColor: Colors.green));
    Navigator.pop(context);
  } else {
    String? errorDescription = errorResponse?.errorDescription;
    if (errorResponse?.non_field_errors != null) {
      errorDescription = errorResponse?.non_field_errors![0];
    } else {
      if (errorDescription == null) {
        dynamic topicNameError = errorResponse?.errorJson["name"];
        if (topicNameError != null && topicNameError.length > 0) {
          errorDescription = topicNameError![0]!;
        } else {
          errorDescription = 'Technical error, Please try again later!';
        }
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorDescription!), backgroundColor: Colors.red));
  }*/
  Navigator.pop(context);
}

// ignore: must_be_immutable
class ItemTile extends StatelessWidget {
  final TopicModel object;
  final int index;
  final Key key;

  const ItemTile(this.key, this.index, this.object);

  @override
  Widget build(BuildContext context) {
    AlertDialog deleteDialog = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        padding: EdgeInsets.only(left: 8, top: 10, right: 8, bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(Images.icon_close, height: 60, width: 60),
                    Text(
                      getTranslated('ALERT_DELETE', context),
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      getTranslated('ALERT_DELETE_MESSAGE', context),
                      style: poppinsRegular.copyWith(
                          fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: !Provider.of<TopicProvider>(context)
                                      .isLoading
                                  ? CustomButton(
                                      onTap: () {
                                        _deleteTopic(context, object.id);
                                        Navigator.pop(context);
                                      },
                                      buttonText: getTranslated('YES', context))
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor))),
                            ),
                          ],
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: !Provider.of<TopicProvider>(context)
                                      .isLoading
                                  ? CustomButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      buttonText: getTranslated('NO', context))
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor))),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(0),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          style: poppinsBold.copyWith(
                              fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          object.description!,
                          style: poppinsRegular.copyWith(
                              fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(color: ColorResources.NAVIGATION_DIVIDER_COLOR),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: ColorResources.DARK_GREEN_COLOR)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor:
                                    ColorResources.DARK_GREEN_COLOR,
                                radius: 14,
                                child: IconButton(
                                  onPressed: () {},
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.add,
                                      color: ColorResources.WHITE, size: 18),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              getTranslated('ADD_THIS', context),
                              style: poppinsRegular.copyWith(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                          backgroundColor: ColorResources.WHITE,
                          radius: 15,
                          child: Image.asset(Images.icon_share)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => EditTopicScreen(topicModel: object)));
                      },
                      child: CircleAvatar(
                          backgroundColor: ColorResources.WHITE,
                          radius: 15,
                          child: Image.asset(Images.icon_edit)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return deleteDialog;
                          },
                        );
                      },
                      child: CircleAvatar(
                          backgroundColor: ColorResources.WHITE,
                          radius: 15,
                          child: Image.asset(Images.icon_delete)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

/*static void showToastClicked(BuildContext context, String action){
    print(action);
    MyToast.show(action+" clicked", context);
  }*/

  _onEditClick(BuildContext context, TopicModel? topic) async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => EditTopicScreen(topicModel: topic)));
  }
}
