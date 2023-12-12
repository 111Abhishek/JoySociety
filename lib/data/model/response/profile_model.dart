import 'package:joy_society/data/model/response/common_list_model.dart';

class ProfileModel {
  int? _id;
  String? _fullName;
  String? _profilePic;
  String? _miniBio;
  CommonListData? _location;
  CommonListData? _timezone;
  List<String>? _personalLinks;
  String? _isSubscribed;
  int? _userId;

  ProfileModel({
    int? id,
    String? fullName,
    String? profilePic,
    String? miniBio,
    CommonListData? location,
    CommonListData? timezone,
    String? isSubscribed,
    List<String>? personalLinks,
    int? userId,
  }) {
    this._id = id;
    this._fullName = fullName;
    this._profilePic = profilePic;
    this._miniBio = miniBio;
    this._location = location;
    this._timezone = timezone;
    this._personalLinks = personalLinks;
    this._isSubscribed = isSubscribed;
    this._userId = userId;
  }

  int? get id => _id;
  String? get fullName => _fullName;
  String? get profilePic => _profilePic;
  String? get miniBio => _miniBio;
  CommonListData? get location => _location;
  CommonListData? get timezone => _timezone;
  List<String>? get personalLinks => _personalLinks;
  String? get isSubscribed => _isSubscribed;
  int? get userId => _userId;
  ProfileModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fullName = json['full_name'];
    _profilePic = json['profile_pic'];
    _miniBio = json['mini_bio'];
    _userId = json['user_id'];
    _isSubscribed = json['membership_completion'];
    _location = json['location'] != null
        ? CommonListData.fromJson(json['location'])
        : null;
    _timezone = json['timezone'] != null
        ? CommonListData.fromJson(json['timezone'])
        : null;
    if (json['personal_links'] != null) {
      _personalLinks = [];
      _personalLinks = json['personal_links'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['full_name'] = this.fullName;
    data['profile_pic'] = this.profilePic;
    data['mini_bio'] = this.miniBio;
    if (this._location != null) {
      data['location'] = this._location?.id;
    }
    if (this._timezone != null) {
      data['timezone'] = this._timezone?.id;
    }
    if (this._personalLinks != null) {
      data['personal_links'] = this._personalLinks;
    }
    return data;
  }
}
