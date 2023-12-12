import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/post_model.dart';
import 'package:joy_society/data/model/response/workshop_chats/workshop_chat_model.dart';
import 'package:joy_society/data/model/response/workshop_lesson_list_response_model.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/data/model/response/workshop_members_list_model.dart';
import 'package:joy_society/data/model/response/workshop_feed_response_model.dart';
import 'package:joy_society/data/model/response/workshop_subscription_url_model.dart';
import 'package:joy_society/data/repository/workshop_repo.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/system_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/workshop_chats/channel_info_model.dart';

class WorkshopProvider extends ChangeNotifier {
  final WorkshopRepo workshopRepo;
  final SharedPreferences? sharedPreferences;

  WorkshopProvider(
      {required this.workshopRepo, required this.sharedPreferences});

  bool _isLoading = false;
  MemberContentResponseModel? _memberContent;
  CreateWorkshopModel? _createWorkshopModel;
  WorkshopListResponseModel _workshopListResponse = WorkshopListResponseModel();
  WorkshopLessonListResponseModel _workshopLessonListResponse =
      WorkshopLessonListResponseModel();
  MembersListModel _workshopMembersListResponse = MembersListModel();
  List<ChatModel> _workshopChatModelListResponse = [];
  ChannelInfoModel _channelInfoModel = ChannelInfoModel(id: 0);

  WorkshopFeedResponse _workshopFeedResponse = WorkshopFeedResponse();

  bool get isLoading => _isLoading;

  MemberContentResponseModel? get memberContent => _memberContent;

  CreateWorkshopModel? get createWorkshopModel => _createWorkshopModel;

  WorkshopListResponseModel get workshopListResponse => _workshopListResponse;

  MembersListModel get workshopMembersLIstResponse =>
      _workshopMembersListResponse;

  ChannelInfoModel get channelInfoModel => _channelInfoModel;

  List<ChatModel> get workshopChatModelList => _workshopChatModelListResponse;

  WorkshopFeedResponse get workshopFeedResposne => _workshopFeedResponse;

  int _currentPage = 1;

  bool checkBoxFeatured = false;

  void updateCheckBoxFeatured(bool? value) {
    checkBoxFeatured = value!;
    notifyListeners();
  }

  void saveWorkshopCreation1(CreateWorkshopModel requestModel) {
    _createWorkshopModel = requestModel;
  }

  List<CommonListData> getRolesList() {
    List<String>? roles =
        sharedPreferences?.getStringList(AppConstants.ROLES_LIST);
    List<CommonListData> rolesList = [];
    roles?.forEach(
        (cart) => rolesList.add(CommonListData.fromJson(jsonDecode(cart))));
    return rolesList;
  }

  Future<WorkshopListResponseModel> getWorkshopList(
      int page, String search, String uri) async {
    ApiResponse apiResponse =
        await workshopRepo.getWorkshopList(page, search, uri);
    WorkshopListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _workshopListResponse =
          WorkshopListResponseModel.fromJson(apiResponse.response?.data);
      responseModel = _workshopListResponse;
    } else {
      responseModel = WorkshopListResponseModel();
    }
    notifyListeners();
    return responseModel;
  }

  Future<ChannelInfoModel> fetchChannelInformation(int workshopId) async {
    notifyListeners();
    _isLoading = true;
    ApiResponse apiResponse = await workshopRepo.postChannelInformation(
        AppConstants.channel, workshopId);
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

  Future<List<ChatModel>> getWorkshopChats(String uri, int channelId) async {
    notifyListeners();
    ApiResponse apiResponse =
        await workshopRepo.fetchChatsForWorkshop(uri, channelId);
    notifyListeners();
    List<ChatModel> responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _workshopChatModelListResponse = (apiResponse.response?.data as List)
          .map((chat) => ChatModel.fromJson(chat))
          .toList();
      responseModel = _workshopChatModelListResponse;
    } else {
      responseModel = [];
    }
    notifyListeners();
    return responseModel;
  }

  Future<WorkshopLessonListResponseModel> getWorkshopLessonList(
      int page, int workshopId, String uri) async {
    ApiResponse apiResponse =
        await workshopRepo.getWorkshopLessonList(workshopId, page, uri);
    WorkshopLessonListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _workshopLessonListResponse =
          WorkshopLessonListResponseModel.fromJson(apiResponse.response?.data);
      responseModel = _workshopLessonListResponse;
    } else {
      responseModel = WorkshopLessonListResponseModel();
    }
    notifyListeners();
    return responseModel;
  }

  Future<MembersListModel> getWorkshopMembersList(
      int page, int workshopId, String uri) async {
    ApiResponse apiResponse =
        await workshopRepo.getWorkshopMembersList(workshopId, page, uri);
    MembersListModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _workshopMembersListResponse =
          MembersListModel.fromJson(apiResponse.response?.data);
      responseModel = _workshopMembersListResponse;
    } else {
      responseModel = MembersListModel();
    }
    notifyListeners();
    return responseModel;
  }

  Future sendChat(int channelId, String chatMessage, Function callback) async {
    _isLoading = true;
    notifyListeners();
    // here sanitize the chatMessage
    String htmlChatMessage = "<div>$chatMessage</div>";
    ApiResponse apiResponse =
        await workshopRepo.postChatMessage(channelId, htmlChatMessage);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      callback(true, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, errorResponse);
    }
    notifyListeners();
  }

  Future likePost(
      int timilineID, int like, bool status, bool isCommentLike) async {
    ApiResponse apiResponse =
        await workshopRepo.likePost(timilineID, like, status, isCommentLike);

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

  Future createComment(
      CreatePostModel requestModel, String url, Function callBack) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workshopRepo.createPost(requestModel, url);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      Comment responseModel = Comment.fromJson(apiResponse.response?.data);
      callBack(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        log(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callBack(false, null, errorResponse);
    }
    notifyListeners();
  }

  Future createCommentForPost(
      CreatePostModel requestModel, String url, Function callBack) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workshopRepo.createPost(requestModel, url);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      PostCommentModel responseModel =
          PostCommentModel.fromJson(apiResponse.response?.data);
      callBack(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        log(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callBack(false, null, errorResponse);
    }
    notifyListeners();
  }

  Future createPost(CreatePostModel requestModel, String url) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workshopRepo.createPost(requestModel, url);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      Comment responseModel = Comment.fromJson(apiResponse.response?.data);
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

  // creating the provider for workshop feed
  Future<WorkshopFeedResponse> fetchWorkshopFeedList(int page, int id) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await workshopRepo.getWorkshopFeed(page, id);

    WorkshopFeedResponse responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _workshopFeedResponse =
          WorkshopFeedResponse.fromJson(apiResponse.response?.data);
      responseModel = _workshopFeedResponse;

      notifyListeners(); // Notify listeners after updating the data
    } else {
      responseModel = WorkshopFeedResponse();
    }

    // Notify listeners after the operation is complete

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future joinWorkshop(int workshopId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workshopRepo.joinWorkshop(workshopId);
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

  Future subscribeWorkshop(int workshopId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await workshopRepo.subscribeToWorkshop(workshopId);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      WorkshopSubscriptionUrlModel? responseModel =
          WorkshopSubscriptionUrlModel.fromJson(apiResponse.response?.data);
      callback(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        log(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, null, errorResponse);
    }
    notifyListeners();
  }

  Future createWorkshop(
      CreateWorkshopModel requestModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workshopRepo.createWorkshop(requestModel);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      CreateWorkshopModel responseModel =
          CreateWorkshopModel.fromJson(apiResponse.response?.data);
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
}
