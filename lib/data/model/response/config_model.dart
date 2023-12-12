
class ConfigModel {
  BaseUrls? _baseUrls;
  bool? _maintenanceMode;
  String? _countryCode;
  String? _forgetPasswordVerification;
  bool? _phoneVerification;
  bool? _emailVerification;
  List<SocialLogin>? _socialLogin;

  ConfigModel(
  {
    BaseUrls? baseUrls,
    bool? maintenanceMode,
    String? countryCode,
    String? forgetPasswordVerification,
    bool? phoneVerification,
    bool? emailVerification,
    List<SocialLogin>? socialLogin,
  }) {
    this._baseUrls = baseUrls;
    this._maintenanceMode = maintenanceMode;
    this._countryCode = countryCode;
    this._forgetPasswordVerification = forgetPasswordVerification;
    this._phoneVerification = phoneVerification;
    this._emailVerification = emailVerification;
    this._socialLogin = socialLogin;
  }

  BaseUrls? get baseUrls => _baseUrls;
  bool? get maintenanceMode => _maintenanceMode;
  String? get countryCode => _countryCode;
  String? get forgetPasswordVerification => _forgetPasswordVerification;
  bool? get phoneVerification => _phoneVerification;
  bool? get emailVerification => _emailVerification;
  List<SocialLogin>? get socialLogin => _socialLogin;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    _maintenanceMode = json['maintenance_mode'];
    _countryCode = json['country_code'];
    _forgetPasswordVerification = json['forgot_password_verification'];
    _phoneVerification = json['phone_verification'];
    _emailVerification = json['email_verification'];
    if (json['social_login'] != null) {
      _socialLogin = [];
      json['social_login'].forEach((v) { _socialLogin?.add(new SocialLogin.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._baseUrls != null) {
      data['base_urls'] = this._baseUrls?.toJson();
      data['maintenance_mode'] = this._maintenanceMode;
      data['country_code'] = this._countryCode;
      data['forgot_password_verification'] = this._forgetPasswordVerification;
      data['phone_verification'] = this._phoneVerification;
      data['email_verification'] = this._emailVerification;
      if (this._socialLogin != null) {
        data['social_login'] = this._socialLogin?.map((v) => v.toJson()).toList();
      }
    }
    return data;
  }
}

class BaseUrls {
  String? _productImageUrl;
  String? _customerImageUrl;

  BaseUrls(
      {
        String? productImageUrl,
        String? customerImageUrl,
  }){
    this._productImageUrl = productImageUrl;
    this._customerImageUrl = customerImageUrl;
  }

  String? get productImageUrl => _productImageUrl;
  String? get customerImageUrl => _customerImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'];
    _customerImageUrl = json['customer_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_image_url'] = this._productImageUrl;
    data['customer_image_url'] = this._customerImageUrl;
    return data;
  }

}

class SocialLogin {
  String? _loginMedium;
  bool? _status;

  SocialLogin({String? loginMedium, bool? status}) {
    this._loginMedium = loginMedium;
    this._status = status;
  }

  String? get loginMedium => _loginMedium;
  bool get status => _status ?? false;

  SocialLogin.fromJson(Map<String, dynamic> json) {
    _loginMedium = json['login_medium'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login_medium'] = this._loginMedium;
    data['status'] = this._status;
    return data;
  }
}