

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/utill/app_constants.dart';

class MembersRepo {
  final DioClient dioClient;

  MembersRepo({required this.dioClient});

  Future<ApiResponse> getSentInvitesList(int page, String search, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      Response response = await dioClient.get(
          uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // request to join list
  Future<ApiResponse> getRequestsToJoinList(int page, String search, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      Response response = await dioClient.get(
          uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // get member content for link to share and content
  Future<ApiResponse> getMemberContent() async {
    try {
      Response response = await dioClient.get(AppConstants.MEMBER_CONTENT);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // get member content for link to share and content
  Future<ApiResponse> updateMemberContent(MemberContentResponseModel memberContent) async {
    try {
      var map = memberContent.toJson();
      Response response = await dioClient.put(AppConstants.MEMBER_CONTENT, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Create Invite request
  Future<ApiResponse> createInvite(List<String> emails, int? id) async {
    try {
      Map<String, dynamic> map = {
        "emails": emails,
        "role": id
      };

      Response response = await dioClient.post(AppConstants.INVITE_CREATE, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  // for save topic
  Future<ApiResponse> saveTopic(TopicModel topicModel) async {
    try {
      var map = topicModel.toJson();
      Response response = await dioClient.patch(
        AppConstants.TOPIC_URI + topicModel.id.toString() + '/',
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for delete topic
  Future<ApiResponse> deleteTopic(int topicId) async {
    try {
      Response response = await dioClient.delete(
        AppConstants.TOPIC_URI + topicId.toString() + '/',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}