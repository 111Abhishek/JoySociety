// To parse this JSON data, do
//
//     final trueSuccessQuesResp = trueSuccessQuesRespFromJson(jsonString);

import 'dart:convert';

TrueSuccessQuesResp trueSuccessQuesRespFromJson(String str) => TrueSuccessQuesResp.fromJson(json.decode(str));

String trueSuccessQuesRespToJson(TrueSuccessQuesResp data) => json.encode(data.toJson());

class TrueSuccessQuesResp {
    int? count;
    dynamic next;
    dynamic previous;
    List<Result>? results;

    TrueSuccessQuesResp({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory TrueSuccessQuesResp.fromJson(Map<String, dynamic> json) => TrueSuccessQuesResp(
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
    String? question;
    int? category;
    String? type;

    Result({
        this.id,
        this.question,
        this.category,
        this.type,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        question: json["question"],
        category: json["category"],
        type: json["_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "category": category,
        "_type": type,
    };
}
