import 'dart:convert';

import 'package:http/http.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/extensions/int_extensions.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map buildHeader() {
  final SharedPreferences? sharedPreferences = SharedPreferences.getInstance() as SharedPreferences?;
  String? token = sharedPreferences?.getString(AppConstants.TOKEN);
  return {
    'Content-Type': 'application/json',
    'Authorization': 'Token $token',
  };
}

Future<Response> getRequest(String endPoint) async {
  try {
    if (!await isNetworkAvailable()) throw AppConstants.noInternetMsg;

    //String url = '$baseURL$endPoint';
    String url = AppConstants.BASE_URL + endPoint;

    Response response = await get(Uri.parse(url)).timeout(Duration(seconds: AppConstants.timeoutDuration), onTimeout: (() => throw "Please try again"));

    print('Code: ${response.statusCode} $url');
    print(response.body);
    return response;
  } catch (e) {
    print(e);
    if (!await isNetworkAvailable()) {
      throw AppConstants.noInternetMsg;
    } else {
      throw "Please try again";
    }
  }
}

Future<Response> postRequest(String endPoint, body) async {
  try {
    if (!await isNetworkAvailable()) throw AppConstants.noInternetMsg;

    String url = AppConstants.BASE_URL + endPoint;

    print('URL: $url');
    print('Request: $body');

    Response response = await post(Uri.parse(url), body: jsonEncode(body)).timeout(Duration(seconds: AppConstants.timeoutDuration), onTimeout: (() => throw "Please try again"));

    print('Status: ${response.statusCode} $url $body');
    print(response.body);
    return response;
  } catch (e) {
    print(e);
    if (!await isNetworkAvailable()) {
      throw AppConstants.noInternetMsg;
    } else {
      throw "Please try again";
    }
  }
}

Future<Response> putRequest(String endPoint, body) async {
  try {
    if (!await isNetworkAvailable()) throw AppConstants.noInternetMsg;

    String url = AppConstants.BASE_URL + endPoint;

    print('URL: $url');
    print('Request: $body');

    Response response = await put(Uri.parse(url), body: jsonEncode(body)).timeout(Duration(seconds: AppConstants.timeoutDuration), onTimeout: (() => throw "Please try again"));

    print('Status: ${response.statusCode} $url $body');
    print(response.body);
    return response;
  } catch (e) {
    print(e);
    if (!await isNetworkAvailable()) {
      throw AppConstants.noInternetMsg;
    } else {
      throw "Please try again";
    }
  }
}

Future<Response> deleteRequest(String endPoint) async {
  try {
    if (!await isNetworkAvailable()) throw AppConstants.noInternetMsg;

    String url = AppConstants.BASE_URL + endPoint;

    Response response = await post(Uri.parse(url)).timeout(Duration(seconds: AppConstants.timeoutDuration), onTimeout: (() => throw "Please try again"));

    print('Code: ${response.statusCode} $url');
    print(response.body);
    return response;
  } catch (e) {
    print(e);
    if (!await isNetworkAvailable()) {
      throw AppConstants.noInternetMsg;
    } else {
      throw "Please try again";
    }
  }
}

Future handleResponse(Response response) async {
  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    if (response.body.isJson()) {
      throw jsonDecode(response.body);
    } else {
      if (!await isNetworkAvailable()) {
        throw AppConstants.noInternetMsg;
      } else {
        throw 'Please try again';
      }
    }
  }
}
