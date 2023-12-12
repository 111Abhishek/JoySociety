import 'package:joy_society/data/model/response/workshop_profile_model.dart';

class WorkshopMemberModel {
  int _id = 0;
  WorkshopProfileModel? _user;

  WorkshopMemberModel({WorkshopProfileModel? user}) {
    _id = user?.id ?? 0;
    _user = user;
  }

  WorkshopProfileModel? get user => _user;
  int get id => _id;

  factory WorkshopMemberModel.fromJson(Map<String, dynamic> json) {
    return WorkshopMemberModel(
        user: json['user'] != null
            ? WorkshopProfileModel.fromJson(json['user'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_user != null) {
      data['user'] = _user!.toJson();
    }
    return data;
  }
}
