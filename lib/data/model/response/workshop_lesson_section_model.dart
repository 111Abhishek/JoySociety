class WorkshopLessonSectionModel {
  int _id = 0;
  int? _order;
  String? _title;
  String? _detail;
  bool? _isDraft;

  WorkshopLessonSectionModel(
      {required int id,
      int? order,
      String? title,
      String? detail,
      bool? isDraft}) {
    _id = id;
    _order = order;
    _title = title;
    _detail = detail;
    _isDraft = isDraft;
  }

  int get id => _id;
  int? get order => _order;
  String? get title => _title;
  String? get detail => _detail;
  bool? get isDraft => _isDraft;

  factory WorkshopLessonSectionModel.fromJson(Map<String, dynamic> json) {
    return WorkshopLessonSectionModel(
        id: json['id'],
        order: json['order'],
        title: json['title'],
        detail: json['detail'],
        isDraft: json['is_draft']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (_order != null) {
      data['order'] = _order;
    }
    if (_title != null) {
      data['title'] = _title;
    }
    if (_detail != null) {
      data['detail'] = _detail;
    }
    if (_isDraft != null) {
      data['is_draft'] = _isDraft;
    }
    return data;
  }
}
