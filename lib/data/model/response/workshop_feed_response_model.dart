// To parse this JSON data, do
//
//     final tribeFeedResponse = tribeFeedResponseFromJson(jsonString);

import 'dart:convert';

WorkshopFeedResponse workshopFeedResponseFromJson(String str) =>
    WorkshopFeedResponse.fromJson(json.decode(str));

String workshopFeedResponseToJson(WorkshopFeedResponse data) =>
    json.encode(data.toJson());

class WorkshopFeedResponse {
  int? count;
  dynamic next;
  dynamic previous;
  List<Result>? results;

  WorkshopFeedResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory WorkshopFeedResponse.fromJson(Map<String, dynamic> json) {
    return WorkshopFeedResponse(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
      results:
          List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  int? id;
  DateTime? createdOn;
  Content? content;
  ContentType? contentType;
  List<Comment>? comments;
  List<User>? like;
  int? likeCount;
  Topic? topic;

  Result({
    this.id,
    this.createdOn,
    this.content,
    this.contentType,
    this.comments,
    this.like,
    this.likeCount,
    this.topic,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        createdOn: DateTime.parse(json["created_on"]),
        content: Content.fromJson(json["content"]),
        contentType: contentTypeValues.map[json["content_type"]],
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        like: List<User>.from(json["like"].map((x) => User.fromJson(x))),
        likeCount: json["like_count"],
        topic: json["topic"] != null ? Topic.fromJson(json["topic"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_on": createdOn!.toIso8601String(),
        "content": content!.toJson(),
        "content_type": contentTypeValues.reverse[contentType],
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "like": List<dynamic>.from(like!.map((x) => x.toJson())),
        "like_count": likeCount,
        "topic": topic!.toJson(),
      };
}

class Comment {
  int? id;
  String? comment;
  List<Comment>? child;
  List<User>? like;
  int? likeCount;
  User? createdBy;
  dynamic image;
  DateTime? createdOn;

  Comment({
    this.id,
    this.comment,
    this.child,
    this.like,
    this.likeCount,
    this.createdBy,
    this.image,
    this.createdOn,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        comment: json["comment"],
        child: List<Comment>.from(json["child"] == null
            ? []
            : List<Comment>.from(
                json["child"].map((x) => Comment.fromJson(x)))),
        like: json["like"] != null
            ? List<User>.from(json["like"].map((x) => User.fromJson(x)))
            : [],
        likeCount: json["like_count"] ?? 0,
        createdBy: json["created_by"] != null
            ? User.fromJson(json["created_by"])
            : null,
        image: json["image"],
        createdOn: json["created_on"] != null
            ? DateTime.parse(json["created_on"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "child": List<dynamic>.from(child!.map((x) => x)),
        "like": List<dynamic>.from(like!.map((x) => x)),
        "like_count": likeCount,
        "created_by": createdBy!.toJson(),
        "image": image,
        "created_on": createdOn!.toIso8601String(),
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePic;

  User({this.id, this.firstName, this.lastName, this.email, this.profilePic});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      profilePic: json['profile_pic']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "profile_pic": profilePic
      };
}

class Content {
  int? id;
  String? post;
  dynamic workshop;
  User? user;
  int? topic;
  int? tribe;
  String? schedule;

  String? question;
  String? type;
  List<String>? answer_choice;

  List<String>? answers;
  List<String>? myAnswer;

  Content({
    this.id,
    this.post,
    this.workshop,
    this.user,
    this.topic,
    this.tribe,
    this.schedule,
    this.question,
    this.type,
    this.answer_choice,
    this.answers,
    this.myAnswer,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        post: json["post"],
        workshop: json["workshop"],
        user: User.fromJson(json["user"]),
        topic: json["topic"],
        tribe: json["tribe"],
        schedule: json["schedule"],
        question: json["question"] ?? '',
        type: json["_type"],
        answer_choice: List<String>.from(
          json["answer_choice"] != null
              ? List<String>.from(json["answer_choice"].map((x) => x))
              : [],
        ),
        answers: List<String>.from(
          json["answers"] != null
              ? List<String>.from(json["answers"].map((x) => x))
              : [],
        ),
        myAnswer: List<String>.from(
          json["my_answer"] != null
              ? List<String>.from(json["my_answer"].map((x) => x))
              : [],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post": post,
        "workshop": workshop,
        "user": user!.toJson(),
        "topic": topic,
        "tribe": tribe,
        "schedule": schedule,
      };
}

enum ContentType { QUICK_POST }

final contentTypeValues = EnumValues({"QuickPost": ContentType.QUICK_POST});

class Topic {
  int? id;
  String? name;
  dynamic contributor;
  dynamic description;
  dynamic color;
  dynamic backgroundImage;
  int? order;

  Topic({
    this.id,
    this.name,
    this.contributor,
    this.description,
    this.color,
    this.backgroundImage,
    this.order,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        name: json["name"],
        contributor: json["contributor"],
        description: json["description"],
        color: json["color"],
        backgroundImage: json["background_image"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "contributor": contributor,
        "description": description,
        "color": color,
        "background_image": backgroundImage,
        "order": order,
      };
}

enum Name { FAMILYWELLBEING, EMOTIONALWELLBEING }

final nameValues = EnumValues(
    {"emotionalwellbeing": Name.EMOTIONALWELLBEING, "": Name.FAMILYWELLBEING});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
