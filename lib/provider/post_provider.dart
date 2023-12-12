import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:joy_society/data/model/posts/CreateScheduledQuickPostModel.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/create_workshop_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/user_profile/profile_upload_image_model.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/data/repository/post_repo.dart';
import 'package:joy_society/data/repository/workshop_repo.dart';
import 'package:file_picker/file_picker.dart';

import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProvider extends ChangeNotifier {
  final PostRepo postRepo;
  final SharedPreferences? sharedPreferences;

  PostProvider({required this.postRepo, required this.sharedPreferences});

  bool _isLoading = false;
  CreateWorkshopModel? _createWorkshopModel;

  bool get isLoading => _isLoading;

  CreateWorkshopModel? get createWorkshopModel => _createWorkshopModel;

  bool checkBoxFeatured = false;

  Future createPost(
      CreatePostModel requestModel, Function callback, String url) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await postRepo.createPost(requestModel, url);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      CreatePostModel responseModel =
          CreatePostModel.fromJson(apiResponse.response?.data);
      //_userBillingDetailModel = responseModel;
      callback(true, responseModel, null);
    } else {
      print('Posting error!');
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, null, errorResponse);
    }
    notifyListeners();
  }

  Future createScheduledQuickPost(QuickPostRequestModel requestModel,
      String url, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await postRepo.createScheduledQuickPost(requestModel, url);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      callback(true, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, errorResponse);
    }
    notifyListeners();
  }

  Future uploadImage(
      PlatformFile file, String category, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await postRepo.uploadPostImage(file, category);
    _isLoading = false;

    notifyListeners();

    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      ProfileUploadImageModel responseModel =
          ProfileUploadImageModel.fromJson(apiResponse.response?.data);
      callback(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, null, errorResponse);
    }
    notifyListeners();
  }
}
