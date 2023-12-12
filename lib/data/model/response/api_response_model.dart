import 'package:joy_society/data/model/response/api_meta_data.dart';
import 'package:joy_society/data/model/response/post_model.dart';
import 'package:joy_society/data/model/response/user_model.dart';

class ApiResponseModel {
  bool success = true;
  String message = "";
  bool isInvalidLogin = true;
  String? authKey;
  String? postedMediaFileName;
  String? postedMediaCompletePath;
  String? token;

  UserModel? user;

  int highlightId = 0;
  int createdPostId = 0;

  List<PostModel> posts = [];
  APIMetaData? metaData;

  List<UserModel> blockedUsers = [];
  List<UserModel> liveUsers = [];

  PostModel? post;

  int roomId = 0;

  ApiResponseModel();

  factory ApiResponseModel.fromJson(
      Map<String, dynamic> json, String? url, int? page, int? perPage,
      {String? topic}) {
    ApiResponseModel model = ApiResponseModel();
    model.success = json['status'] == 200;
    dynamic data = json['results'];
    model.isInvalidLogin = json['isInvalidLogin'] == null ? false : true;

    // log(json.toString());
    // log(url);

    //if (model.success) {
    //model.message = json['message'];
    if (data != null && data.length > 0) {
      //if (data['results'] != null) {
      model.posts = [];
      var items = data;
      model.posts = List<PostModel>.from(items.map((x) => PostModel.fromJson(x,
              filters: topic != null && topic.isNotEmpty)))
          /*.where((element) => element.gallery.isNotEmpty)*/
          .toList();

      //model.metaData = APIMetaData.fromJson(data['post']['_meta']);
      model.metaData = APIMetaData(
          totalCount: json['count'],
          next: json['next'],
          previous: json['previous'],
          pageCount: data.length,
          currentPage: page ?? 0,
          perPage: perPage ?? 20);
    }
    //}
    /*} else {
      if (data == null) {
        Timer(const Duration(seconds: 1), () {
          Get.to(() => const LoginScreen());
        });
      } else if (data['token'] != null) {
        model.token = data['token'] as String;
      } else if (data['errors'] != null) {
        Map errors = data['errors'];
        var errorsArr = errors[errors.keys.first] ?? [];
        String error = errorsArr.first ?? LocalizationString.errorMessage;
        model.message = error;
      } else {
        Timer.periodic(const Duration(seconds: 1), (timer) {
          Get.to(() => const LoginScreen());
        });
      }
    }*/
    return model;
  }

  factory ApiResponseModel.fromErrorJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = false;
    model.message = json['message'];
    return model;
  }
}
