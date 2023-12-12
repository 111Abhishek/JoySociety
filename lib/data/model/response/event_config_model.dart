

import 'package:joy_society/data/model/response/event_frequency_model.dart';

class EventConfigModel {
  EventFrequencyModel? event_frequency;

  EventConfigModel({this.event_frequency});

  factory EventConfigModel.fromJson(Map<String, dynamic> json) {
    return EventConfigModel(
        event_frequency : json['event_frequency'] != null
          ? EventFrequencyModel.fromJson(json['event_frequency'])
          : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_frequency'] = this.event_frequency;
    return data;
  }
}