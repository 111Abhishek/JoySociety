import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joy_society/data/model/response/address_model.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/response_model.dart';
import 'package:joy_society/data/model/response/user_billing_detail_model.dart';
import 'package:joy_society/data/model/response/user_info_model.dart';
import 'package:joy_society/data/model/response/user_phone_email_model.dart';
import 'package:joy_society/data/model/response/user_profile/badges/user_profile_badge_list_model.dart';
import 'package:joy_society/data/model/response/user_profile/profile_upload_image_model.dart';
import 'package:joy_society/data/repository/profile_repo.dart';
import 'package:joy_society/helper/api_checker.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/topic_delete_model.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo profileRepo;
  final SharedPreferences? sharedPreferences;

  ProfileProvider({required this.profileRepo, required this.sharedPreferences});

  List<String> _addressTypeList = [];
  String _addressType = '';
  UserInfoModel? _userInfoModel;
  UserPhoneEmailModel? _userPhoneEmailModel;
  UserBillingDetailModel? _userBillingDetailModel;
  ProfileUploadImageModel? _profileUploadImageModel;
  TopicDeleteModel? _topicDeleteModel;
  bool _isLoading = false;
  List<AddressModel> _addressList = [];
  List<AddressModel> _billingAddressList = [];
  List<AddressModel> _shippingAddressList = [];
  bool _hasData = true;
  bool _isHomeAddress = true;
  String _addAddressErrorText = "";

  UserProfileBadgeListModel? _userProfileBadgeListModel;

  List<String> get addressTypeList => _addressTypeList;

  String get addressType => _addressType;

  UserInfoModel? get userInfoModel => _userInfoModel;

  UserPhoneEmailModel? get userPhoneEmailModel => _userPhoneEmailModel;

  UserBillingDetailModel? get userBillingDetailModel => _userBillingDetailModel;

  ProfileUploadImageModel? get profileUploadImageModel =>
      _profileUploadImageModel;

  TopicDeleteModel? get topicDeleteModel => _topicDeleteModel;

  bool get isLoading => _isLoading;

  List<AddressModel> get addressList => _addressList;

  List<AddressModel> get billingAddressList => _billingAddressList;

  List<AddressModel> get shippingAddressList => _shippingAddressList;

  bool get hasData => _hasData;

  bool get isHomeAddress => _isHomeAddress;

  String get addAddressErrorText => _addAddressErrorText;

  ProfileModel? _profileModel;

  ProfileModel? get profileModel => _profileModel;

  UserProfileBadgeListModel? get userProfileBadgeListModel =>
      _userProfileBadgeListModel;

  void setAddAddressErrorText(String errorText) {
    _addAddressErrorText = errorText;
    // notifyListeners();
  }

  void updateAddressCondition(bool value) {
    _isHomeAddress = value;
    notifyListeners();
  }

  bool _checkHomeAddress = false;

  bool get checkHomeAddress => _checkHomeAddress;

  bool _checkOfficeAddress = false;

  bool get checkOfficeAddress => _checkOfficeAddress;

  void setHomeAddress() {
    _checkHomeAddress = true;
    _checkOfficeAddress = false;
    notifyListeners();
  }

  void setOfficeAddress() {
    _checkHomeAddress = false;
    _checkOfficeAddress = true;
    notifyListeners();
  }

  updateCountryCode(String value) {
    _addressType = value;
    notifyListeners();
  }

  Future<void> initAddressList(BuildContext context) async {
    ApiResponse apiResponse = await profileRepo.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _addressList = [];
      _billingAddressList = [];
      _shippingAddressList = [];
      apiResponse.response?.data.forEach((address) {
        AddressModel addressModel = AddressModel.fromJson(address);
        if (addressModel.isBilling == 1) {
          _billingAddressList.add(addressModel);
        } else if (addressModel.isBilling == 0) {
          _addressList.add(addressModel);
        }
        _shippingAddressList.add(addressModel);
      });
      // apiResponse.response.data.forEach((address) => _addressList.add(AddressModel.fromJson(address)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<String> getUserInfo(BuildContext context) async {
    String userID = '-1';
    ApiResponse apiResponse = await profileRepo.getUserInfo();
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response?.data);
      userID = _userInfoModel!.id.toString();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return userID;
  }

  void initAddressTypeList(BuildContext context) async {
    if (_addressTypeList.length == 0) {
      ApiResponse apiResponse = await profileRepo.getAddressTypeList();
      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        _addressTypeList.clear();
        _addressTypeList.addAll(apiResponse.response?.data);
        _addressType = apiResponse.response?.data[0];
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  // getting the badge information for the given user
  Future<UserProfileBadgeListModel> getUserBadges() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo.getProfileBadges();
    _isLoading = false;
    UserProfileBadgeListModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel =
          UserProfileBadgeListModel.fromJson(apiResponse.response?.data);
      _userProfileBadgeListModel = responseModel;
    } else {
      responseModel = UserProfileBadgeListModel();
    }
    notifyListeners();
    return responseModel;
  }

  Future addAddress(AddressModel addressModel, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await profileRepo.addAddress(addressModel);
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      Map map = apiResponse.response?.data;
      if (_addressList == null) {
        _addressList = [];
      }
      _addressList.add(addressModel);
      String message = map["message"];
      callback(true, message);
    } else {
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors?[0].message;
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  Future uploadImage(File file, String category, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await profileRepo.uploadImage(file, category);
    _isLoading = false;

    notifyListeners();

    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      ProfileUploadImageModel responseModel =
          ProfileUploadImageModel.fromJson(apiResponse.response?.data);
      _profileUploadImageModel = responseModel;
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

  Future<ResponseModel> updateUserInfo(
      UserInfoModel updateUserModel, File? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response =
        await profileRepo.updateUserInfo(updateUserModel, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

  //Profile Update
  Future updateProfile(ProfileModel profileModel, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await profileRepo.updateProfile(profileModel);
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      ProfileModel responseModel =
          ProfileModel.fromJson(apiResponse.response?.data);
      _profileModel = responseModel;
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

  //Get Profile data
  Future<ProfileModel?> getProfileData() async {
    //_isLoading = true;
    //notifyListeners();

    ApiResponse apiResponse = await profileRepo.getProfile();
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      ProfileModel responseModel =
          ProfileModel.fromJson(apiResponse.response?.data);
      _profileModel = responseModel;
      notifyListeners();
      return responseModel;
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      notifyListeners();
      return null;
    }
  }

// get email, phone no and password
  Future getUserPhoneAndEmail(Function callback) async {
    ApiResponse apiResponse = await profileRepo.getUserEmailPhoneDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response?.data;
      String email = '';
      String countryCode = '';
      String phoneNumber = '';
      try {
        email = map["email"];
        countryCode = map["country_code"];
        phoneNumber = map["phone_number"];
      } catch (e) {}
      _userPhoneEmailModel = UserPhoneEmailModel();
      _userPhoneEmailModel?.email = email;
      _userPhoneEmailModel?.countryCode = countryCode;
      _userPhoneEmailModel?.phoneNumber = phoneNumber;

      callback(true, _userPhoneEmailModel, null);
      notifyListeners();
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

// update email, phone no and password
  Future updateUserCredentials(
      UserPhoneEmailModel userCredModel, Function callback) async {
    ApiResponse apiResponse = await profileRepo.updateUserCred(userCredModel);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response?.data;
      String email = '';
      String countryCode = '';
      String phoneNumber = '';
      try {
        email = map["email"];
        countryCode = map["country_code"];
        phoneNumber = map["phone_number"];
      } catch (e) {}
      _userPhoneEmailModel = UserPhoneEmailModel();
      _userPhoneEmailModel?.email = email;
      _userPhoneEmailModel?.countryCode = countryCode;
      _userPhoneEmailModel?.phoneNumber = phoneNumber;

      try {
        sharedPreferences?.setString(AppConstants.USER_EMAIL, email);
        sharedPreferences?.setString(
            AppConstants.USER_PHONE_COUNTRY_CODE, countryCode);
        sharedPreferences?.setString(
            AppConstants.USER_PHONE_NUMBER, phoneNumber);
      } catch (e) {
        throw e;
      }

      callback(true, _userPhoneEmailModel, null);
      notifyListeners();
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

  Future<AppListingModel> getLocations(
      int page, String search, String uri) async {
    /*_isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';*/
    //notifyListeners();
    ApiResponse apiResponse =
        await profileRepo.getLocationsList(page, search, uri);
    //_isPhoneNumberVerificationButtonLoading = false;
    //notifyListeners();
    AppListingModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = AppListingModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = AppListingModel();
      /*String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors?[0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(errorMessage,false);
      _verificationMsg = errorMessage!;*/
    }
    //notifyListeners();
    return responseModel;
  }

  Future<AppListingModel> getCountryList(
      int page, String search, String uri) async {
    ApiResponse apiResponse =
        await profileRepo.getCountryList(page, search, uri);
    AppListingModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = AppListingModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = AppListingModel();
    }
    return responseModel;
  }

  Future<AppListingModel> getStateList(
      int page, String search, int? countryId, String uri) async {
    ApiResponse apiResponse =
        await profileRepo.getStateList(page, search, countryId, uri);
    AppListingModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = AppListingModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = AppListingModel();
    }
    return responseModel;
  }

  Future<AppListingModel> getCityList(
      int page, String search, int? stateId, String uri) async {
    ApiResponse apiResponse =
        await profileRepo.getCityList(page, search, stateId, uri);
    AppListingModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = AppListingModel.fromJson(apiResponse.response?.data);
    } else {
      responseModel = AppListingModel();
    }
    return responseModel;
  }

  // get Billing details
  Future<UserBillingDetailModel?> getBillingDetail() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo.getBillingDetails();
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      UserBillingDetailModel userBillingDetailModel =
          UserBillingDetailModel.fromJson(apiResponse.response?.data);
      _userBillingDetailModel = userBillingDetailModel;
      notifyListeners();
      return userBillingDetailModel;
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      notifyListeners();
      return null;
    }
  }

  // post billing details
  Future saveBillingDetail(
      UserBillingDetailModel userBillingDetailModel, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await profileRepo.saveBillingDetail(userBillingDetailModel);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      UserBillingDetailModel responseModel =
          UserBillingDetailModel.fromJson(apiResponse.response?.data);
      _userBillingDetailModel = responseModel;
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

  // save office and home address
  void saveHomeAddress(String homeAddress) {
    profileRepo.saveHomeAddress(homeAddress).then((_) {
      notifyListeners();
    });
  }

  void saveOfficeAddress(String officeAddress) {
    profileRepo.saveOfficeAddress(officeAddress).then((_) {
      notifyListeners();
    });
  }

  // for home Address Section
  String getHomeAddress() {
    return profileRepo.getHomeAddress();
  }

  Future<bool> clearHomeAddress() async {
    return await profileRepo.clearHomeAddress();
  }

  // for office Address Section
  String getOfficeAddress() {
    return profileRepo.getOfficeAddress();
  }

  Future<bool> clearOfficeAddress() async {
    return await profileRepo.clearOfficeAddress();
  }
}
