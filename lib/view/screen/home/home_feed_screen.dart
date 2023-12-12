import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/post_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/provider/home_controller.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/extensions/extensions.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/home/widget/post_card.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';

import '../../basewidget/loader_widget.dart';

class HomeFeedScreen extends StatefulWidget {
  // const HomeFeedScreen() : super();

  @override
  HomeFeedState createState() => HomeFeedState();
}

class HomeFeedState extends State<HomeFeedScreen> {
  final GlobalKey _homeFeedKey = GlobalKey<ScaffoldState>();

  final HomeController _homeController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final _controller = ScrollController();
  ProfileModel? profileModel;

  String? selectedValue;

  init() async {
    profileModel = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileData();
  }

  @override
  void initState() {
    super.initState();
    init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(isRecent: true);
    });

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
        } else {
          loadData(isRecent: false);
        }
      }
    });
  }

  loadMore({required bool? isRecent}) {
    loadPosts(isRecent);
  }

  refreshData() {
    _homeController.clear();
    _homeController.clearPosts();
    _homeController.postSearchQuery.topic = null;
    loadData(isRecent: false);
  }

  @override
  void dispose() {
    _homeController.clear();
    _controller.dispose();
    super.dispose();
  }

  loadPosts(bool? isRecent) {
    log(_homeController.postSearchQuery.topic.toString());
    _homeController.getPosts(
        isRecent: isRecent,
        topic: _homeController.postSearchQuery.topic,
        callback: () {
          _refreshController.refreshCompleted();
        });
  }

  void loadData({required bool? isRecent}) {
    loadPosts(isRecent);
    //_homeController.getStories();
  }

  @override
  void didUpdateWidget(covariant HomeFeedScreen oldWidget) {
    loadData(isRecent: false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _homeFeedKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: _homeController.isRefreshingPosts.isTrue
                  ? Loader().visible(true)
                  : postsView(),
            ),
          ],
        ));
  }

  postsView() {
    print('Total Posts: ${_homeController.posts}');
    return Obx(() {
      return _homeController.isRefreshingPosts.isTrue
          ? Loader().visible(true)
          : ListView.separated(
                  controller: _controller,
                  padding: const EdgeInsets.only(top: 20, bottom: 100),
                  itemCount: _homeController.posts.length /*+ 3*/,
                  itemBuilder: (context, index) {
                    PostModel model = _homeController.posts[index];

                    return PostCard(
                      model: model,
                      profile: profileModel,
                      textTapHandler: (text) {
                        _homeController.postTextTapHandler(
                            post: model, text: text);
                      },
                      removePostHandler: () {
                        _homeController.removePostFromList(model);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    // if ((index + 1) % 5 == 0) {
                    //   return FutureBuilder<Widget>(
                    //     future: BannerAdsWidget.getBannerWidget(
                    //         context: context, index: (index + 1) % 5),
                    //     builder: (_, snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return Container();
                    //       } else {
                    //         return SizedBox(
                    //           height: 50,
                    //           width: MediaQuery.of(context).size.width,
                    //           child: snapshot.data,
                    //         );
                    //       }
                    //     },
                    //   );
                    // }
                    /*if (index == 1) {
              return Container();
            } else {
              return const SizedBox(
                height: 20,
              );
            }*/
                    return const SizedBox(
                      height: 20,
                    );
                  })
              .addPullToRefresh(
                  refreshController: _refreshController,
                  enablePullUp: false,
                  onRefresh: refreshData,
                  onLoading: () {});
    });
  }
}
