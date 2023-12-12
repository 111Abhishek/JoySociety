

class SuccessEvaluationReportModel {
  String? _label;
  int? _score;
  int? _scorePart2 = 0;

  SuccessEvaluationReportModel(
      {
        String? label,
        int? score,
        int? scorePart2}) {
    this._label = label;
    this._score = score;
    this._scorePart2 = scorePart2 ?? 0;
  }

  String? get label => _label ?? "";
  int? get score => _score;
  int? get scorePart2 => _scorePart2;

  factory SuccessEvaluationReportModel.setPart2Score(String? label, int? score, int? part2score) {
    return SuccessEvaluationReportModel(
        label : label,
        score : score ,
        scorePart2 : part2score
    );
  }

  factory SuccessEvaluationReportModel.fromJson(Map<String, dynamic> json) {
    return SuccessEvaluationReportModel(
        label : json['label'],
        score : json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._label != null) {
      data['label'] = this._label;
    }
    if (this._score != null) {
      data['score'] = this._score;
    }
    return data;
  }
}