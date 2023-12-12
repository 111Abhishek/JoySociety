import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/createPost/longPost/long_post_screen.dart';
import 'package:joy_society/view/screen/createPost/quickPost/quick_post_screen.dart';
import 'package:joy_society/view/screen/schedulePost/post_types/schedule_long_post.dart';
import 'package:joy_society/view/screen/schedulePost/post_types/schedule_quick_post.dart';

class SchedulePostScreen extends StatefulWidget {
  const SchedulePostScreen({super.key});

  @override
  State<SchedulePostScreen> createState() => _SchedulePostScreenState();
}

class _SchedulePostScreenState extends State<SchedulePostScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text('Quick Post'),
              ),
              Tab(child: Text('Long Post'))
            ],
          ),
          title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              Image.asset(Images.logo_with_name_image, height: 40, width: 40),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Schedule a Post",
                      style: poppinsBold.copyWith(
                          fontSize: 16, color: Colors.black)),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [ScheduleQuickPost(), ScheduleLongPost()],
        ));
  }
}
