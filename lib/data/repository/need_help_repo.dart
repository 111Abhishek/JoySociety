import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/utill/app_constants.dart';

class NeedHelpRepo {
  final DioClient dioClient;

  NeedHelpRepo({required this.dioClient});

  // Create Invite request
  Future<ApiResponse> needHelp(
      String name, String emails, String message, String phone) async {
    try {
      Map<String, dynamic> map = {
        "email": emails,
        "message": message,
        "name": name,
        "phone": phone
      };

      Response response = await dioClient.post(data: map, '/help/needHelp/');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
