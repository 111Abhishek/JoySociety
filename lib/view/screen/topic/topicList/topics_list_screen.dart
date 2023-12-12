import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/topic/editTopic/edit_topics_screen.dart';
import 'package:joy_society/view/screen/topic/topicList/adapter/topic_list_draggable_adapter.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';

class TopicsListScreen extends StatefulWidget {

  @override
  _TopicsListScreenState createState() => _TopicsListScreenState();
  /*@override
  State<TopicsListScreen> createState() => _TopicsListScreenState();*/
}

class _TopicsListScreenState extends State<TopicsListScreen> {
  //late BuildContext context;

  //List<TopicModel>? items;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _onContentClick() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => EditTopicScreen()));
  }

  void onReorder() {
    setState(() {});
  }

  _getTopicsList() async {
    await Provider.of<TopicProvider>(context, listen: false)
        .getTopicsList()
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
      body: Consumer<TopicProvider>(builder: (context, topic, child) {
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
                Text(getTranslated('TOPICS', context),
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
              TopicListDraggableAdapter(topic.topicResponse.data, onReorder).getView(),
            )
          ],
        );
      }),
    );
  }
}
