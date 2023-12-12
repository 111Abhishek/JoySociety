import 'dart:convert';

import 'package:joy_society/data/model/notification/notification_body_model.dart';

class NotificationModel {
  String _event = '';
  NotificationBodyModel? _data;
  String? _meta;

  NotificationModel(
      {required String event, NotificationBodyModel? data, String? meta}) {
    _event = event;
    _data = data;
    _meta = meta;
  }

  String get event => _event;
  NotificationBodyModel? get data => _data;
  String? get meta => _meta;

  factory NotificationModel.fromJson(Map<String, dynamic> jsonVal) {
    Map<String, dynamic>? d;
    NotificationBodyModel? model;
    if (jsonVal['data'] != null) {
      d = json.decode(jsonVal['data']);
      model = NotificationBodyModel.fromJson(d!);
      print(model.event);
    }
    return NotificationModel(
        event: jsonVal['event'], data: model, meta: jsonVal['meta']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['event'] = event;
    if (data != null) {
      json['data'] = data!.toJson();
    }

    if (meta != null) {
      json['meta'] = meta;
    }

    return json;
  }
}
