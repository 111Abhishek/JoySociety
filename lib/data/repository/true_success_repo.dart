import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';

class TrueSuccessRepo {
  final DioClient dioClient;

  TrueSuccessRepo({required this.dioClient});
  Future<ApiResponse> commonGet(String uri) async {
    try {
      Response response = await dioClient.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> selectedAnswerPost(
    int question,
    int answer,
  ) async {
    Map<String, dynamic> requestModel = {
      "question": question,
      "answer": answer
    };
    try {
      Response response = await dioClient.post(
        '/goal/success-evaluation/',
        data: requestModel,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
