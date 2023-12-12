import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/topic/editTopic/edit_topics_screen.dart';
import 'package:joy_society/view/screen/workshop/reorderWorkshop/adapter/reorder_workshop_draggable_adapter.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';

class ReorderWorkshopScreen extends StatefulWidget {

  @override
  _ReorderWorkshopScreenState createState() => _ReorderWorkshopScreenState();
  /*@override
  State<ReorderWorkshopScreen> createState() => _ReorderWorkshopScreenState();*/
}

class _ReorderWorkshopScreenState extends State<ReorderWorkshopScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();


  void onReorder() {
    setState(() {});
  }

  _getTopicsList() async {
    await Provider.of<WorkshopProvider>(context, listen: false)
        .getWorkshopList(1, "", AppConstants.WORKSHOP)
        .then((value) {
      if (value != null) {
        /*_firstNameController.text = value.fullName ?? "";
        _miniBioController.text = value.miniBio ?? "";
        _personalLinkController.text = value.personalLinks?[0] ?? "";
        if(value.location != null){
          locationData = value.location;
        }
        if(value.timezone != null){
          timezoneData = value.timezone;
        }*/
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //items = getPeopleData();
    _getTopicsList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<WorkshopProvider>(builder: (context, topic, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 48, left: 8),
              child: Row(children: [
                CupertinoNavigationBarBackButton(
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Image.asset(Images.logo_with_name_image, height: 40, width: 40),
                const SizedBox(width: 10),
                Text(getTranslated('REORDER_WORKSHOP_LIST', context),
                    style: poppinsBold.copyWith(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: topic.isLoading ? Loader().visible(topic.isLoading) :
              ReorderWorkshopDraggableAdapter(topic.workshopListResponse.data, onReorder).getView(),
            )
          ],
        );
      }),
    );
  }
}
