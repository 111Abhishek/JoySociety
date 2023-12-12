import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/utill/app_constants.dart';

class MembersFollowerRepo {
  final DioClient dioClient;

  MembersFollowerRepo({required this.dioClient});

  Future<ApiResponse> getMembersList(int pageNO) async {
    try {
      log('/member/list/?page=$pageNO&page_size=20&ordering=-created_on');
      Response response = await dioClient
          .get('/member/list/?page=$pageNO&page_size=20&ordering=-created_on');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
   Future<ApiResponse> commonGet(String uri) async {
    try {
     // Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      // queryParameters['page'] = page;
      // queryParameters['page_size'] = 20;
      // queryParameters['search'] = search;
      Response response = await dioClient.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
