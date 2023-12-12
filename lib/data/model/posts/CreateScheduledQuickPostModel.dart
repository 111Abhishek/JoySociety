class QuickPostRequestModel {
  String? _post;
  DateTime? _schedule;
  int? _topic;
  int? _tribe;
  int? _workshop;

  QuickPostRequestModel(
      {String? post,
      DateTime? schedule,
      int? topic,
      int? tribe,
      int? workshop}) {
    _post = post;
    _schedule = schedule;
    _topic = topic;
    _tribe = tribe;
    _workshop = workshop;
  }

  String? get post => _post;

  DateTime? get schedule => _schedule;

  int? get topic => _topic;

  int? get tribe => _tribe;

  int? get workshop => _workshop;

  factory QuickPostRequestModel.fromJson(Map<String, dynamic> json) {
    return QuickPostRequestModel(
        post: json['post'],
        schedule:
            json['schedule'] != null ? DateTime.parse(json['schedule']) : null,
        topic: json['topic'],
        tribe: json['tribe'],
        workshop: json['workshop']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    if (_post != null) json['post'] = _post;
    if (_schedule != null) json['schedule'] = _schedule!.toIso8601String();
    if (_topic != null) json['topic'] = _topic;
    if (_tribe != null) json['tribe'] = _tribe;
    if (_workshop != null) json['workshop'] = _workshop;

    return json;
  }
}
