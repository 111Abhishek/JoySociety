class NotificationMetaModel {
  String? _url;

  NotificationMetaModel({String? url}) {
    _url = url;
  }

  String? get url => _url;

  factory NotificationMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationMetaModel(url: json['url']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (url != null) {
      data['url'] = url;
    }
    return data;
  }
}
