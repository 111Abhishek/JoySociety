

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/create_plan_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/plan_list_response_model.dart';
import 'package:joy_society/data/model/response/response_model.dart';
import 'package:joy_society/data/repository/plan_repo.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PlanProvider extends ChangeNotifier {

  final PlanRepo planRepo;
  final SharedPreferences? sharedPreferences;

  PlanProvider({required this.planRepo, required this.sharedPreferences});

  bool _isLoading = false;
  MemberContentResponseModel? _memberContent;
  CreatePlanModel? _createPlanModel;
  PlanListResponseModel _planListResponse = PlanListResponseModel();

  bool get isLoading => _isLoading;
  MemberContentResponseModel? get memberContent => _memberContent;
  CreatePlanModel? get createPlanModel => _createPlanModel;
  PlanListResponseModel get planListResponse => _planListResponse;

  bool checkBoxFeatured = false;

  File? file = null;

  void updateCheckBoxFeatured(bool? value) {
    checkBoxFeatured = value!;
    notifyListeners();
  }

  void updateCreatePlan1(CreatePlanModel requestModel, File? file) {
    _createPlanModel = requestModel;
    if(file != null) {
     this.file = file;
    }
  }

  List<CommonListData> getRolesList() {
    List<String>? roles = sharedPreferences?.getStringList(AppConstants.ROLES_LIST);
    List<CommonListData> rolesList = [];
    roles?.forEach((cart) => rolesList.add(CommonListData.fromJson(jsonDecode(cart))) );
    return rolesList;
  }

  Future<PlanListResponseModel> getPlanList(
      int page, String search, String uri) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
    await planRepo.getPlanList(page, search, uri);
    PlanListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _planListResponse = PlanListResponseModel.fromJson(apiResponse.response?.data);
      responseModel = _planListResponse;
    } else {
      responseModel = PlanListResponseModel();
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }



  Future createPlan(Function callback) async {
    _isLoading = true;
    notifyListeners();
    var token = sharedPreferences?.getString(AppConstants.TOKEN);
    ResponseModel responseModel;
    http.StreamedResponse apiResponse =
    await planRepo.createPlan(createPlanModel, file, token);
    _isLoading = false;
    notifyListeners();

    if (apiResponse != null &&
        (apiResponse?.statusCode == 200 || apiResponse?.statusCode == 201 )) {
      Map<String, dynamic> map = jsonDecode(await apiResponse.stream.bytesToString());
      CreatePlanModel responseModel =
      CreatePlanModel.fromJson(map);
      //_userBillingDetailModel = responseModel;
      callback(true, responseModel, null);
    } else {
      Map map = jsonDecode(await apiResponse.stream.bytesToString());
      map.isEmpty;
      /*ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, null, errorResponse);*/
    }
    notifyListeners();
  }

  Future reorderTribes(
      List<Map<String, dynamic>> requestModel, Function callback) async {
    /*_isLoading = true;
    notifyListeners();*/
    ApiResponse apiResponse =
    await planRepo.reorderTribe(requestModel);
    /*_isLoading = false;
    notifyListeners();*/
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 || apiResponse.response?.statusCode == 201 )) {
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
    //notifyListeners();
  }

  Future deleteTribe(
      int tribeId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
    await planRepo.deleteTribe(tribeId);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 || apiResponse.response?.statusCode == 204 )) {
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

}