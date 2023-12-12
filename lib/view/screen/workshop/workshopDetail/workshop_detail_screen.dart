import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/data/model/response/workshop_lesson.dart';
import 'package:joy_society/data/model/response/workshop_model.dart';

import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';

import 'package:joy_society/view/screen/workshop/workshopDetail/chat_screen.dart';

import 'package:joy_society/view/screen/workshop/workshopDetail/lessons_list_screen.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/members_list_screen.dart';
import 'package:joy_society/view/screen/workshop/workshopFeed/workshop_feed_screen.dart';

class WorkshopDetailScreen extends StatefulWidget {
  const WorkshopDetailScreen(
      {super.key,
        required this.workshop,
      });


  final WorkshopModel workshop;
  // final String tagline;

  @override
  State<WorkshopDetailScreen> createState() => _WorkshopDetailScreenState();
}

class _WorkshopDetailScreenState extends State<WorkshopDetailScreen> {
  List<WorkshopLessonModel> data = [];

  int currentIndex = 0;
  List<Widget> _pages() => [
        LessonListScreen(workshopId: widget.workshop.id),
        WorkshopFeedScreen(workshop: widget.workshop),
        WorkshopMembersScreen(workshopId: widget.workshop.id),
        WorkshopChatScreen(
          workshopId: widget.workshop.id,
        )
      ];

  String generateTagline() {
    return widget.workshop.tagline ?? (widget.workshop.title ?? "");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget buildNavigationIconPill(int index, String pillContext, IconData selectedIconType, IconData unselectedIconType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                currentIndex = index;
              });
            },
            splashRadius: 0.001,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, maxWidth: 30),
            icon: currentIndex == index
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Icon(selectedIconType,
                        size: 30, color: ColorResources.DARK_GREEN_COLOR))
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Icon(unselectedIconType,
                        size: 30, color: Colors.black45))),
        const SizedBox(height: 4,),
        Text(pillContext,
            style: currentIndex == index
                ? poppinsSemiBold.copyWith(fontSize: 11, color: Colors.black)
                : poppinsSemiBold.copyWith(fontSize: 11, color: Colors.black45))
      ],
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return Container(
        height: 64,
        decoration: const BoxDecoration(color: ColorResources.WHITE),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavigationIconPill(0, "Lessons", Icons.amp_stories, Icons.amp_stories_outlined),
            buildNavigationIconPill(1, "Feed", Icons.feed, Icons.feed_outlined),
            buildNavigationIconPill(2, "Members", Icons.people, Icons.people_outline),
            buildNavigationIconPill(3, "Chat", Icons.chat_bubble, Icons.chat_bubble_outline),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _pages();

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                  onPressed: () => Navigator.pop(context), color: Colors.black),
              Column(children: [
                Row(
                  children: [
                    Image.asset(
                      Images.logo_with_name_image,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.workshop.title!.capitalize!,
                            style: poppinsBold.copyWith(
                                fontSize: 14, color: ColorResources.BLACK)),
                        Text(generateTagline().capitalize!,
                            style: poppinsRegular.copyWith(
                                fontSize: 12, color: Colors.black54))
                      ],
                    )
                  ],
                ),
              ])
            ],
          ),
        ),
        body: Container(
          child: pages[currentIndex],
        ),
        bottomNavigationBar: buildBottomNavigationBar(context));
  }
}
