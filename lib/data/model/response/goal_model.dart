
import 'package:joy_society/data/model/response/common_list_model.dart';

class GoalModel {
  int? _id;
  String? _status;
  String? _created_on;
  CommonListData? _sphere;

  GoalModel(
      {
        int? id,
        String? status,
        String? created_on,
        CommonListData? sphere}) {
    this._id = id;
    this._status = status;
    this._created_on = created_on;
    this._sphere = sphere;
  }

  int? get id => _id;
  String? get status => _status ?? "";
  String? get created_on => _created_on;
  CommonListData? get sphere => _sphere;

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id : json['id'],
      status : json['status'],
      created_on : json['created_on'],
      sphere : json['sphere'] != null ? CommonListData.fromJson(json['sphere']) : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._id != null) {
      data['id'] = this._id;
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