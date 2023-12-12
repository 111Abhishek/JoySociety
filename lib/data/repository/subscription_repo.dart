import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/utill/app_constants.dart';

class SubscriptionRepo {
  final DioClient dioClient;

  SubscriptionRepo({required this.dioClient});

  Future<ApiResponse> getSubscription() async {
    try {
      Response response =
          await dioClient.get(AppConstants.SUBSCRIPTION_OPTIONS);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getStripeLink(
    int productId,
  ) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;

    try {
      Response response =
          await dioClient.post(AppConstants.GET_STRIPE_URL, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
