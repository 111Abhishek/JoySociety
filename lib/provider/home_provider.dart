

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/home_repo.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepo homeRepo;
  final SharedPreferences? sharedPreferences;

  HomeProvider({required this.homeRepo, required this.sharedPreferences});

  bool _isLoading = false;

  bool get isLoading => _isLoading;


  Future answerPollValue(
       int question, String answer, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await homeRepo.postAnsers( question, answer);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200 || apiResponse.response?.statusCode == 201) {
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
