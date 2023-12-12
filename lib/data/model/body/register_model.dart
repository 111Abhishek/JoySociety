class RegisterModel {
  String? email;
  String? password;
  String? fullName;
  String? countryCode;
  String? phoneNumber;
  String? socialId;
  String? loginMedium;
  bool? tnc;
  String? memberShipCompletion;
  String? purchaseEmail;
  String? invitationGroupOrPartner;

  RegisterModel({
    this.email,
    this.password,
    this.fullName,
    this.countryCode,
    this.phoneNumber,
    this.socialId,
    this.loginMedium,
    this.tnc,
    this.memberShipCompletion,
    this.purchaseEmail,
    this.invitationGroupOrPartner,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    countryCode = json['country_code'];
    password = json['password'];
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    socialId = json['social_id'];
    loginMedium = json['login_medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['phone_number'] = this.phoneNumber;
    data['social_id'] = this.socialId;
    data['login_medium'] = this.loginMedium;
    data['tnc'] = this.tnc;
    data['membership_completion'] = this.memberShipCompletion;
    data['purchase_email'] = this.purchaseEmail;
    data['invite_group_or_partner'] = this.invitationGroupOrPartner;

    return data;
  }
}
