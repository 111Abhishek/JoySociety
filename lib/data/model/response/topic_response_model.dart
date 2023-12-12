
import 'package:joy_society/data/model/response/topic_model.dart';

class TopicResponseModel {
  int? count;
  String? next;
  String? previous;
  List<TopicModel>? data = <TopicModel>[];

  TopicResponseModel({this.count, this.next, this.previous, this.data});

  factory TopicResponseModel.fromJson(Map<String, dynamic> json) {
    return TopicResponseModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        data: json['results'] != null ? (json['results'] as List).map((i) => TopicModel.fromJson(i)).toList() : null
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