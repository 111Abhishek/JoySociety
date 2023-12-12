import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/dashboard/dashboard_screen.dart';
import 'package:joy_society/view/screen/home/home_feed_screen.dart';
import 'package:joy_society/view/screen/topic/editTopic/edit_topics_screen.dart';
import 'package:joy_society/view/screen/topic/topicList/adapter/topic_list_draggable_adapter.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../../data/model/response/post_model.dart';
import '../../../../localization/language_constants.dart';
import '../../../../provider/home_controller.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';

class SelectTopic extends StatefulWidget {
  bool? didComeFromHomeScreen;

  SelectTopic({Key? key, this.didComeFromHomeScreen}) : super(key: key);

  @override
  _SelectTopicState createState() => _SelectTopicState();
/*@override
  State<TopicsListScreen> createState() => _TopicsListScreenState();*/
}

class _SelectTopicState extends State<SelectTopic> {
  //late BuildContext context;
  late bool didComeFromHomeScreen = false;

  //List<TopicModel>? items;
  final HomeController _homeController = Get.find();

  void onReorder() {
    setState(() {});
  }

  _getTopicsList() async {
    await Provider.of<TopicProvider>(context, listen: false).getTopicsList();
  }

  @override
  void initState() {
    super.initState();
    didComeFromHomeScreen = widget.didComeFromHomeScreen ?? false;
    //items = getPeopleData();
    _getTopicsList();
  }

  String processTopicName(String? topicName) {
    if (topicName != null) {
      List<String> tokens = topicName.split("well");
      tokens.insert(tokens.length - 1, "well");
      return tokens.join(" ").capitalize!;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TopicProvider>(builder: (context, topic, child) {
        return Column(
          children: [
            Container(
              padding: didComeFromHomeScreen
                  ? const EdgeInsets.only(top: 32, left: 8)
                  : const EdgeInsets.only(top: 48, left: 8),
              child: Row(children: [
                if (!didComeFromHomeScreen)
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.black,
                  ),
                const SizedBox(width: 10),
                Image.asset(Images.logo_with_name_image, height: 40, width: 40),
                const SizedBox(width: 10),
                Text(getTranslated('TOPICS', context),
                    style:
                        poppinsBold.copyWith(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: topic.isLoading
                    ? Loader().visible(topic.isLoading)
                    : ListView.builder(
                        itemBuilder: (ctx, index) {
                          String topicFullName = "";
                          if (topic.topicResponse.data != null) {
                            topicFullName =
                                topic.topicResponse.data![index].name ?? "";
                          }

                          String topicType = topicFullName
                              .replaceAll("wellbeing", "")
                              .trim()
                              .toLowerCase();

                          return GestureDetector(
                            onTap: () {
                              _homeController.postSearchQuery.topic =
                                  topic.topicResponse.data![index].name;
                              _homeController.posts = <PostModel>[].obs;
                              _homeController.isRefreshingPosts.value = true;
                              _homeController.postsCurrentPage = 1;
                              _homeController.getPosts(
                                  isRecent: true,
                                  topic: topic.topicResponse.data![index].name,
                                  callback: () {
                                    _homeController.update();
                                  });

                              if (didComeFromHomeScreen) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DashBoardScreen()));
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              height: 80,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0XFF34685F)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // FadeInImage(placeholder: placeholder, image: image)
                                  ClipOval(
                                      child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.centerLeft,
                                    image:
                                        "https://joysociety.app/assets/TropicIcons/${topicType}.png",
                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.workshop_default_image,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                      processTopicName(topic
                                          .topicResponse.data![index].name),
                                      style: poppinsBold.copyWith(
                                          color: ColorResources.WHITE,
                                          fontSize: Dimensions.FONT_SIZE_LARGE))
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: topic.topicResponse.data?.length,
                      ))
          ],
        );
      }),
    );
  }
}
