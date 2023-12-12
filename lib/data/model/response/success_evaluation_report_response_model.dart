
import 'package:joy_society/data/model/response/success_evaluation_report_model.dart';

class SuccessEvaluationReportResponseModel {
  int? highest;
  List<SuccessEvaluationReportModel>? data = <SuccessEvaluationReportModel>[];

  SuccessEvaluationReportResponseModel({this.highest, this.data});

  factory SuccessEvaluationReportResponseModel.fromJson(Map<String, dynamic> json) {
    return SuccessEvaluationReportResponseModel(
        highest: json['highest'],
        data: json['report'] != null ? (json['report'] as List).map((i) => SuccessEvaluationReportModel.fromJson(i)).toList() : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['highest'] = this.highest;
    if (this.data != null) {
      data['report'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}