import 'dart:convert';

import 'package:joy_society/data/model/notification/notification_data_model.dart';
import 'package:joy_society/data/model/notification/notification_meta_model.dart';

class NotificationBodyModel {
  String _event = "";
  NotificationDataModel? _data;
  NotificationMetaModel? _meta;

  NotificationBodyModel(
      {required String event,
      NotificationDataModel? data,
      NotificationMetaModel? meta}) {
    _event = event;
    _data = data;
    _meta = meta;
  }

  String get event => _event;
  NotificationDataModel? get data => _data;
  NotificationMetaModel? get meta => _meta;

  factory NotificationBodyModel.fromJson(Map<String, dynamic> jsonData) {
    print("NotificationBodyModel $jsonData");

    // print(jsonDecode(jsonData['data']));

    return NotificationBodyModel(
        event: jsonData['event'],
        data: jsonData['data'] != null
            ? NotificationDataModel.fromJson(jsonData['data'])
            : null,
        meta: jsonData['meta'] != null
            ? NotificationMetaModel.fromJson(jsonData['meta'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['event'] = event;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    if (meta != null) {
      json['meta'] = meta!.toJson();
    }
    return json;
  }
}
