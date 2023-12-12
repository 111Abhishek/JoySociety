
import 'package:joy_society/data/model/response/workshop_model.dart';

class WorkshopListResponseModel {
  int? count;
  String? next;
  String? previous;
  List<WorkshopModel>? data = <WorkshopModel>[];

  WorkshopListResponseModel({this.count, this.next, this.previous, this.data});

  factory WorkshopListResponseModel.fromJson(Map<String, dynamic> json) {
    return WorkshopListResponseModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        data: json['results'] != null ? (json['results'] as List).map((i) => WorkshopModel.fromJson(i)).toList() : null
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