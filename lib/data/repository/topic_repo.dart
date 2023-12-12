

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/utill/app_constants.dart';

class TopicRepo {
  final DioClient dioClient;

  TopicRepo({required this.dioClient});

  Future<ApiResponse> getTopicList() async {
    try {
      Response response = await dioClient.get(AppConstants.TOPIC_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for save topic
  Future<ApiResponse> saveTopic(TopicModel topicModel) async {
    try {
      var map = topicModel.toJson();
      Response response = await dioClient.patch(
        AppConstants.TOPIC_URI + topicModel.id.toString() + '/',
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for save topic
  Future<ApiResponse> deleteTopic(int topicId) async {
    try {
      Response response = await dioClient.delete(
        AppConstants.TOPIC_URI + topicId.toString() + '/',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}