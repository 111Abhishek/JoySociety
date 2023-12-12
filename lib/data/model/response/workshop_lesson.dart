import 'package:joy_society/data/model/response/workshop_lesson_section_model.dart';

class WorkshopLessonModel {
  int _id = 0;
  String? _title;
  int? _workshopId;
  String? _contentType;
  String? _detail;
  bool? _isDraft;
  List<WorkshopLessonSectionModel>? _sections;

  WorkshopLessonModel(
      {required int id,
      String? title,
      int? workshopId,
      String? contentType,
      String? detail,
      bool? isDraft,
      List<WorkshopLessonSectionModel>? sections}) {
    _id = id;
    _title = title;
    _workshopId = workshopId;
    _detail = detail;
    _isDraft = isDraft;
    _sections = sections;
    _contentType = contentType;
  }

  int get id => _id;
  String? get title => _title;
  String? get contentType => _contentType;
  String? get detail => _detail;
  int? get workshopId => _workshopId;
  bool? get isDraft => _isDraft;
  List<WorkshopLessonSectionModel>? get sections => _sections;

  factory WorkshopLessonModel.fromJson(Map<String, dynamic> json) {
    return WorkshopLessonModel(
        id: json['id'],
        title: json['title'],
        workshopId: json['workshop'],
        contentType: json['content_type'],
        detail: json['detail'],
        isDraft: json['is_draft'],
        sections: json['sections'] != null
            ? (json['sections'] as List)
                .map((section) => WorkshopLessonSectionModel.fromJson(section))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;

    if (_title != null) {
      data['title'] = _title;
    }

    if (_contentType != null) {
      data['content_type'] = _contentType;
    }

    if (_workshopId != null) {
      data['workshop'] = _workshopId;
    }

    if (_isDraft != null) {
      data['is_draft'] = _isDraft;
    }

    if (_sections != null) {
      data['sections'] = _sections!.map((e) => e.toJson()).toList();
    }

  if (_detail != null) {
      data['detail'] = _detail;
    }

    return data;
  }
}
