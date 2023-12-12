class NotificationDataModel {
  String? _title;

  NotificationDataModel({String? title}) {
    _title = title;
  }

  String? get title => _title;

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(title: json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_title != null) {
      data['title'] = title;
    }
    return data;
  }
}
