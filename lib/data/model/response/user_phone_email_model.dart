class UserPhoneEmailModel {
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? currentPassword;
  String? newPassword;

  UserPhoneEmailModel({this.email, this.countryCode, this.phoneNumber});

  UserPhoneEmailModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    currentPassword = json['current_password'];
    newPassword = json['new_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.email != null && this.email!.isNotEmpty) {
      data['email'] = this.email;
    }
    if(this.countryCode != null && this.countryCode!.isNotEmpty) {
      data['country_code'] = this.countryCode;
    }
    if(this.phoneNumber != null && this.phoneNumber!.isNotEmpty) {
      data['phone_number'] = this.phoneNumber;
    }
    if(this.currentPassword != null && this.currentPassword!.isNotEmpty) {
      data['current_password'] = this.currentPassword;
    }
    if(this.newPassword != null && this.newPassword!.isNotEmpty) {
      data['new_password'] = this.newPassword;
    }
    return data;
  }
}
