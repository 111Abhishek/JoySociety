import 'package:joy_society/data/model/response/user_profile/badges/user_profile_badge_model.dart';

class UserProfileBadgeListModel {
  bool? _status;
  List<UserProfileBadgeModel>? _data;

  UserProfileBadgeListModel({bool? status, List<UserProfileBadgeModel>? data}) {
    _status = status;
    _data = data;
  }

  bool? get status => _status;
  List<UserProfileBadgeModel>? get data => _data;

  factory UserProfileBadgeListModel.fromJson(Map<String, dynamic> json) {
    return UserProfileBadgeListModel(
        status: json['status'],
        data: json['data'] != null
            ? (json['data'] as List)
                .map((element) => UserProfileBadgeModel.fromJson(element))
                .toList()
            : []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_status != null) {
      data['status'] = _status;
    }

    if (_data != null) {
      data['data'] = _data!.map((badge) => badge.toJson()).toList();
    }

    return data;
  }
}
