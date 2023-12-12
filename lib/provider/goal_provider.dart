import 'dart:core';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/create_goal_model.dart';
import 'package:joy_society/data/model/response/goal_list_response_model.dart';
import 'package:joy_society/data/model/response/goal_reflection3_model.dart';
import 'package:joy_society/data/model/response/member_content_response_model.dart';
import 'package:joy_society/data/model/response/sent_invtes_list_response_model.dart';
import 'package:joy_society/data/model/response/success_evaluation_report_model.dart';
import 'package:joy_society/data/model/response/success_evaluation_report_response_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/topic_response_model.dart';
import 'package:joy_society/data/repository/goal_repo.dart';
import 'package:joy_society/data/repository/members_repo.dart';
import 'package:joy_society/data/repository/topic_repo.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/goal_sphere.dart';
import '../data/model/response/request_achieved_goal_accountibility.dart';

class GoalProvider extends ChangeNotifier {
  final GoalRepo goalRepo;

  GoalProvider({required this.goalRepo});

  bool _isLoading = false;
  SuccessEvaluationReportResponseModel? _successEvaluationReport =
      SuccessEvaluationReportResponseModel(
          highest: 0, data: <SuccessEvaluationReportModel>[]);
  AppListingModel? _successSphereResponse =
      AppListingModel(data: <CommonListData>[]);
  GoalSphereResponse _goalSphereResponse = GoalSphereResponse();
  bool get isLoading => _isLoading;
  SuccessEvaluationReportResponseModel? get successEvaluationReport =>
      _successEvaluationReport;
  AppListingModel? get successSphereResponse => _successSphereResponse;
  GoalSphereResponse? get successGoalResponse => _goalSphereResponse;
  List<String> actionsList = sphere_spiritual_goals;
  List<String> actionDateList = List.generate(6, (i) => "");
  List<String> actionReminderList = List.generate(6, (i) => "");
  List<String> selectedDropDownVal = List.generate(6, (i) => "Select");
  List<String> othersVal = List.generate(6, (i) => "");
  String? completionDate;

  bool checkBoxConnectionSessions = false;
  bool checkBoxNetworking = false;
  bool checkBoxGoalAcc = false;
  bool checkBoxSelfPaced = false;
  bool checkBoxEducational = false;
  bool checkBoxJointTheGoal = false;

  void updateActionList(String sphereName) {
    if (sphereName == "Spiritual") {
      actionsList = sphere_spiritual_goals;
    } else if (sphereName == "Social") {
      actionsList = sphere_social_goals;
    } else if (sphereName == "Romance") {
      actionsList = sphere_romantic_goals;
    } else if (sphereName == "Physical") {
      actionsList = sphere_physical_goals;
    } else if (sphereName == "Finance") {
      actionsList = sphere_financial_goals;
    } else if (sphereName == "Family") {
      actionsList = sphere_family_goals;
    } else if (sphereName == "Emotional/Mental") {
      actionsList = sphere_emotional_goals;
    } else if (sphereName == "Career") {
      actionsList = sphere_careeer_goals;
    } else {
      actionsList = [];
    }
    notifyListeners();
  }

  void maincheckBoxState() {
    checkBoxConnectionSessions = false;
    checkBoxNetworking = false;
    checkBoxGoalAcc = false;
    checkBoxSelfPaced = false;
    checkBoxEducational = false;
    checkBoxJointTheGoal = false;
    notifyListeners();
  }

  void updateCheckBoxConnectionSessions(bool? value) {
    checkBoxConnectionSessions = value!;
    notifyListeners();
  }

  void updateCheckBoxNetworking(bool? value) {
    checkBoxNetworking = value!;
    notifyListeners();
  }

  void updateCheckBoxGoalAcc(bool? value) {
    checkBoxGoalAcc = value!;
    notifyListeners();
  }

  void updateCheckBoxSelfPaced(bool? value) {
    checkBoxSelfPaced = value!;
    notifyListeners();
  }

  void updateCheckBoxEducational(bool? value) {
    checkBoxEducational = value!;
    notifyListeners();
  }

  void updateCheckBoxJointTheGoal(bool? value) {
    checkBoxJointTheGoal = value!;
    notifyListeners();
  }

  // Get Success Evaluation Report
  Future getSuccessEvaluationReport(
      String? reportType, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await goalRepo.getSuccessEvaluationReport(reportType);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      if (reportType == null) {
        _successEvaluationReport =
            SuccessEvaluationReportResponseModel.fromJson(
                apiResponse.response?.data);
        getSuccessEvaluationReport("COMPREHENSIVE", callback);
      } else {
        SuccessEvaluationReportResponseModel response =
            SuccessEvaluationReportResponseModel.fromJson(
                apiResponse.response?.data);
        for (var part2Item in response.data!) {
          _successEvaluationReport?.data![0];
          for (int i = 0; i < _successEvaluationReport!.data!.length; i++) {
            var part1Item = _successEvaluationReport!.data![i];
            if (part2Item.label == part1Item.label) {
              _successEvaluationReport!.data![i] =
                  SuccessEvaluationReportModel.setPart2Score(
                      part1Item.label, part1Item.score, part2Item.score);
              break;
            }
          }
        }
        callback(true, _successEvaluationReport, null);
        notifyListeners();
      }
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
      notifyListeners();
    }
  }

  // Get Success Sphere
  Future getSuccessSphere(Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await goalRepo.getSuccessSphere();
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _successSphereResponse =
          AppListingModel.fromJson(apiResponse.response?.data);

      callback(true, _successSphereResponse, null);
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

  // Get Success Sphere
  Future getSphere(Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await goalRepo.getSphere();
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _goalSphereResponse =
          GoalSphereResponse.fromJson(apiResponse.response?.data);
      callback(true, _goalSphereResponse, null);
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

  // post goal/reflection/
  Future saveReflection3(
      GoalReflection3ModelModel requestModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await goalRepo.saveGoalReflection3(requestModel);
    _isLoading = false;
    //notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      GoalReflection3ModelModel responseModel =
          GoalReflection3ModelModel.fromJson(apiResponse.response?.data);
      //_userBillingDetailModel = responseModel;
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

  // post goal create
  Future createGoal(CreateGoalModel requestModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await goalRepo.createGoal(requestModel);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      CreateGoalModel responseModel =
          CreateGoalModel.fromJson(apiResponse.response?.data);
      //_userBillingDetailModel = responseModel;
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

  Future<GoalListResponseModel> getGoalsList(
      int page, String search, String? status, String uri) async {
    ApiResponse apiResponse =
        await goalRepo.getGoalsList(page, search, status, uri);
    GoalListResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel =
          GoalListResponseModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = GoalListResponseModel();
    }
    return responseModel;
  }

  Future<CreateGoalModel> achieveGoal(
      Function callBack, int id, String uri) async {
    ApiResponse apiResponse = await goalRepo.achieveGoal(id, uri);
    CreateGoalModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      callBack(true);
      responseModel = CreateGoalModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = CreateGoalModel(sphere: -1);
      callBack(false);
    }
    return responseModel;
  }

  Future<CreateGoalModel> getProgressData(int id, String uri) async {
    ApiResponse apiResponse = await goalRepo.getProgressDetail(id, uri);
    CreateGoalModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = CreateGoalModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = CreateGoalModel(sphere: -1);
    }
    return responseModel;
  }

  // post goal create
  Future goalComplte(
      RequestAchievedGoal requestModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await goalRepo.completeGoal(requestModel);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      //_userBillingDetailModel = responseModel;
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
      callback(false, null, errorResponse);
    }
    notifyListeners();
  }
}
