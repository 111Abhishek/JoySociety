
import 'package:joy_society/data/model/response/tribe_model.dart';

class TribeListResponseModel {
  int? count;
  String? next;
  String? previous;
  List<TribeModel>? data = <TribeModel>[];

  TribeListResponseModel({this.count, this.next, this.previous, this.data});

  factory TribeListResponseModel.fromJson(Map<String, dynamic> json) {
    return TribeListResponseModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        data: json['results'] != null ? (json['results'] as List).map((i) => TribeModel.fromJson(i)).toList() : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.data != null) {
      data['results'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}