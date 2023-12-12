

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/utill/app_constants.dart';

class MainRepo {
  final DioClient dioClient;

  MainRepo({required this.dioClient});

  // get member content for link to share and content
  Future<ApiResponse> getRoles() async {
    try {
      Response response = await dioClient.get(AppConstants.USER_ROLES);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}