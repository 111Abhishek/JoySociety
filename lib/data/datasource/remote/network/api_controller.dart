import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:joy_society/data/model/response/api_response_model.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/shared_prefs.dart';

class ApiController {
  final JsonDecoder _decoder = const JsonDecoder();

  Future<ApiResponseModel> getPosts({int? userId,
    String? topic,
    int? isPopular = 0,
    int? isFollowing = 0,
    int? clubId = 0,
    int? isSold = 0,
    int? isMine = 0,
    int? isRecent = 0,
    String? title = '',
    String? hashtag = '',
    int page = 0,
    int perPage = 20}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();

    var url = AppConstants.BASE_URL;
    // url = '$url?page=$page';
    // url = '$url&page_size=$perPage';
    if (topic != null) {
      url =
      '${AppConstants
          .BASE_URL}/feeds/timeline/?page=$page&page_size=$perPage&ordering=-created_on&topic=$topic';
    } else {
      url =
      '${AppConstants
          .BASE_URL}/feeds/timeline/?page=$page&page_size=$perPage&ordering=-created_on';
    }

    /*if (userId != null) {
      url = '$url&user_id=$userId';
    }
    if (isPopular != null) {
      url = '$url&is_popular_post=$isPopular';
    }
    if (title != null) {
      url = '$url&title=$title';
    }
    if (isRecent != null) {
      url = '$url&is_recent=$isRecent';
    }
    if (isFollowing != null) {
      url = '$url&is_following_user_post=$isFollowing';
    }
    if (isMine != null) {
      url = '$url&is_my_post=$isMine';
    }
    if (isSold != null) {
      url = '$url&is_winning_post=$isSold';
    }
    if (hashtag != null) {
      url = '$url&hashtag=$hashtag';
    }
    if (clubId != null) {
      url = '$url&club_id=$clubId';
    }*/

    print("Url: $url");

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Token ${authKey!}"
    }).then((http.Response response) async {
      //  log(response.body.toString());
      final ApiResponseModel parsedResponse = await getResponse(
          response.body,
          AppConstants.searchPost,
          page,
          perPage,
          topic: topic
      );
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getResponse(String res, String url, int page,
      int perPage,
      {String? topic}) async {
    try {
      dynamic data = _decoder.convert(res);
      if (data['status'] == 401 /*&& data['data'] == null*/) {
        return ApiResponseModel.fromJson(
          {"message": data['message'], "isInvalidLogin": true},
          url,
          null,
          null,
        );
      } else {
        return ApiResponseModel.fromJson(data, url, page, perPage,
            topic: topic);
      }
    } catch (e) {
      return ApiResponseModel.fromJson(
          {"message": e.toString()}, url, null, null);
    }
  }
}
