import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/data/datasource/remote/network/api_controller.dart';
import 'package:joy_society/data/model/body/post_search_query.dart';
import 'package:joy_society/data/model/response/post_gallery.dart';
import 'package:joy_society/data/model/response/post_model.dart';
import 'package:joy_society/data/model/response/user_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/app_util.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/system_utils.dart';

class HomeController extends GetxController {
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<UserModel> liveUsers = <UserModel>[].obs;

  RxInt currentVisibleVideoId = 0.obs;
  Map<int, double> _mediaVisibilityInfo = {};
  PostSearchQuery postSearchQuery = PostSearchQuery();

  RxBool isRefreshingPosts = false.obs;
  RxBool isRefreshingStories = false.obs;

  RxInt categoryIndex = 0.obs;

  int postsCurrentPage = 1;
  bool _canLoadMorePosts = true;

  clear() {
    liveUsers.clear();
  }

  clearPosts() {
    postsCurrentPage = 1;
    _canLoadMorePosts = true;
    posts.clear();
  }

  categoryIndexChanged({required int index, required VoidCallback callback}) {
    if (index != categoryIndex.value) {
      categoryIndex.value = index;
      clearPosts();
      postSearchQuery = PostSearchQuery();

      if (index == 1) {
        postSearchQuery.isFollowing = 1;
        postSearchQuery.isRecent = 1;
      }
      // else if (index == 2) {
      //   postSearchQuery.isPopular = 1;
      // }
      else if (index == 2) {
        postSearchQuery.isRecent = 1;
      } else if (index == 3) {
        postSearchQuery.isMine = 1;
        postSearchQuery.isRecent = 1;
      } else {
        postSearchQuery.isRecent = 1;
      }

      getPosts(isRecent: false, callback: callback);
    }
  }

  removePostFromList(PostModel post) {
    posts.removeWhere((element) => element.id == post.id);
    posts.refresh();
  }

  void addNewPost(PostModel post) {
    posts.insert(0, post);
    posts.refresh();
  }

  void getPosts(
      {required bool? isRecent,
      required VoidCallback callback,
      String? topic}) async {
    if (_canLoadMorePosts == true) {
      // for (int i = 0; i < 5; i++) {
      //   BannerAdsHelper().loadBannerAds((ad) {
      //     bannerAds.add(ad);
      //     bannerAds.refresh();
      //   });
      // }

      if (isRecent == true) {
        postSearchQuery.isRecent = 1;
      }

      if (postsCurrentPage == 1) {
        isRefreshingPosts.value = true;
      }

      AppUtil.checkInternet().then((value) async {
        if (value) {
          ApiController()
              .getPosts(
                  topic: topic,
                  userId: postSearchQuery.userId,
                  isPopular: postSearchQuery.isPopular,
                  isFollowing: postSearchQuery.isFollowing,
                  isSold: postSearchQuery.isSold,
                  isMine: postSearchQuery.isMine,
                  isRecent: postSearchQuery.isRecent,
                  title: postSearchQuery.title,
                  hashtag: postSearchQuery.hashTag,
                  clubId: postSearchQuery.clubId,
                  page: postsCurrentPage,
                  perPage: topic != null ? 5 : 20)
              .then((response) async {
            
            posts.addAll(response.posts);
            // posts.addAll(/*response.success ?*/
            //     response.posts
            //         /*.where((element) => element.gallery.isNotEmpty)*/
            //         .toList() /*: []*/);
            /*posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));*/
            isRefreshingPosts.value = false;

            //if (_postsCurrentPage >= response.metaData!.pageCount) {
            if (response.metaData?.next == null) {
              _canLoadMorePosts = false;
            } else {
              _canLoadMorePosts = true;
            }
            postsCurrentPage += 1;
         //   log("DONE");
            callback();
          });
        }
      });
    }
  }

  contentOptionSelected(String option, BuildContext context) {
    /*if (option == LocalizationString.story) {
      Get.to(() => const ChooseMediaForStory());
    } else if (option == LocalizationString.post) {
      // Get.offAll(const DashboardScreen(
      //   selectedTab: 2,
      // ));
    } else if (option == LocalizationString.highlights) {
      Get.to(() => const ChooseStoryForHighlights());
    } else if (option == LocalizationString.goLive) {
      Get.to(() => const CheckingLiveFeasibility());
    } else if (option == LocalizationString.competition) {
      Get.to(() => const CompetitionsScreen());
    } else if (option == LocalizationString.liveNow) {
      Get.to(() => const RandomLiveListing());
    }*/
  }

  setCurrentVisibleVideo(
      {required PostGallery media, required double visibility}) {
    // print(visibility);
    if (visibility < 20) {
      currentVisibleVideoId.value = -1;
    }
    _mediaVisibilityInfo[media.id] = visibility;
    double maxVisibility =
        _mediaVisibilityInfo[_mediaVisibilityInfo.keys.first] ?? 0;
    int maxVisibilityMediaId = _mediaVisibilityInfo.keys.first;

    for (int key in _mediaVisibilityInfo.keys) {
      double visibility = _mediaVisibilityInfo[key] ?? 0;
      if (visibility >= maxVisibility) {
        maxVisibilityMediaId = key;
      }
    }

    if (currentVisibleVideoId.value != maxVisibilityMediaId &&
        visibility > 80) {
      currentVisibleVideoId.value = maxVisibilityMediaId;
      // update();
    }
  }

  void reportPost(int postId, BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        /*ApiController().reportPost(postId).then((response) async {
          if (response.success == true) {
            AppUtil.showToast(
                context: context,
                message: LocalizationString.postReportedSuccessfully,
                isSuccess: true);
          } else {
            AppUtil.showToast(
                context: context,
                message: LocalizationString.errorMessage,
                isSuccess: true);
          }
        });*/
      } else {
        AppUtil.showToast(
            context: context,
            message: getTranslated('no_internet_available', context),
            isSuccess: true);
      }
    });
  }

  // void likeUnlikePost(PostModel post, BuildContext context) {
  //   post.isLike = !post.isLike;
  //   post.totalLike = post.isLike ? (post.totalLike) + 1 : (post.totalLike) - 1;
  //   AppUtil.checkInternet().then((value) async {
  //     if (value) {
  //       ApiController()
  //           .likeUnlike(post.isLike, post.id)
  //           .then((response) async {});
  //     } else {
  //       AppUtil.showToast(
  //           context: context,
  //           message: LocalizationString.noInternet,
  //           isSuccess: true);
  //     }
  //   });
  //
  //   posts.refresh();
  //   update();
  // }

  postTextTapHandler({required PostModel post, required String text}) {
    /*if (text.startsWith('#')) {
      Get.to(() => Posts(
        hashTag: text.replaceAll('#', ''),
        source: PostSource.posts,
      ))!
          .then((value) {
        getPosts(isRecent: false,callback: () {});
        getStories();
      });
    } else {
      String userTag = text.replaceAll('@', '');
      if (post.mentionedUsers
          .where((element) => element.userName == userTag)
          .isNotEmpty) {
        int mentionedUserId = post.mentionedUsers
            .where((element) => element.userName == userTag)
            .first
            .id;
        Get.to(() => OtherUserProfile(userId: mentionedUserId))!.then((value) {
          getPosts(isRecent: false,callback: () {});
          getStories();
        });
      }
    }*/
  }
}
