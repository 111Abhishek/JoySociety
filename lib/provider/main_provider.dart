import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/sent_invtes_list_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/topic_response_model.dart';
import 'package:joy_society/data/repository/main_repo.dart';
import 'package:joy_society/data/repository/members_repo.dart';
import 'package:joy_society/data/repository/topic_repo.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider extends ChangeNotifier {
  final MainRepo mainRepo;
  final SharedPreferences? sharedPreferences;

  MainProvider({required this.mainRepo, required this.sharedPreferences});

  bool _isLoading = false;
  MemberContentResponseModel? _memberContent;
  TopicResponseModel _topicResponse = TopicResponseModel();

  bool get isLoading => _isLoading;
  MemberContentResponseModel? get memberContent => _memberContent;
  TopicResponseModel get topicResponse => _topicResponse;

  // Get Roles list
  Future getMemberContent() async {
    _isLoading = true;
    //notifyListeners();
    ApiResponse apiResponse = await mainRepo.getRoles();
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      if (apiResponse.response?.data != null) {
        try {
          List<CommonListData> list = (apiResponse.response?.data as List)
              .map((i) => CommonListData.fromJson(i))
              .toList();
          List<String> roles = [];
          list.forEach((cartModel) => roles.add(jsonEncode(cartModel)));
          sharedPreferences?.setStringList(AppConstants.ROLES_LIST, roles);
        } catch (e) {
          throw e;
        }
      }
      //_memberContent = MemberContentResponseModel.fromJson(apiResponse.response?.data);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
    }
    notifyListeners();
  }
}
