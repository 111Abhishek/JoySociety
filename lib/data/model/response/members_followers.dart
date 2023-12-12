// To parse this JSON data, do
//
//     final followingModel = followingModelFromJson(jsonString);

import 'dart:convert';

FollowingModel followingModelFromJson(String str) => FollowingModel.fromJson(json.decode(str));

String followingModelToJson(FollowingModel data) => json.encode(data.toJson());

class FollowingModel {
    int? count;
    String? next;
    dynamic previous;
    List<FollowersResponse>? results;

    FollowingModel({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory FollowingModel.fromJson(Map<String, dynamic> json) => FollowingModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<FollowersResponse>.from(json["results"].map((x) => FollowersResponse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class FollowersResponse {
    int? id;
    String? firstName;
    String? lastName;
    String? email;

    FollowersResponse({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
    });

    factory FollowersResponse.fromJson(Map<String, dynamic> json) => FollowersResponse(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
    };
}
