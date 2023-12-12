
import 'package:joy_society/data/model/response/invited_by_model.dart';

class SentInvitesModel {
  int _id = 0;
  String? _first_name;
  String? _last_name;
  String? _email;
  int? _role;
  String? _status;
  String? _created_on;
  InvitedByModel? _invited_by;

  SentInvitesModel(
      {
        required int id,
        String? first_name,
        String? last_name,
        String? email,
        int? role,
        String? status,
        String? created_on,
        InvitedByModel? invited_by}) {
    this._id = id;
    this._first_name = first_name;
    this._last_name = last_name;
    this._email = email;
    this._role = role;
    this._status = status;
    this._created_on = created_on;
    this._invited_by = invited_by;
  }

  int get id => _id;
  String? get first_name => _first_name ?? "";
  String? get last_name => _last_name;
  String? get email => _email ?? "";
  int? get role => _role;
  String? get status => _status ?? "";
  String? get created_on => _created_on;
  InvitedByModel? get invited_by => _invited_by;

  factory SentInvitesModel.fromJson(Map<String, dynamic> json) {
    return SentInvitesModel(
        id : json['id'],
        first_name : json['first_name'],
        last_name : json['last_name'],
        email : json['email'],
        role : json['role'],
        status : json['status'],
        created_on : json['created_on'],
        invited_by : json['invited_by'] != null ? InvitedByModel.fromJson(json['invited_by']) : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._id != null) {
      data['id'] = this.id;
    }
    if (this._first_name != null) {
      data['first_name'] = this._first_name;
    }
    if (this._last_name != null) {
      data['last_name'] = this._last_name;
    }
    if (this._email != null) {
      data['email'] = this._email;
    }
    if (this._role != null) {
      data['role'] = this._role;
    }
    if (this._status != null) {
      data['status'] = this._status;
    }
    if (this._created_on != null) {
      data['created_on'] = this._created_on;
    }
    return data;
  }
}