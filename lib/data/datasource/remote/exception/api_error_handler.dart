import 'package:dio/dio.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';

class ApiErrorHandler {
  static ErrorResponse getMessage(error) {
    //dynamic errorDescription = "";
    ErrorResponse errorResponse = ErrorResponse();
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              errorResponse = ErrorResponse.setErrorDescription("Request to API server was cancelled");
              break;
            case DioErrorType.connectTimeout:
              errorResponse = ErrorResponse.setErrorDescription("Connection timeout with API server");
              break;
            case DioErrorType.other:
              errorResponse = ErrorResponse.setErrorDescription("Connection to API server failed due to internet connection");
              break;
            case DioErrorType.receiveTimeout:
              errorResponse = ErrorResponse.setErrorDescription("Receive timeout in connection with API server");
              break;
            case DioErrorType.response:
              switch (error.response?.statusCode) {
                case 404:
                case 500:
                case 503:
                  errorResponse = ErrorResponse.setErrorDescription(error.response?.statusMessage);
                  break;
                default:
                  errorResponse = ErrorResponse.fromJson(error.response?.data);
              /*if ((errorResponse.errors != null && errorResponse.errors!.length > 0)
                      || (errorResponse.non_field_errors != null && errorResponse.non_field_errors!.length > 0))
                    errorDescription = errorResponse;
                  else
                    errorDescription =
                    "Failed to load data - status code: ${error.response?.statusCode}";*/
              }
              break;
            case DioErrorType.sendTimeout:
              errorResponse = ErrorResponse.setErrorDescription("Send timeout with server");
              break;
          }
        } else {
          errorResponse = ErrorResponse.setErrorDescription("Unexpected error occurred");
        }
      } on FormatException catch (e) {
        errorResponse = ErrorResponse.setErrorDescription(e.toString());
      }
    } else {
      errorResponse = ErrorResponse.setErrorDescription("is not a subtype of exception");
    }
    return errorResponse;
  }
}