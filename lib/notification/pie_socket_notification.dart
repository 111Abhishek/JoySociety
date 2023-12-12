import 'dart:convert';

import 'package:joy_society/data/model/notification/notification_data_model.dart';
import 'package:joy_society/data/model/notification/notification_model.dart';
import 'package:piesocket_channels/channels.dart';

class PieSocketNotification {
  final String clusterId;
  final String apiKey;
  final String roomId;
  Channel? channel;

  PieSocketNotification(
      {required this.apiKey, required this.clusterId, required this.roomId}) {
    PieSocketOptions options = PieSocketOptions();
    options.setClusterId(clusterId);
    options.setApiKey(apiKey);
    PieSocket pieSocket = PieSocket(options);
    channel = pieSocket.join(roomId);
  }

  String? getDetails(NotificationDataModel? data) {
    if (data != null && data.title != null && data.title!.isNotEmpty) {
      return data.title;
    }
    return null;
  }
}
