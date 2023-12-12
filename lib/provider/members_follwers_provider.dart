import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';

import '../data/model/response/member_follow_response.dart';
import '../data/model/response/member_response_model.dart';
import '../data/model/response/members_followers.dart';
import '../data/model/response/members_followers_model.dart';
import '../data/repository/member_follower.dart';
import '../utill/app_constants.dart';

class MemberFollowerProvider extends ChangeNotifier {
  final MembersFollowerRepo membersRepo;
  List<Result> _memberResponse = [];
  bool _isLoading = false;
  bool _isScrollLoading =
      false; // Track if loading is in progress due to scrolling
  int _currentPage = 1;
  int _tab = 0;
  bool _hasMoreData = true;

  bool get isLoading => _isLoading;
  bool get isScrollLoading => _isScrollLoading;
  List<Result> get membersResponse => _memberResponse;
  MemberFollowUnFollowResponse _membersfollowResp =
      MemberFollowUnFollowResponse();
  FollowingModel _followersResponse = FollowingModel();
  MemberResponseModel _memberDetailResponse = MemberResponseModel();
  MemberResponseModel get memberdetailResp => _memberDetailResponse;
  FollowingModel get followersResponse => _followersResponse;
  MemberFollowerProvider({required this.membersRepo}) {
    fetchMembersList();
  }

  Future<void> fetchMembersList() async {
    if (_isLoading || !_hasMoreData) return;

    if (!_isScrollLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      ApiResponse apiResponse = await membersRepo.getMembersList(_currentPage);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        MembersResponse tempResponse =
            MembersResponse.fromJson(apiResponse.response?.data);

        List<Result> results = [];

        if (_tab == 0) {
          results.addAll(tempResponse.results!.toList());
        } else if (_tab == 1) {
          DateTime currentTime = DateTime.now();

          results = tempResponse.results!.where((result) {
            DateTime createdOn = result.createdOn!;
            Duration difference = currentTime.difference(createdOn);
            return difference.inDays <= 7;
          }).toList();
        } else if (_tab == 2) {
          // Fetch and store data where role == 1 until there's no more data
          while (tempResponse.results != null &&
              tempResponse.results!.isNotEmpty) {
            results.addAll(tempResponse.results!
                .where((result) => result.role == 1)
                .toList());

            if (tempResponse.next == null) {
              // No more data to fetch
              break;
            }

            // Fetch the next page
            _currentPage++;
            apiResponse = await membersRepo.getMembersList(_currentPage);
            tempResponse = MembersResponse.fromJson(apiResponse.response?.data);
          }
        }

        _memberResponse.addAll(results);
        log("${tempResponse.count}/$_currentPage");
        int pages = (tempResponse.count! / 20).toInt();
        log("Pages = $pages");

        if ((tempResponse.count! / 10).toInt() == _currentPage) {
          _hasMoreData = false;
        } else {
          await _currentPage++;
        }
      }

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _hasMoreData = false;
    }

    notifyListeners();
  }

  Future<void> changeTab(int tab) async {
    if (_tab != tab) {
      _tab = tab;
      _memberResponse.clear();
      _currentPage = 1;
      _hasMoreData = true;
      await fetchMembersList();
    }
  }

  void refreshMembersList() {
    _memberResponse.clear();
    _currentPage = 1;
    _hasMoreData = true;
    fetchMembersList();
  }

  void startScrollLoading() {
    _isScrollLoading = true;
    notifyListeners();
  }

  void stopScrollLoading() {
    _isScrollLoading = false;
    notifyListeners();
  }

  Future<MemberFollowUnFollowResponse> follow(
      int memberId, bool isFollowing) async {
    // notifyListeners();
    // _isLoading = true;
    log(memberId.toString());
    ApiResponse apiResponse = await membersRepo.commonGet(
        isFollowing ? '/user/$memberId/follow/' : '/user/$memberId/unfollow/');
    _isLoading = false;
    MemberFollowUnFollowResponse responseModel;
    if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200 ||
        apiResponse.response?.statusCode == 201) {
      _membersfollowResp =
          MemberFollowUnFollowResponse.fromJson(apiResponse.response?.data);
      responseModel = _membersfollowResp;
    } else {
      responseModel = MemberFollowUnFollowResponse();
    }
    // notifyListeners();
    return responseModel;
  }

  Future<FollowingModel> getFollowingList(int idFollowers) async {
    // _isLoading = true;
    // notifyListeners();
    log(idFollowers.toString());
    ApiResponse apiResponse =
        await membersRepo.commonGet('/user/$idFollowers/followings/');
    _isLoading = false;

    FollowingModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = FollowingModel.fromJson(apiResponse.response?.data);
      //  notifyListeners();
    } else {
      responseModel = FollowingModel();
    }
    _followersResponse = responseModel;

    return responseModel;
  }

  Future<MemberResponseModel> getMemberInfo(int memberId) async {
    // _isLoading = true;
    // notifyListeners();
    log(memberId.toString());
    ApiResponse apiResponse =
        await membersRepo.commonGet('/member/$memberId/detail/');
    _isLoading = false;

    MemberResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = MemberResponseModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = MemberResponseModel();
    }
    _memberDetailResponse = responseModel;
   // notifyListeners();

    return responseModel;
  }
}
