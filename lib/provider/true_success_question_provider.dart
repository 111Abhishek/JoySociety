import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';

import 'package:joy_society/data/repository/true_success_repo.dart';

import '../data/model/response/trueSuccessQuesResp.dart';
import '../data/model/response/true_success_result_model.dart';

class TrueSuccessProvider extends ChangeNotifier {
  final TrueSuccessRepo trueSuccessRepo;

  TrueSuccessProvider({
    required this.trueSuccessRepo,
  });

  bool _isLoading = false;
  TrueSuccessQuesResp? _trueQuesContent;
  TrueSuccessResultModel? _successResult;

  bool get isLoading => _isLoading;
  TrueSuccessQuesResp? get trueQuesContent => _trueQuesContent;
  TrueSuccessResultModel? get successResult => _successResult;

  Future<TrueSuccessQuesResp> getTrueSuccessQuestion(String url) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await trueSuccessRepo.commonGet(url);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _trueQuesContent =
          TrueSuccessQuesResp.fromJson(apiResponse.response?.data);
      //  callback(true, _trueQuesContent, null);
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
    return _trueQuesContent!;
  }

  Future successEvaluation(
    Function callback,
    int question,
    int answer,
  ) async {
    ApiResponse apiResponse = await trueSuccessRepo.selectedAnswerPost(
      question,
      answer,
    );

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

  Future<TrueSuccessResultModel> getResultEvaluation(String url) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await trueSuccessRepo.commonGet(url);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _successResult =
          TrueSuccessResultModel.fromJson(apiResponse.response?.data);
      //  callback(true, _trueQuesContent, null);
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
    return _successResult!;
  }
}
