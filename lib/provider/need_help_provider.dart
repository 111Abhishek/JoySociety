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

import '../data/repository/need_help_repo.dart';

class NeedHelpProvider extends ChangeNotifier {
  final NeedHelpRepo need_help_repo;

  NeedHelpProvider({
    required this.need_help_repo,
  });

  bool _isLoading = false;

  // Create Invite
  Future NeedHelp(String name, String emails, String message, String phone,
      Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await need_help_repo.needHelp(name, emails, message, phone);
    _isLoading = false;
    if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200 ||
        apiResponse.response?.statusCode == 201) {
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
