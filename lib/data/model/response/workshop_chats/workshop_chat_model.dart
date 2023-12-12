import 'package:joy_society/data/model/response/workshop_chats/channel_info_model.dart';
import 'package:joy_society/data/model/response/workshop_profile_model.dart';

class ChatModel {
  int _id = 0;
  ChannelInfoModel? _channelInfo;
  String? _message;
  WorkshopProfileModel? _sender;
  String? _timestamp;
  List<WorkshopProfileModel>? _readers;
  bool _author = false;

  ChatModel(
      {required int id,
      ChannelInfoModel? channelInfo,
      String? message,
      WorkshopProfileModel? sender,
      String? timestamp,
      List<WorkshopProfileModel>? readers,
      bool? author}) {
    _id = id;
    _channelInfo = channelInfo;
    _message = message;
    _sender = sender;
    _timestamp = timestamp;
    _readers = readers;
    _author = author ?? false;
  }

  int get id => _id;
  String get message => _message ?? "";
  ChannelInfoModel? get channelInfo => _channelInfo;
  String? get timestamp => _timestamp;
  WorkshopProfileModel? get sender => _sender;
  List<WorkshopProfileModel>? get readers => _readers;
  bool get author => _author;

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        id: json['id'],
        channelInfo: json['channel'] != null
            ? ChannelInfoModel.fromJson(json['channel'])
            : null,
        message: json['message'],
        sender: json['sender'] != null
            ? WorkshopProfileModel.fromJson(json['sender'])
            : null,
        timestamp: json['timestamp'],
        readers: json['read'] != null
            ? (json['read'] as List)
                .map((user) => WorkshopProfileModel.fromJson(user))
                .toList()
            : null,
        author: json['author'] ?? false);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    if (_channelInfo != null) {
      data['channel'] = _channelInfo!.toJson();
    }
    if (_message != null) {
      data['message'] = _message;
    }
    if (_sender != null) {
      data['sender'] = _sender!.toJson();
    }
    if (_readers != null) {
      data['read'] = _readers!.map((reader) => reader.toJson()).toList();
    }
    data['author'] = _author;
    if (_timestamp != null) {
      data['timestamp'] = _timestamp;
    }
    return data;
  }
}
