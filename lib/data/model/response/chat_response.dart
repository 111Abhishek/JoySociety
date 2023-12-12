// To parse this JSON data, do
//
//     final chatResponse = chatResponseFromJson(jsonString);

import 'dart:convert';

List<ChatResponse> chatResponseFromJson(String str) => List<ChatResponse>.from(json.decode(str).map((x) => ChatResponse.fromJson(x)));

String chatResponseToJson(List<ChatResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatResponse {
    int? id;
    Channel? channel;
    String? message;
    Sender? sender;
    DateTime? timestamp;
    List<Sender>? read;
    bool? author;

    ChatResponse({
        this.id,
        this.channel,
        this.message,
        this.sender,
        this.timestamp,
        this.read,
        this.author,
    });

    factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        id: json["id"],
        channel: Channel.fromJson(json["channel"]),
        message: json["message"],
        sender: Sender.fromJson(json["sender"]),
        timestamp: DateTime.parse(json["timestamp"]),
        read: List<Sender>.from(json["read"].map((x) => Sender.fromJson(x))),
        author: json["author"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "channel": channel!.toJson(),
        "message": message,
        "sender": sender!.toJson(),
        "timestamp": timestamp!.toIso8601String(),
        "read": List<dynamic>.from(read!.map((x) => x.toJson())),
        "author": author,
    };
}

class Channel {
    int? id;
    List<dynamic>? users;
    dynamic tribe;
    dynamic workshop;
    int? event;

    Channel({
        this.id,
        this.users,
        this.tribe,
        this.workshop,
        this.event,
    });

    factory Channel.fromJson(Map<String, dynamic> json) => Channel(
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

class Sender {
    int? id;
    FirstName? firstName;
    LastName? lastName;
    Email? email;

    Sender({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
    });

    factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"],
        firstName: firstNameValues.map[json["first_name"]],
        lastName: lastNameValues.map[json["last_name"]],
        email: emailValues.map[json["email"]],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstNameValues.reverse[firstName],
        "last_name": lastNameValues.reverse[lastName],
        "email": emailValues.reverse[email],
    };
}

enum Email { AK_GMAIL_COM, AGHORAI06_GMAIL_COM }

final emailValues = EnumValues({
    "aghorai06@gmail.com": Email.AGHORAI06_GMAIL_COM,
    "ak@gmail.com": Email.AK_GMAIL_COM
});

enum FirstName { BHIM, ARITRA }

final firstNameValues = EnumValues({
    "Aritra": FirstName.ARITRA,
    "Bhim": FirstName.BHIM
});

enum LastName { BHAKTA, GHORAI }

final lastNameValues = EnumValues({
    "Bhakta": LastName.BHAKTA,
    "Ghorai": LastName.GHORAI
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
