// To parse this JSON data, do
//
//     final membersResponse = membersResponseFromJson(jsonString);

import 'dart:convert';

MembersResponse membersResponseFromJson(String str) =>
    MembersResponse.fromJson(json.decode(str));

String membersResponseToJson(MembersResponse data) =>
    json.encode(data.toJson());

class MembersResponse {
  int? count;
  String? next;
  dynamic previous;
  List<Result>? results;

  MembersResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory MembersResponse.fromJson(Map<String, dynamic> json) =>
      MembersResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
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
  String? fullName;
  String? email;
  String? profilePic;
  String? miniBio;
  List<String>? personalLinks;
  Location? location;
  Location? timezone;
  int? role;
  DateTime? createdOn;
  bool? tnc;
  String? membershipCompletion;
  String? purchaseEmail;
  String? inviteGroupOrPartner;
  Approval? approval;
  int? userId;
  List<Badge>? badges;

  Result({
    this.id,
    this.fullName,
    this.email,
    this.profilePic,
    this.miniBio,
    this.personalLinks,
    this.location,
    this.timezone,
    this.role,
    this.createdOn,
    this.tnc,
    this.membershipCompletion,
    this.purchaseEmail,
    this.inviteGroupOrPartner,
    this.approval,
    this.userId,
    this.badges,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        profilePic: json["profile_pic"],
        miniBio: json["mini_bio"],
        personalLinks: List<String>.from(json["personal_links"].map((x) => x)),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        timezone: json["timezone"] == null
            ? null
            : Location.fromJson(json["timezone"]),
        role: json["role"],
        createdOn: DateTime.parse(json["created_on"]),
        tnc: json["tnc"],
        membershipCompletion: json["membership_completion"],
        purchaseEmail: json["purchase_email"],
        inviteGroupOrPartner: json["invite_group_or_partner"],
        approval: approvalValues.map[json["approval"]]!,
        userId: json["user_id"],
        badges: List<Badge>.from(json["badges"].map((x) => Badge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "profile_pic": profilePic,
        "mini_bio": miniBio,
        "personal_links": List<dynamic>.from(personalLinks!.map((x) => x)),
        "location": location?.toJson(),
        "timezone": timezone?.toJson(),
        "role": role,
        "created_on": createdOn!.toIso8601String(),
        "tnc": tnc,
        "membership_completion": membershipCompletion,
        "purchase_email": purchaseEmail,
        "invite_group_or_partner": inviteGroupOrPartner,
        "approval": approvalValues.reverse[approval],
        "user_id": userId,
        "badges": List<dynamic>.from(badges!.map((x) => x.toJson())),
      };
}

enum Approval { OPEN, APPROVED }

final approvalValues =
    EnumValues({"Approved": Approval.APPROVED, "Open": Approval.OPEN});

class Badge {
  Type type;
  Title title;

  Badge({
    required this.type,
    required this.title,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        type: json["type"] != null
            ? typeValues.map[json["type"]] ?? Type.MEMBERSHIP
            : Type.MEMBERSHIP,
        title: json["title"] != null
            ? titleValues.map[json["title"]] ?? Title.COMMITTED_TO_WELL_BEING
            : Title.COMMITTED_TO_WELL_BEING,
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "title": titleValues.reverse[title],
      };
}

enum Title { COMMITTED_TO_WELL_BEING }

final titleValues =
    EnumValues({"Committed to Well-Being": Title.COMMITTED_TO_WELL_BEING});

enum Type { MEMBERSHIP }

final typeValues = EnumValues({"membership": Type.MEMBERSHIP});

class Location {
  int id;
  String name;

  Location({
    required this.id,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
