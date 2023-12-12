import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:joy_society/data/datasource/remote/dio/dio_client.dart';
import 'package:joy_society/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joy_society/data/model/response/address_model.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/user_billing_detail_model.dart';
import 'package:joy_society/data/model/response/user_info_model.dart';
import 'package:joy_society/data/model/response/user_phone_email_model.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/response/topic_delete_model.dart';

class ProfileRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Select Address type',
        'Permanent',
        'Home',
        'Office',
      ];
      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: addressTypeList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient.get(AppConstants.CUSTOMER_URI);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAllAddress() async {
    try {
      final response = await dioClient.get(AppConstants.ADDRESS_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeAddressByID(int id) async {
    try {
      final response =
          await dioClient.delete('${AppConstants.REMOVE_ADDRESS_URI}$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addAddress(AddressModel addressModel) async {
    try {
      Response response = await dioClient.post(
        AppConstants.ADD_ADDRESS_URI,
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateProfile(ProfileModel profileModel) async {
    try {
      var map = profileModel.toJson();
      Response response = await dioClient.post(
        AppConstants.USER_PROFILE_URI,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProfile() async {
    try {
      Response response = await dioClient.get(AppConstants.USER_PROFILE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadImage(File file, String category) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        'category': category
      });
      Response response =
          await dioClient.post(AppConstants.uploadProfileImageUri, data: formData,
          options: Options(contentType: 'multipart/form-data'));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print("DIOERROR: ${(e as DioError).toString()}");
      return ApiResponse.withError(ApiErrorHandler.getMessage("Hello"));
    }
  }

  Future<http.StreamedResponse> updateUserInfo(
      UserInfoModel userInfoModel, File? file, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.UPDATE_PROFILE_URI}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (file != null) {
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    Map<String, String> _fields = Map();

    _fields.addAll(<String, String>{
      '_method': 'put',
      'f_name': userInfoModel.fName!,
      'l_name': userInfoModel.lName!,
      'phone': userInfoModel.phone!
    });

    request.fields.addAll(_fields);
    print('========>${_fields.toString()}');
    http.StreamedResponse response = await request.send();
    return response;
  }

  // repository for getting the badges for the given profile
  Future<ApiResponse> getProfileBadges() async {
    try {
      final response = await dioClient.get(AppConstants.userBadgeUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for getting user email and phone no details
  Future<ApiResponse> getUserEmailPhoneDetails() async {
    try {
      final response = await dioClient.get(AppConstants.userCredentialsUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for save home address
  // for getting user email and phone no details
  Future<ApiResponse> updateUserCred(UserPhoneEmailModel userCredModel) async {
    try {
      final response = await dioClient.patch(
        AppConstants.userCredentialsUri,
        data: userCredModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLocationsList(
      int page, String search, String uri) async {
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

  Future<ApiResponse> getCountryList(
      int page, String search, String uri) async {
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

  Future<ApiResponse> getStateList(
      int page, String search, int? countryId, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      if (countryId != null) {
        queryParameters['country_id'] = countryId;
      }
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCityList(
      int page, String search, int? stateId, String uri) async {
    print('======Page====>$page');
    try {
      Map<String, dynamic>? queryParameters = Map<String, dynamic>();
      queryParameters['page'] = page;
      queryParameters['page_size'] = 20;
      queryParameters['search'] = search;
      if (stateId != null) {
        queryParameters['state_id'] = stateId;
      }
      Response response =
          await dioClient.get(uri, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for getting user Billing details
  Future<ApiResponse> getBillingDetails() async {
    try {
      final response =
          await dioClient.get(AppConstants.USER_BILLING_DETAILS_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for save user billing details
  Future<ApiResponse> saveBillingDetail(
      UserBillingDetailModel userBillingDetailModel) async {
    try {
      var map = userBillingDetailModel.toJson();
      Response response = await dioClient.post(
        AppConstants.SAVE_USER_BILLING_DETAILS_URI,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for delete topic
  Future<ApiResponse> topicDelete(TopicDeleteModel topicDeleteModel) async {
    try {
      var map = topicDeleteModel.toJson();
      Response response = await dioClient.post(
        AppConstants.TOPIC_DELETE_URI,
        data: map,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for save home address
  Future<void> saveHomeAddress(String homeAddress) async {
    try {
      await sharedPreferences.setString(AppConstants.HOME_ADDRESS, homeAddress);
    } catch (e) {
      throw e;
    }
  }

  String getHomeAddress() {
    return sharedPreferences.getString(AppConstants.HOME_ADDRESS) ?? "";
  }

  Future<bool> clearHomeAddress() async {
    return sharedPreferences.remove(AppConstants.HOME_ADDRESS);
  }

  // for save office address
  Future<void> saveOfficeAddress(String officeAddress) async {
    try {
      await sharedPreferences.setString(
          AppConstants.OFFICE_ADDRESS, officeAddress);
    } catch (e) {
      throw e;
    }
  }

  String getOfficeAddress() {
    return sharedPreferences.getString(AppConstants.OFFICE_ADDRESS) ?? "";
  }

  Future<bool> clearOfficeAddress() async {
    return sharedPreferences.remove(AppConstants.OFFICE_ADDRESS);
  }
}
