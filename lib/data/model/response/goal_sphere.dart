// To parse this JSON data, do
//
//     final goalSphere = goalSphereFromJson(jsonString);

import 'dart:convert';

GoalSphereResponse goalSphereFromJson(String str) => GoalSphereResponse.fromJson(json.decode(str));

String goalSphereToJson(GoalSphereResponse data) => json.encode(data.toJson());

class GoalSphereResponse {
    List<Result>? results;

    GoalSphereResponse({
        this.results,
    });

    factory GoalSphereResponse.fromJson(Map<String, dynamic> json) => GoalSphereResponse(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class Result {
    int? id;
    String? name;
    int? goalId;
    String? goalStatus;
    DateTime? createdOn;

    Result({
        this.id,
        this.name,
        this.goalId,
        this.goalStatus,
        this.createdOn,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        goalId: json["goal_id"],
        goalStatus: json["goal_status"],
        createdOn: DateTime.parse(json["created_on"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "goal_id": goalId,
        "goal_status": goalStatus,
        "created_on": createdOn!.toIso8601String(),
    };
}
