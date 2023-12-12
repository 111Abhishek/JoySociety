// To parse this JSON data, do
//
//     final memberFollow = memberFollowFromJson(jsonString);

import 'dart:convert';

MemberFollowUnFollowResponse memberFollowFromJson(String str) => MemberFollowUnFollowResponse.fromJson(json.decode(str));

String memberFollowToJson(MemberFollowUnFollowResponse data) => json.encode(data.toJson());

class MemberFollowUnFollowResponse {
    String? success;
    bool? status;

    MemberFollowUnFollowResponse({
        this.success,
        this.status,
    });

    factory MemberFollowUnFollowResponse.fromJson(Map<String, dynamic> json) => MemberFollowUnFollowResponse(
        success: json["success"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
    };
}
