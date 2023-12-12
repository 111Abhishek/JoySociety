import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/system_utils.dart';

class WorkshopRepo {
  final DioClient dioClient;

  WorkshopRepo({required this.dioClient});

  Future<ApiResponse> getWorkshopList(
      int page, String search, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      print("queryParameters: $queryParameters");
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
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

  Future<ApiResponse> getWorkshopFeed(int pageNO, int id) async {
    try {
      log('/feeds/timeline/?page=$pageNO&page_size=10&ordering=-created_on&workshop=$id');
      Response response = await dioClient.get(
          '/feeds/timeline/?page=$pageNO&page_size=10&ordering=-created_on&workshop=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> postChannelInformation(String url, int workshopId) async {
    log("Fetching channel information for workshop id $workshopId");
    try {
      Map<String, dynamic>? data = <String, dynamic>{};
      data['workshop'] = workshopId;
      Response response = await dioClient.post(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get the list of chats for the given workshop
  Future<ApiResponse> fetchChatsForWorkshop(
      String baseUrl, int channelId) async {
    String constructedUrl = '$baseUrl$channelId/';
    try {
      Response response = await dioClient.get(constructedUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Get the content of the workshop from the backend api
  Future<ApiResponse> getWorkshopLessonList(
      int workshopId, int page, String uri) async {
    print("====ID====$workshopId");
    try {
      Map<String, dynamic>? queryParameters = <String, dynamic>{};
      queryParameters['workshop_id'] = workshopId;
      queryParameters['page'] = page;
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWorkshopMembersList(
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

  Future<ApiResponse> joinWorkshop(int workshopId) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workshop'] = workshopId;
    try {
      Response response =
          await dioClient.post(AppConstants.WORKSHOP_MEMBERS, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> subscribeToWorkshop(int workshopId) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workshop_id'] = workshopId;
    try {
      Response response =
          await dioClient.post(AppConstants.SUBSCRIPTION_WORKSHOP, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // post goal create
  Future<ApiResponse> createWorkshop(CreateWorkshopModel requestModel) async {
    try {
      var map = requestModel.toJson();
      Response response = await dioClient.post(
        AppConstants.WORKSHOP,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
