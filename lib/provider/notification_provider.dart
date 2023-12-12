import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/notification/notification_response_list_model.dart';
import 'package:joy_society/data/model/response/notification/notification_response_model.dart';
import 'package:joy_society/data/repository/notification_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo notificationRepo;
  final SharedPreferences? sharedPreferences;

  NotificationProvider(
      {required this.notificationRepo, this.sharedPreferences});

  bool _isLoading = false;
  NotificationResponseListModel _notificationResponseModelList =
      NotificationResponseListModel();

  bool get isLoading => _isLoading;

  NotificationResponseListModel get notificationResponseModelList =>
      _notificationResponseModelList;

  Future<NotificationResponseListModel> getNotifications() async {
    notifyListeners();
    _isLoading = true;
    ApiResponse apiResponse = await notificationRepo.getNotifications();
    NotificationResponseListModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _notificationResponseModelList =
          NotificationResponseListModel.fromJson(apiResponse.response!.data);
      responseModel = _notificationResponseModelList;
    } else {
      responseModel = NotificationResponseListModel();
    }
    notifyListeners();
    return responseModel;
  }

  Future readNotification(int id, Function callback) async {
    notifyListeners();
    _isLoading = true;
    ApiResponse apiResponse = await notificationRepo.patchNotification(id);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      callback(true, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        // log(apiResponse.error.toString());
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
