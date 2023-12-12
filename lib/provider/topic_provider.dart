import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/topic_response_model.dart';
import 'package:joy_society/data/repository/topic_repo.dart';

class TopicProvider extends ChangeNotifier {
  final TopicRepo topicRepo;

  TopicProvider({required this.topicRepo});

  bool _isLoading = false;
  TopicResponseModel _topicResponse = TopicResponseModel();

  bool get isLoading => _isLoading;
  TopicResponseModel get topicResponse => _topicResponse;

  Future<TopicResponseModel> getTopicsList() async {
    //_isLoading = true;
    //notifyListeners();

    ApiResponse apiResponse = await topicRepo.getTopicList();
    _isLoading = false;

    TopicResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = TopicResponseModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = TopicResponseModel();
    }
    _topicResponse = responseModel;

    notifyListeners();
    return responseModel;
  }

  // post topic detail
  Future saveTopic(TopicModel topicModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await topicRepo.saveTopic(topicModel);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      TopicModel responseModel =
          TopicModel.fromJson(apiResponse.response?.data);
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

  //post delete topics

  // post billing details
  Future deleteTopic(
      BuildContext context, int topicId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await topicRepo.deleteTopic(topicId);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      /*TopicDeleteModel responseModel =
      TopicDeleteModel.fromJson(apiResponse.response?.data);
      _topicDeleteModel = responseModel;*/
      //callback(true, responseModel, null);
    } else if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 204) {
      _isLoading = false;
      callback(context, true, TopicModel(id: topicId, order: 0), null);
    } else {
      ErrorResponse? errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(context, false, null, errorResponse);
    }
    notifyListeners();
  }
}
