class NotificationResponseModel {
  int _id = 0;
  String? _profilePic;
  DateTime? _createdOn;
  DateTime? _updatedOn;
  bool? _isActive;
  String? _notify;
  String? _redirect;
  bool? _readStatus;
  dynamic _createdBy;
  dynamic _updatedBy;

  NotificationResponseModel(
      {required int id,
      String? profilePic,
      DateTime? createdOn,
      DateTime? updatedOn,
      bool? isActive,
      String? notify,
      String? redirect,
      bool? readStatus,
      dynamic createdBy,
      dynamic updatedBy}) {
    _id = id;
    _profilePic = profilePic;
    _createdOn = createdOn;
    _updatedOn = updatedOn;
    _isActive = isActive;
    _notify = notify;
    _redirect = redirect;
    _readStatus = readStatus;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
  }

  int get id => _id;

  String? get profilePic => _profilePic;

  DateTime? get createdOn => _createdOn;

  DateTime? get updatedOn => _updatedOn;

  bool? get isActive => _isActive;

  String? get notify => _notify;

  String? get redirect => _redirect;

  bool? get readStatus => _readStatus;

  set readStatus(bool? newStatus) {
    _readStatus = newStatus;
  }

  dynamic get createdBy => _createdBy;

  dynamic get updatedBy => _updatedBy;

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
        id: json['id'],
        profilePic: json['profile_pic'],
        createdOn: json['created_on'] != null
            ? DateTime.parse(json['created_on'])
            : DateTime.now(),
        updatedOn: json['updated_on'] != null
            ? DateTime.parse(json['updated_on'])
            : null,
        isActive: json['is_active'],
        notify: json['notify'],
        redirect: json['redirect'],
        readStatus: json['read_status'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    if (_profilePic != null) json['profile_pic'] = _profilePic;
    if (_createdOn != null) json['created_on'] = createdOn!.toIso8601String();
    if (_updatedOn != null) json['updated_on'] = updatedOn!.toIso8601String();
    if (_isActive != null) json['is_active'] = _isActive!;
    if (_notify != null) json['notify'] = _notify!;
    if (_readStatus != null) json['read_status'] = _readStatus!;
    if (_createdBy != null) json['created_by'] = _createdBy;
    if (_updatedBy != null) json['updated_by'] = _updatedBy;

    return json;
  }
}
