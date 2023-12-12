// To parse this JSON data, do
//
//     final channelResponse = channelResponseFromJson(jsonString);

import 'dart:convert';

ChannelResponse channelResponseFromJson(String str) => ChannelResponse.fromJson(json.decode(str));

String channelResponseToJson(ChannelResponse data) => json.encode(data.toJson());

class ChannelResponse {
    int? id;
    List<dynamic>? users;
    dynamic tribe;
    dynamic workshop;
    int? event;

    ChannelResponse({
        this.id,
        this.users,
        this.tribe,
        this.workshop,
        this.event,
    });

    factory ChannelResponse.fromJson(Map<String, dynamic> json) => ChannelResponse(
        id: json["id"],
        users: List<dynamic>.from(json["users"].map((x) => x)),
        tribe: json["tribe"],
        workshop: json["workshop"],
        event: json["event"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "users": List<dynamic>.from(users!.map((x) => x)),
        "tribe": tribe,
        "workshop": workshop,
        "event": event,
    };
}
