
import 'package:joy_society/data/model/response/goal_model.dart';

class GoalListResponseModel {
  int? count;
  String? next;
  String? previous;
  List<GoalModel>? data = <GoalModel>[];

  GoalListResponseModel({this.count, this.next, this.previous, this.data});

  factory GoalListResponseModel.fromJson(Map<String, dynamic> json) {
    return GoalListResponseModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        data: json['results'] != null ? (json['results'] as List).map((i) => GoalModel.fromJson(i)).toList() : null
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