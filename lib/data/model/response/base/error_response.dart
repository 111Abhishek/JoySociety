/// errors : [{"code":"l_name","message":"The last name field is required."},{"code":"password","message":"The password field is required."}]

class ErrorResponse {
  List<Errors>? _errors;
  List<String>? _non_field_errors;
  dynamic _errorJson;
  String? _errorDescription;


  List<Errors>? get errors => _errors;
  List<String>? get non_field_errors => _non_field_errors;
  dynamic get errorJson => _errorJson;
  String? get errorDescription => _errorDescription;

  ErrorResponse({
    List<Errors>? errors, List<String>? non_field_errors}) {
    _errors = errors;
    _non_field_errors = non_field_errors;
    _errorJson = errorJson;
  }

  ErrorResponse.fromJson(dynamic json) {
    if (json["errors"] != null) {
      _errors = [];
      json["errors"].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
    if (json["non_field_errors"] != null) {
      _non_field_errors = [];
      json["non_field_errors"].forEach((v) {
        _non_field_errors?.add(v);
      });
    }
    _errorJson = json;
  }

  ErrorResponse.setErrorDescription(String? errorDescription) {
    _errorDescription = errorDescription;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_errors != null) {
      map["errors"] = _errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// code : "l_name"
/// message : "The last name field is required."


class Errors {
  String? _code;
  String? _message;

  String? get code => _code;
  String? get message => _message;

  Errors({
    String? code,
    String? message}){
    _code = code;
    _message = message;
  }

  Errors.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    return map;
  }

}