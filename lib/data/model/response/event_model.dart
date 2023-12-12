class EventModel {
  int _id = 0;
  String? _title;
  String? _start_datetime;
  String? _end_datetime;
  bool? _repeat_event;
  String? _event_type;
  String? _workshop;
  int? _topic;
  String? _event_image;
  String? _description;
  String? _zoom_link;
  int? _going;
  int? _notGoing;
  int? _mayBe;
  String? _userStatus;

  EventModel({
    required int id,
    String? title,
    String? start_datetime,
    String? end_datetime,
    bool? repeat_event,
    String? event_type,
    String? workshop,
    int? topic,
    String? event_image,
    String? description,
    String? zoom_link,
    int? going,
    int? NotGoing,
    int? mayBe,
    String? userStatus,
  }) {
    this._id = id;
    this._title = title;
    this._start_datetime = start_datetime;
    this._end_datetime = end_datetime;
    this._repeat_event = repeat_event;
    this._event_type = event_type;
    this._workshop = workshop;
    this._topic = topic;
    this._event_image = event_image;
    this._description = description;
    this._zoom_link = zoom_link;
    this._going = going;
    this._userStatus = userStatus;
    this._notGoing = NotGoing;
    this._mayBe = _mayBe;
  }

  int get id => _id;
  String? get title => _title ?? "";
  String? get start_datetime => _start_datetime;
  String? get end_datetime => _end_datetime ?? "";
  bool? get repeat_event => _repeat_event;
  String? get event_type => _event_type ?? "";
  String? get workshop => _workshop;
  int? get topic => _topic;
  String? get event_image => _event_image;
  String? get description => _description;
  String? get zoom_link => _zoom_link;
  int get going => _going ?? 0;
  String get userStatus => _userStatus ?? "";
  int? get NotGoing => _notGoing ?? 0;
  int? get mayBE => _mayBe ?? 0;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      start_datetime: json['start_datetime'],
      end_datetime: json['end_datetime'],
      repeat_event: json['repeat_event'],
      event_type: json['event_type'],
      workshop: json['workshop'],
      topic: json['topic'],
      event_image: json['event_image'],
      description: json['description'],
      zoom_link: json['zoom_link'],
      going: json['going'],
      userStatus: json["user_status"],
      NotGoing: json['notGoing'],
      mayBe: json["maybe"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._id != null) {
      data['id'] = this.id;
    }
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
    if (this._workshop != null) {
      data['workshop'] = this._workshop;
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
