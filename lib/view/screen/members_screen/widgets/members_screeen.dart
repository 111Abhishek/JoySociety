import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/subscription_screen/widget/subscription_card_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/members_followers.dart';
import '../../../../data/model/response/members_followers_model.dart';
import '../../../../data/model/response/profile_model.dart';
import '../../../../provider/members_follwers_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/loader_widget.dart';
import '../profile_scree.dart/member_profile_screen.dart';
import 'custom_card_widget.dart';
import 'package:async/async.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? activeTab = 0;
  ProfileModel? profileModel = ProfileModel();
  FollowingModel? _followersResponse;

  @override
  void initState() {
    _followersResponse = FollowingModel();

    _tabController =
        TabController(length: 3, vsync: this, initialIndex: activeTab!);
    _tabController?.addListener(_onTabChanged);
    Future.delayed(Duration.zero, () async {
      await getProfileDetail();
      await _getFollowingList();
      await _getMembersList();
    });
    super.initState();
  }

  _getMembersList() async {
    await Provider.of<MemberFollowerProvider>(context, listen: false)
        .fetchMembersList();
  }

  _getFollowingList() async {
    _followersResponse =
        await Provider.of<MemberFollowerProvider>(context, listen: false)
            .getFollowingList(profileModel!.userId!);
    setState(() {});
  }

  getProfileDetail() async {
    profileModel = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileData();
    setState(() {});
  }

  void _onTabChanged() async {
    if (activeTab != _tabController!.index) {
      activeTab = _tabController!.index;

      switch (activeTab) {
        case 0:
          await Provider.of<MemberFollowerProvider>(context, listen: false)
              .changeTab(0);
          break;
        case 1:
          await Provider.of<MemberFollowerProvider>(context, listen: false)
              .changeTab(1);
          break;
        case 2:
          await Provider.of<MemberFollowerProvider>(context, listen: false)
              .changeTab(2);
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Image.asset(
                Images.logo_with_name_image,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10),
              Text(
                "Members",
                style: poppinsBold.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          elevation: 0.5,
          backgroundColor: ColorResources.WHITE,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(15),
            child: Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                controller: _tabController,
                labelColor: ColorResources.DARK_GREEN_COLOR,
                unselectedLabelColor: ColorResources.GRAY_TEXT_COLOR,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: ColorResources.DARK_GREEN_COLOR,
                tabs: const [
                  Tab(
                    child: Text(
                      'All',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Newest',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Host',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            Consumer<MemberFollowerProvider>(
              builder: (context, members, child) {
                // _getFollowingList();
                if (members.isScrollLoading) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: members.membersResponse.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MemberProfilePage(
                                        memberResp:
                                            members.membersResponse[index],
                                        followersResponse: _followersResponse,
                                      )));
                        },
                        child: CustomCardWidget(
                          memberResp: members.membersResponse[index],
                          followersResponse: _followersResponse,
                        ),
                      );
                    },
                  );
                } else if (members.isLoading) {
                  return Center(
                    child: Loader().visible(members.isLoading),
                  );
                } else if (members.membersResponse.isEmpty) {
                  return Center(
                    child: Text(
                      "No member found",
                      style: poppinsBold.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  );
                } else {
                  return NotificationListener<ScrollEndNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.extentAfter == 0) {
                          Provider.of<MemberFollowerProvider>(context,
                                  listen: false)
                              .startScrollLoading();
                          Provider.of<MemberFollowerProvider>(context,
                                  listen: false)
                              .fetchMembersList();
                          Provider.of<MemberFollowerProvider>(context,
                                  listen: false)
                              .stopScrollLoading();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: members.membersResponse.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MemberProfilePage(
                                          followersResponse: _followersResponse,
                                          memberResp:
                                              members.membersResponse[index])));
                            },
                            child: CustomCardWidget(
                              memberResp: members.membersResponse[index],
                              followersResponse: _followersResponse,
                            ),
                          );
                        },
                      ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
