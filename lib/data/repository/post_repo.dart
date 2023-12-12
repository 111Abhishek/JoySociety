import 'dart:io';

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/posts/CreateScheduledQuickPostModel.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;


class PostRepo {
  final DioClient dioClient;

  PostRepo({required this.dioClient});

  // post goal create
  Future<ApiResponse> createPost(
      CreatePostModel requestModel, String url) async {
    try {
      var map = requestModel.toJson();
      Response response = await dioClient.post(
        url,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadPostImage(PlatformFile file, String category) async {
    try {
      File uploadFile = File(file.path!);
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path!, filename: file.name),
        'category': category
      });
      Response response =
          await dioClient.post(AppConstants.uploadProfileImageUri, data: formData,
          options: Options(contentType: 'multipart/form-data'));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print("DIOERROR: ${(e as DioError).toString()}");
      return ApiResponse.withError(ApiErrorHandler.getMessage("Hello"));
    }
  }

  Future<ApiResponse> createScheduledQuickPost(
      QuickPostRequestModel requestModel, String url) async {
    try {
      var map = requestModel.toJson();
      Response response = await dioClient.post(url, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
