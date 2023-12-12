
import 'package:joy_society/data/model/response/event_config_model.dart';
import 'package:joy_society/data/model/response/event_frequency_model.dart';

class CreateEventModel {
  String? _title;
  String? _start_datetime;
  String? _end_datetime;
  bool? _repeat_event;
  String? _event_type;
  EventConfigModel? _event_config = EventConfigModel();
  int? _topic;
  String? _event_image;
  String? _description;
  String? _zoom_link;

  CreateEventModel(
      {
        String? title,
        String? start_datetime,
        String? end_datetime,
        bool? repeat_event,
        String? event_type,
        EventConfigModel? event_config,
        int? topic,
        String? event_image,
        String? description,
        String? zoom_link
      }) {
    this._title = title;
    this._start_datetime = start_datetime;
    this._end_datetime = end_datetime;
    this._repeat_event = repeat_event;
    this._event_type = event_type;
    this._event_config = event_config;
    this._topic = topic;
    this._event_image = event_image;
    this._description = description;
    this._zoom_link = zoom_link;
  }

  String? get title => _title ?? "";
  String? get start_datetime => _start_datetime;
  String? get end_datetime => _end_datetime ?? "";
  bool? get repeat_event => _repeat_event;
  String? get event_type => _event_type ?? "ONLINE";
  EventConfigModel? get event_config => _event_config;
  int? get topic => _topic;
  String? get event_image => _event_image;
  String? get description => _description;
  String? get zoom_link => _zoom_link;

  factory CreateEventModel.fromJson(Map<String, dynamic> json) {
    return CreateEventModel(
        title : json['title'],
        start_datetime : json['start_datetime'],
        end_datetime : json['end_datetime'],
        repeat_event : json['repeat_event'],
        event_type : json['event_type'],
        event_config : json['event_config'] != null
            ? EventConfigModel.fromJson(json['event_config'])
            : null,
        topic : json['topic'],
        event_image : json['event_image'],
        description : json['description'],
        zoom_link : json['zoom_link']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._title != null) {
      data['title'] = this._title;
    }
    if (this._start_datetime != null) {
      data['start_datetime'] = this._start_datetime;
    }
    if (this._end_datetime != null) {
      data['end_datetime'] = this._end_datetime;
    }
    if (this._repeat_event != null) {
      data['repeat_event'] = this._repeat_event;
    }
    if (this._event_type != null) {
      data['event_type'] = this._event_type;
    }
    if (this._event_config != null) {
      data['event_config'] = this._event_config;
    }
    if (this._topic != null) {
      data['topic'] = this._topic;
    }
    if (this._event_image != null) {
      data['event_image'] = this._event_image;
    }
    if (this._description != null) {
      data['description'] = this._description;
    }
    if (this._zoom_link != null) {
      data['zoom_link'] = this._zoom_link;
    }
    return data;
  }
}