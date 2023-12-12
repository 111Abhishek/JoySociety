import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/utill/app_constants.dart';

class NotificationRepo {
  final DioClient dioClient;

  NotificationRepo({required this.dioClient});

  Future<ApiResponse> getNotifications() async {
    try {
      Response response = await dioClient.get(AppConstants.notificationUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e);
    }
  }

  Future<ApiResponse> patchNotification(int notificationId) async {
    try {
      Map<String, dynamic> payload = <String, dynamic>{};
      payload['read_status'] = true;
      Response response = await dioClient.patch(
          "${AppConstants.notificationUpdateUrl}/$notificationId",
          data: payload);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e);
    }
  }
}
