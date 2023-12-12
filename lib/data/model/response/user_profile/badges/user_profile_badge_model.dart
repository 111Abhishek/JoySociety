class UserProfileBadgeModel {
  String? _type;
  String? _title;

  UserProfileBadgeModel({String? type, String? title}) {
    _type = type;
    _title = title;
  }

  String? get type => _type;
  String? get title => _title;

  factory UserProfileBadgeModel.fromJson(Map<String, dynamic> json) {
    return UserProfileBadgeModel(type: json['type'], title: json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_type != null) data['type'] = _type;
    if (_title != null) data['title'] = _title;

    return data;
  }
}
