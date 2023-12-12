import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/create_goal_model.dart';
import 'package:joy_society/data/model/response/goal_reflection3_model.dart';

import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/system_utils.dart';

import '../model/response/request_achieved_goal_accountibility.dart';

class GoalRepo {
  final DioClient dioClient;

  GoalRepo({required this.dioClient});

  Future<ApiResponse> getSuccessEvaluationReport(String? reportType) async {
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['report_type'] = reportType;
      Response response = await dioClient.get(
          AppConstants.SUCCESS_EVALUATION_REPORT,
          queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSuccessSphere() async {
    try {
      Response response = await dioClient.get(AppConstants.SUCCESS_SPHERE);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Save goal/reflection/
  Future<ApiResponse> saveGoalReflection3(
      GoalReflection3ModelModel requestModel) async {
    try {
      var map = requestModel.toJson();
      Response response = await dioClient.post(
        AppConstants.GOAL_REFLECTION,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // post goal create
  Future<ApiResponse> completeGoal(RequestAchievedGoal requestModel) async {
    try {
      var map = requestModel.toJson();
      log(map);
      Response response = await dioClient.post(
        AppConstants.COMPLETE_SPHERE,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // post goal create
  Future<ApiResponse> createGoal(CreateGoalModel requestModel) async {
    try {
      var map = requestModel.toJson();
      Response response = await dioClient.post(
        AppConstants.GOAL,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getGoalsList(
      int page, String search, String? status, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      if (status != null) {
        queryParameters['status'] = status;
      }
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProgressDetail(int id, String uri) async {
    print('======id====>$id');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['id'] = id;
      Response response = await dioClient.get('/goal/$id/');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> achieveGoal(int id, String uri) async {
    print('======id====>$id');
    try {
      var body = {"status": "Achieved"};
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['id'] = id;
      Response response = await dioClient.patch('/goal/$id/', data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSphere() async {
    try {
      Response response = await dioClient.get(AppConstants.GOAL_SPHERE);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
