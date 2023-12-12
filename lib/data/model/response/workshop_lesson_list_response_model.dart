import 'package:joy_society/data/model/response/workshop_lesson.dart';

class WorkshopLessonListResponseModel {
  int? count;
  String? next;
  String? previous;
  List<WorkshopLessonModel>? data = <WorkshopLessonModel>[];

  WorkshopLessonListResponseModel(
      {this.count, this.next, this.previous, this.data});

  factory WorkshopLessonListResponseModel.fromJson(Map<String, dynamic> json) {
    return WorkshopLessonListResponseModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        data: json['results'] != null
            ? (json['results'] as List)
                .map((lesson) => WorkshopLessonModel.fromJson(lesson))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (this.data != null) {
      data['results'] = this.data!.map((element) => element.toJson()).toList();
    }
    return data;
  }
}
