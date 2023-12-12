import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/create_event_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/event_list_response_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/data/repository/event_repo.dart';
import 'package:joy_society/data/repository/workshop_repo.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/channel_response.dart';
import '../data/model/response/workshop_chats/channel_info_model.dart';
import '../data/model/response/workshop_chats/workshop_chat_model.dart';

class EventProvider extends ChangeNotifier {
  final EventRepo eventRepo;
  final SharedPreferences? sharedPreferences;

  EventProvider({required this.eventRepo, required this.sharedPreferences});

  bool _isLoading = false;
  MemberContentResponseModel? _memberContent;
  CreateEventModel? _createEventModel;
  EventListResponseModel _eventListResponseModel = EventListResponseModel();

  ChannelResponse createChannelResponse = ChannelResponse();

  ChannelResponse get channelResponse => createChannelResponse;

  bool get isLoading => _isLoading;
  MemberContentResponseModel? get memberContent => _memberContent;
  CreateEventModel? get createEventModel => _createEventModel;
  EventListResponseModel get eventListResponseModel => _eventListResponseModel;
  ChannelInfoModel _channelInfoModel = ChannelInfoModel(id: 0);
  bool checkBoxFeatured = false;
  List<ChatModel> _eventChatModelListResponse = [];
  // Start Start Date Create Event
  String startDate = "MM/DD/YYYY";
  String startTime = "00:00 AM";
  // End Start Create Event

  // Start End Date Create Event
  String endDate = "MM/DD/YYYY";
  String endTime = "00:00 AM";
  // End End Date Create Event

  void updateCheckBoxFeatured(bool? value) {
    checkBoxFeatured = value!;
    notifyListeners();
  }

  void addCreateEventTitleAndTime(CreateEventModel requestModel) {
    _createEventModel = requestModel;
  }

  Future<EventListResponseModel> getEventList(
      int page, String search, String uri) async {
    ApiResponse apiResponse = await eventRepo.getEventList(page, search, uri);
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

  Future createEvent(CreateEventModel requestModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await eventRepo.createEvent(requestModel);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      CreateEventModel responseModel =
          CreateEventModel.fromJson(apiResponse.response?.data);
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

  Future deleteEvent(int eventId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await eventRepo.deleteEvent(eventId);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201 ||
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
      callback(false, null, errorResponse);
    }
    notifyListeners();
  }

  Future<ChannelInfoModel> fetchChannelInfo(int eventId) async {
    notifyListeners();
    _isLoading = true;
    ApiResponse apiResponse =
        await eventRepo.postChannelInfo(AppConstants.channel, eventId);
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

  Future<List<ChatModel>> getPreviousChats(String uri, int channelId) async {
    notifyListeners();
    ApiResponse apiResponse = await eventRepo.fetchEventChat(uri, channelId);
    notifyListeners();
    List<ChatModel> responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _eventChatModelListResponse = (apiResponse.response?.data as List)
          .map((chat) => ChatModel.fromJson(chat))
          .toList();
      responseModel = _eventChatModelListResponse;
    } else {
      responseModel = [];
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
        await eventRepo.postChatMessage(channelId, htmlChatMessage);
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

  Future updateEvent(
      String url, int id, String value) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await eventRepo.updateEvent(url, id, value);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      //_userBillingDetailModel = responseModel;
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
