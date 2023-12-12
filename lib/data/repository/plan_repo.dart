


import 'dart:io';

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/create_plan_model.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class PlanRepo {
  final DioClient dioClient;

  PlanRepo({required this.dioClient});

  Future<ApiResponse> getPlanList(int page, String search, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      queryParameters['ordering'] = '-created_on';
      Response response = await dioClient.get(
          uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // post goal create
  /*Future<ApiResponse> createPlan(CreatePlanModel? requestModel) async {
    try {
      var map = requestModel?.toJson();
      Response response = await dioClient.post(
        AppConstants.PRODUCT,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }*/

  Future<http.StreamedResponse> createPlan(CreatePlanModel? requestModel, File? file, String? token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.PRODUCT}'));
    request.headers.addAll(<String,String>{'Authorization': 'Token $token'});
    if(file != null){
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
    Map<String, String> _fields = Map();

    _fields.addAll(<String, String>{
      'name': requestModel!.name, 'internal_note': requestModel.internal_note,
      'sales_pitch': requestModel.sales_pitch, 'description': requestModel.description,
      'benefits': requestModel.benefits, 'display_price': requestModel.display_price.toString(),
      'discount': requestModel.discount.toString(), 'offer_price': requestModel.offer_price.toString(),
      'payment_type': requestModel.payment_type,
      'is_active': requestModel.is_active.toString()
    });
    if(requestModel.days != null)
      _fields['days'] = requestModel.days.toString();

    request.fields.addAll(_fields);

    print('========>${_fields.toString()}');
    http.StreamedResponse response = await request.send();
    return response;
  }

  // reorder tribe
  Future<ApiResponse> reorderTribe(List<Map<String, dynamic>> requestModel) async {
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
      Response response = await dioClient.delete(
          AppConstants.TRIBE + "/" + tribeId.toString() + "/");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}