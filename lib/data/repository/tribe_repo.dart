import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
import 'package:joy_society/utill/app_constants.dart';

import '../model/response/create_post_model.dart';

class TribeRepo {
  final DioClient dioClient;

  TribeRepo({required this.dioClient});

  Future<ApiResponse> getTribeList(int page, String search, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // post goal create
  Future<ApiResponse> createTribe(TribeModel requestModel) async {
    try {
      var map = requestModel.toJson();
      Response response = await dioClient.post(
        AppConstants.TRIBE,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // reorder tribe
  Future<ApiResponse> reorderTribe(
      List<Map<String, dynamic>> requestModel) async {
    try {
      var map = requestModel;
      Response response = await dioClient.post(
        AppConstants.TRIBE_REORDER,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // delete tribe
  Future<ApiResponse> deleteTribe(int tribeId) async {
    try {
      Response response = await dioClient
          .delete(AppConstants.TRIBE + "/" + tribeId.toString() + "/");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTribeMembersList(
      int workshopId, int page, String uri) async {
    try {
      Map<String, dynamic>? queryParameters = <String, dynamic>{};
      queryParameters['id'] = workshopId;
      queryParameters['page'] = page;
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> postChannelInfo(String url, int tribeId) async {
    try {
      log("Fetching Event channel information for Event id $tribeId");
      Map<String, dynamic>? data = <String, dynamic>{};
      data['tribe'] = tribeId;
      Response response = await dioClient.post(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getEventList(String uri) async {
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

  Future<ApiResponse> joinTribe(int tribeId) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tribe'] = tribeId;
    try {
      Response response =
          await dioClient.post(AppConstants.TRIBE_MEMBER_URL, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTribeFeed(int pageNO, int id) async {
    try {
      log('/feeds/timeline/?page=$pageNO&page_size=10&ordering=-created_on&tribe=$id');
      Response response = await dioClient.get(
          '/feeds/timeline/?page=$pageNO&page_size=10&ordering=-created_on&tribe=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

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

  Future<ApiResponse> likePost(
      int timilineID, int like, bool flag, bool isCommentLike) async {
    Map<String, dynamic> requestModel = {"flag": flag, "like": like};
    try {
      Response response = await dioClient.put(
        isCommentLike
            ? '/feeds/timeline/comment/$timilineID/like/'
            : '/feeds/timeline/$timilineID/like/',
        data: requestModel,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
