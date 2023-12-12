import 'common_list_model.dart';

class UserBillingDetailModel {
  String? addressLine1;
  String? addressLine2;
  CommonListData? country;
  CommonListData? state;
  CommonListData? city;
  String? postCode;

  UserBillingDetailModel(
      {this.addressLine1,
      this.addressLine2,
      this.country,
      this.state,
      this.city,
      this.postCode});

  UserBillingDetailModel.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];

    country = json['country'] != null
        ? CommonListData.fromJson(json['country'])
        : null;
    state =
        json['state'] != null ? CommonListData.fromJson(json['state']) : null;
    city = json['city'] != null ? CommonListData.fromJson(json['city']) : null;
    postCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressLine1 != null && this.addressLine1!.isNotEmpty) {
      data['address_line_1'] = this.addressLine1;
    }
    if (this.addressLine2 != null && this.addressLine2!.isNotEmpty) {
      data['address_line_2'] = this.addressLine2;
    }
    if (this.country != null) {
      data['country'] = this.country?.id;
    }
    if (this.state != null) {
      data['state'] = this.state?.id;
    }
    if (this.city != null) {
      data['city'] = this.city?.id;
    }
    if (this.postCode != null && this.postCode!.isNotEmpty) {
      data['postal_code'] = this.postCode;
    }
    return data;
  }
}
