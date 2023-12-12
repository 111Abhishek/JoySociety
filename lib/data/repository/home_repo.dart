import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';

class HomeRepo {
  final DioClient dioClient;

  HomeRepo({required this.dioClient});
  Future<ApiResponse> postAnsers(
    int question,
    String answer,
  ) async {
    try {
      Map<String, dynamic> map = {"question": question, "answer": answer};

      Response response =
          await dioClient.post("/feeds/answer-poll/", data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
