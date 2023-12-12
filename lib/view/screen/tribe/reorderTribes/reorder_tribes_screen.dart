import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/tribe/reorderTribes/adapter/reorder_tribes_draggable_adapter.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';

class ReorderTribesScreen extends StatefulWidget {

  @override
  _ReorderTribesScreenState createState() => _ReorderTribesScreenState();
  /*@override
  State<ReorderTribesScreen> createState() => _ReorderTribesScreenState();*/
}

class _ReorderTribesScreenState extends State<ReorderTribesScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();


  void onReorder() async {
    setState(() {});
    List<TribeModel>? list = Provider.of<TribeProvider>(context, listen: false).tribeListResponse.data;
    if(list != null) {
      List<Map<String, dynamic>> request = <Map<String, dynamic>>[];
      list.forEach((element) {
        Map<String, dynamic> tribe = {
          "id": element.id,
          "order": element.order,
        };
        request.add(tribe);
      });
      await Provider.of<TribeProvider>(context, listen: false)
          .reorderTribes(request, _onReorderResponse);
    }
  }

  _onReorderResponse(bool isStatusSuccess, ErrorResponse? errorResponse) async {
    isStatusSuccess;
  }

  _getTribeList() async {
    await Provider.of<TribeProvider>(context, listen: false)
        .getTribeList(1, "", AppConstants.TRIBE)
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
    _getTribeList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<TribeProvider>(builder: (context, topic, child) {
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
                Text(getTranslated('REORDER_TRIBES_LIST', context),
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
              ReorderTribesDraggableAdapter(topic.tribeListResponse.data, onReorder).getView(),
            )
          ],
        );
      }),
    );
  }
}
