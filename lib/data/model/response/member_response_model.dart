// To parse this JSON data, do
//
//     final memberResponseModel = memberResponseModelFromJson(jsonString);

import 'dart:convert';

MemberResponseModel memberResponseModelFromJson(String str) =>
    MemberResponseModel.fromJson(json.decode(str));

String memberResponseModelToJson(MemberResponseModel data) =>
    json.encode(data.toJson());

class MemberResponseModel {
  int? id;
  String? fullName;
  String? email;
  dynamic profilePic;
  String? miniBio;
  List<dynamic>? personalLinks;
  Location? location;
  Location? timezone;
  int? role;
  DateTime? createdOn;
  bool? tnc;
  String? membershipCompletion;
  String? purchaseEmail;
  String? inviteGroupOrPartner;
  String? approval;
  int? userId;
  List<Badge>? badges;
  bool? isActive;
  int? followerCount;
  int? followingCount;
  int? numberOfJoinedWorkshops;
  int? numberOfJoinedTribes;

  MemberResponseModel({
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
    this.isActive,
    this.followerCount,
    this.followingCount,
    this.numberOfJoinedWorkshops,
    this.numberOfJoinedTribes,
  });

  factory MemberResponseModel.fromJson(Map<String, dynamic> json) =>
      MemberResponseModel(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        profilePic: json["profile_pic"],
        miniBio: json["mini_bio"],
        personalLinks: List<dynamic>.from(json["personal_links"].map((x) => x)),
        // location: Location.fromJson(json["location"] == null ?Location(id: 0 , name: "")  :Location.fromJson(json["location"]) ),
        // timezone: Location.fromJson(json["timezone"]),
        role: json["role"],
        createdOn: DateTime.parse(json["created_on"]),
        tnc: json["tnc"],
        membershipCompletion: json["membership_completion"],
        purchaseEmail: json["purchase_email"],
        inviteGroupOrPartner: json["invite_group_or_partner"],
        approval: json["approval"],
        userId: json["user_id"],
        badges: List<Badge>.from(json["badges"].map((x) => Badge.fromJson(x))),
        isActive: json["is_active"],
        followerCount: json["follower_count"],
        followingCount: json["following_count"],
        numberOfJoinedWorkshops: json["numberOfJoinedWorkshops"],
        numberOfJoinedTribes: json["numberOfJoinedTribes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "profile_pic": profilePic,
        "mini_bio": miniBio,
        "personal_links": List<dynamic>.from(personalLinks!.map((x) => x)),
        "location": location!.toJson(),
        "timezone": timezone!.toJson(),
        "role": role,
        "created_on": createdOn!.toIso8601String(),
        "tnc": tnc,
        "membership_completion": membershipCompletion,
        "purchase_email": purchaseEmail,
        "invite_group_or_partner": inviteGroupOrPartner,
        "approval": approval,
        "user_id": userId,
        "badges": List<dynamic>.from(badges!.map((x) => x.toJson())),
        "is_active": isActive,
      };
}

class Badge {
  String? type;
  String? title;

  Badge({
    this.type,
    this.title,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        type: json["type"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
      };
}

class Location {
  int? id;
  String? name;

  Location({
    this.id,
    this.name,
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
