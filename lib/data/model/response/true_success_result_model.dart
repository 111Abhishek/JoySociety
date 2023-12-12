// To parse this JSON data, do
//
//     final trueSuccessResultModel = trueSuccessResultModelFromJson(jsonString);

import 'dart:convert';

TrueSuccessResultModel trueSuccessResultModelFromJson(String str) => TrueSuccessResultModel.fromJson(json.decode(str));

String trueSuccessResultModelToJson(TrueSuccessResultModel data) => json.encode(data.toJson());

class TrueSuccessResultModel {
    List<Report>? report;
    int? highest;
    int? lowest;

    TrueSuccessResultModel({
        this.report,
        this.highest,
        this.lowest,
    });

    factory TrueSuccessResultModel.fromJson(Map<String, dynamic> json) => TrueSuccessResultModel(
        report: List<Report>.from(json["report"].map((x) => Report.fromJson(x))),
        highest: json["highest"]??0,
        lowest: json["lowest"]??0,
    );

    Map<String, dynamic> toJson() => {
        "report": List<dynamic>.from(report!.map((x) => x.toJson())),
        "highest": highest,
        "lowest": lowest,
    };
}

class Report {
    String? label;
    int? score;

    Report({
        this.label,
        this.score,
    });

    factory Report.fromJson(Map<String, dynamic> json) => Report(
        label: json["label"]??'',
        score: json["score"]??0,
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "score": score,
    };
}
