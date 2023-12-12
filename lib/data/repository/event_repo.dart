import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/create_event_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/utill/app_constants.dart';

class EventRepo {
  final DioClient dioClient;

  EventRepo({required this.dioClient});

  Future<ApiResponse> getEventList(int page, String search, String uri) async {
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
  Future<ApiResponse> createEvent(CreateEventModel requestModel) async {
    try {
      var map = requestModel.toJson();
      Response response = await dioClient.post(
        AppConstants.EVENT,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> postChannelInfo(String url, int eventId) async {
    try {
      log("Fetching Event channel information for Event id $eventId");
      Map<String, dynamic>? data = <String, dynamic>{};
      data['event'] = eventId;
      Response response = await dioClient.post(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  
  Future<ApiResponse> fetchEventChat(String baseUrl, int channelId) async {
    String constructedUrl = '$baseUrl$channelId/';
    try {
      Response response = await dioClient.get(constructedUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> postChatMessage(int channelId, String message) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel'] = channelId;
    data['message'] = message;
    try {
      Response response =
          await dioClient.post(AppConstants.postMessageUrl, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteEvent(int eventId) async {
    try {
      Response response = await dioClient.delete(
        "${AppConstants.EVENT}$eventId/",
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

// post goal create
  Future<ApiResponse> updateEvent(String url , int id , String status) async {
    try {
      var map = {"event":id ,"status":status.toUpperCase()};
      Response response = await dioClient.post(
        url,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

   Future<ApiResponse> getEventMembers( String uri) async {
    
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
