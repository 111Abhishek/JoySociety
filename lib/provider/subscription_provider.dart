import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/api_response.dart';
import '../data/model/response/base/error_response.dart';
import '../data/model/response/stripe_url_response.dart';
import '../data/model/response/subscription_model.dart';
import '../data/repository/subscription_repo.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepo subscriptionRepo;

  SubscriptionProvider({required this.subscriptionRepo});

  bool _isLoading = false;
  SubscriptionOptionsResponse _subscriptionResponse =
      SubscriptionOptionsResponse();

  bool get isLoading => _isLoading;
  SubscriptionOptionsResponse get subscriptionResponse => _subscriptionResponse;

  Future<SubscriptionOptionsResponse> getSubscriptionList() async {
    // _isLoading = true;
    //notifyListeners();

    ApiResponse apiResponse = await subscriptionRepo.getSubscription();
    _isLoading = false;

    SubscriptionOptionsResponse responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel =
          SubscriptionOptionsResponse.fromJson(apiResponse.response?.data);
    } else {
      responseModel = SubscriptionOptionsResponse();
    }
    _subscriptionResponse = responseModel;

    notifyListeners();
    return responseModel;
  }

  Future buySubscription(int productID, Function callback) async {
    // _isLoading = true;
    // notifyListeners();
    ApiResponse apiResponse = await subscriptionRepo.getStripeLink(productID);
    _isLoading = false;
    // notifyListeners();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      StripeUrlResponse? responseModel =
          StripeUrlResponse.fromJson(apiResponse.response?.data);
      callback(true, responseModel, null);
    } else {
      ErrorResponse errorResponse;
      if (apiResponse.error is String) {
        log(apiResponse.error.toString());
        errorResponse =
            ErrorResponse.setErrorDescription(apiResponse.error.toString());
      } else {
        errorResponse = apiResponse.error;
      }
      callback(false, null, errorResponse);
    }
  }
}
