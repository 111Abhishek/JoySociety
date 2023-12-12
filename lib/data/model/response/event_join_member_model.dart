// To parse this JSON data, do
//
//     final eventJoinMembersModel = eventJoinMembersModelFromJson(jsonString);

import 'dart:convert';

EventJoinMembersModel eventJoinMembersModelFromJson(String str) => EventJoinMembersModel.fromJson(json.decode(str));

String eventJoinMembersModelToJson(EventJoinMembersModel data) => json.encode(data.toJson());

class EventJoinMembersModel {
    int? count;
    dynamic next;
    dynamic previous;
    List<Result>? results;

    EventJoinMembersModel({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory EventJoinMembersModel.fromJson(Map<String, dynamic> json) => EventJoinMembersModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class Result {
    int? id;
    int? event;
    User? user;
    String? status;

    Result({
        this.id,
        this.event,
        this.user,
        this.status,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        event: json["event"],
        user: User.fromJson(json["user"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "event": event,
        "user": user!.toJson(),
        "status": status,
    };
}

class User {
    int? id;
    String? firstName;
    String? lastName;
    String? email;
    String? profilePic;
    int? profileId;

    User({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.profilePic,
        this.profileId,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        profilePic: json["profile_pic"],
        profileId: json["profile_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "profile_pic": profilePic,
        "profile_id": profileId,
    };
}
