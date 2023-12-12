class ChannelInfoModel {
  int _id = 0;
  List<dynamic>? _users;
  dynamic? _tribe;
  int? _workshop;
  dynamic? _event;

  ChannelInfoModel(
      {required int id,
      List<dynamic>? users,
      dynamic? tribe,
      int? workshop,
      dynamic? event}) {
    _id = id;
    _users = users;
    _tribe = tribe;
    _workshop = workshop;
    _event = event;
  }

  int get id => _id;
  List<dynamic>? get users => _users;
  dynamic? get tribe => _tribe;
  int? get workshop => _workshop;
  dynamic? get event => _event;

  factory ChannelInfoModel.fromJson(Map<String, dynamic> json) {
    return ChannelInfoModel(
        id: json['id'],
        users: json['users'] != null ? (json['users'] as List) : null,
        tribe: json['tribe'],
        workshop: json['workshop'],
        event: json['event']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    if (_users != null) {
      data['users'] = _users;
    }
    if (_tribe != null) {
      data['tribe'] = _tribe;
    }
    if (_workshop != null) {
      data['workshop'] = _workshop;
    }
    if (_event != null) {
      data['event'] = _event;
    }
    return data;
  }
}
