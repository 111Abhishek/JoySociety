import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/tribe_list_response_model.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/data/repository/tribe_repo.dart';
import 'package:joy_society/data/repository/workshop_repo.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/create_post_model.dart';
import '../data/model/response/event_list_response_model.dart';
import '../data/model/response/workshop_chats/channel_info_model.dart';
import '../data/model/response/workshop_members_list_model.dart';
import '../data/model/tribe_response_model.dart';

class TribeProvider extends ChangeNotifier {
  final TribeRepo tribeRepo;
  final SharedPreferences? sharedPreferences;

  TribeProvider({required this.tribeRepo, required this.sharedPreferences});

  bool _isLoading = false;
  MemberContentResponseModel? _memberContent;
  CreateWorkshopModel? _createWorkshopModel;
  TribeListResponseModel _tribeListResponse = TribeListResponseModel();

  bool get isLoading => _isLoading;
  MemberContentResponseModel? get memberContent => _memberContent;
  CreateWorkshopModel? get createWorkshopModel => _createWorkshopModel;
  TribeListResponseModel get tribeListResponse => _tribeListResponse;
  MembersListModel _membersListResponse = MembersListModel();
  ChannelInfoModel _channelInfoModel = ChannelInfoModel(id: 0);
  EventListResponseModel _eventListResponseModel = EventListResponseModel();
  EventListResponseModel get eventListResponseModel => _eventListResponseModel;

  bool _isScrollLoading =
      false; // Track if loading is in progress due to scrolling
  int _currentPage = 1;
  int _tab = 0;
  bool _hasMoreData = true;
  List<Result> _tribalFeedListResponse = [];
  bool get hasmoreData => _hasMoreData;
  bool get isScrollLoading => _isScrollLoading;
  List<Result> get tribalFeedResponse => _tribalFeedListResponse;
  TribeFeedResponse _tribalResponse = TribeFeedResponse();

  bool checkBoxFeatured = false;

  void updateCheckBoxFeatured(bool? value) {
    checkBoxFeatured = value!;
    notifyListeners();
  }

  List<CommonListData> getRolesList() {
    List<String>? roles =
        sharedPreferences?.getStringList(AppConstants.ROLES_LIST);
    List<CommonListData> rolesList = [];
    roles?.forEach(
        (cart) => rolesList.add(CommonListData.fromJson(jsonDecode(cart))));
    return rolesList;
  }

  Future createTribe(TribeModel requestModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await tribeRepo.createTribe(requestModel);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      TribeModel responseModel =
          TribeModel.fromJson(apiResponse.response?.data);
      //_userBillingDetailModel = responseModel;
      callback(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, null, errorResponse);
    }
    notifyListeners();
  }

  Future reorderTribes(
      List<Map<String, dynamic>> requestModel, Function callback) async {
    /*_isLoading = true;
    notifyListeners();*/
    ApiResponse apiResponse = await tribeRepo.reorderTribe(requestModel);
    /*_isLoading = false;
    notifyListeners();*/
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      callback(true, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, errorResponse);
    }
    //notifyListeners();
  }

  Future deleteTribe(int tribeId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await tribeRepo.deleteTribe(tribeId);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 204)) {
      callback(true, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, errorResponse);
    }
    notifyListeners();
  }

  Future<MembersListModel> getTribeMembersList(
      int page, int tribeId, String uri) async {
    ApiResponse apiResponse =
        await tribeRepo.getTribeMembersList(tribeId, page, uri);
    MembersListModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _membersListResponse =
          MembersListModel.fromJson(apiResponse.response?.data);
      responseModel = _membersListResponse;
    } else {
      responseModel = MembersListModel();
    }
    notifyListeners();
    return responseModel;
  }

  Future<ChannelInfoModel> fetchChannelInfo(int tribeId) async {
    notifyListeners();
    _isLoading = true;
    ApiResponse apiResponse =
        await tribeRepo.postChannelInfo(AppConstants.channel, tribeId);
    _isLoading = false;
    ChannelInfoModel responseModel;
    if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200 ||
        apiResponse.response?.statusCode == 201) {
      _channelInfoModel = ChannelInfoModel.fromJson(apiResponse.response?.data);
      responseModel = _channelInfoModel;
    } else {
      responseModel = ChannelInfoModel(id: 0);
    }
    notifyListeners();
    return responseModel;
  }

  Future<EventListResponseModel> getEventList(id) async {
    ApiResponse apiResponse =
        await tribeRepo.getEventList('/tribe/$id/events/');
    EventListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _eventListResponseModel =
          EventListResponseModel.fromJson(apiResponse.response?.data);
      responseModel = _eventListResponseModel;
    } else {
      responseModel = EventListResponseModel();
    }
    return responseModel;
  }

  Future joinTribe(int tribeId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await tribeRepo.joinTribe(tribeId);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      callback(true, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, errorResponse);
    }
    notifyListeners();
  }

  Future<TribeListResponseModel> getTribeList(
      int page, String search, String uri) async {
    //_isLoading = true;
    //notifyListeners();
    ApiResponse apiResponse = await tribeRepo.getTribeList(page, search, uri);
    TribeListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _tribeListResponse =
          TribeListResponseModel.fromJson(apiResponse.response?.data);
      responseModel = _tribeListResponse;
    } else {
      responseModel = TribeListResponseModel();
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<TribeFeedResponse> fetchTribalFeedList(int page, int id) async {
    _isLoading = true; // Set isLoading to true when fetching new data
    notifyListeners();

    ApiResponse apiResponse = await tribeRepo.getTribeFeed(_currentPage, id);
    TribeFeedResponse responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _tribalResponse = TribeFeedResponse.fromJson(apiResponse.response?.data);
      responseModel = _tribalResponse;

      notifyListeners(); // Notify listeners after updating the data
    } else {
      responseModel = TribeFeedResponse();
    }

    // Notify listeners after the operation is complete

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void startScrollLoading() {
    _isScrollLoading = true;
    notifyListeners();
  }

  void stopScrollLoading() {
    _isScrollLoading = false;
    notifyListeners();
  }

  Future createPost(CreatePostModel requestModel, String url) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await tribeRepo.createPost(requestModel, url);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      CreatePostModel responseModel =
          CreatePostModel.fromJson(apiResponse.response?.data);
      //_userBillingDetailModel = responseModel;
      //  callback(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      //  callback(false, null, errorResponse);
    }
    notifyListeners();
  }

  Future likePost(
      int timilineID, int like, bool status, bool isCommentLike) async {
    ApiResponse apiResponse =
        await tribeRepo.likePost(timilineID, like, status, isCommentLike);

    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      // CreatePostModel responseModel =
      //     CreatePostModel.fromJson(apiResponse.response?.data);
      //_userBillingDetailModel = responseModel;
      //  callback(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      //  callback(false, null, errorResponse);
    }
    notifyListeners();
  }
}
