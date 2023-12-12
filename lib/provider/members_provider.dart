

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/sent_invtes_list_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/topic_response_model.dart';
import 'package:joy_society/data/repository/members_repo.dart';
import 'package:joy_society/data/repository/topic_repo.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MembersProvider extends ChangeNotifier {

  final MembersRepo membersRepo;
  final SharedPreferences? sharedPreferences;

  MembersProvider({required this.membersRepo, required this.sharedPreferences});

  bool _isLoading = false;
  MemberContentResponseModel? _memberContent;
  TopicResponseModel _topicResponse = TopicResponseModel();

  bool get isLoading => _isLoading;
  MemberContentResponseModel? get memberContent => _memberContent;
  TopicResponseModel get topicResponse => _topicResponse;

  List<CommonListData> getRolesList() {
    List<String>? roles = sharedPreferences?.getStringList(AppConstants.ROLES_LIST);
    List<CommonListData> rolesList = [];
    roles?.forEach((cart) => rolesList.add(CommonListData.fromJson(jsonDecode(cart))) );
    return rolesList;
  }

  Future<SentInvitesListResponseModel> getSentInvitesList(
      int page, String search, String uri) async {
    ApiResponse apiResponse =
    await membersRepo.getSentInvitesList(page, search, uri);
    SentInvitesListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = SentInvitesListResponseModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = SentInvitesListResponseModel();
    }
    return responseModel;
  }

  Future<SentInvitesListResponseModel> getRequestsToJoinList(
      int page, String search, String uri) async {
    ApiResponse apiResponse =
    await membersRepo.getRequestsToJoinList(page, search, uri);
    SentInvitesListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = SentInvitesListResponseModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = SentInvitesListResponseModel();
    }
    return responseModel;
  }

  // Get Member Content
  Future getMemberContent(Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
    await membersRepo.getMemberContent();
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _memberContent = MemberContentResponseModel.fromJson(apiResponse.response?.data);
      callback(true, _memberContent, null);
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

  // Update Member Content
  Future updateMemberContent(MemberContentResponseModel memberContent, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await membersRepo.updateMemberContent(memberContent);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _memberContent = MemberContentResponseModel.fromJson(apiResponse.response?.data);
      callback(true, _memberContent, null);
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

  // Create Invite
  Future createInvite(List<String> emails, int? id , Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await membersRepo.createInvite(emails, id);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {

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

}