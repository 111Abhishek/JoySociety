// To parse this JSON data, do
//
//     final requestAchievedGoal = requestAchievedGoalFromJson(jsonString);

import 'dart:convert';

RequestAchievedGoal requestAchievedGoalFromJson(String str) =>
    RequestAchievedGoal.fromJson(json.decode(str));

String requestAchievedGoalToJson(RequestAchievedGoal data) =>
    json.encode(data.toJson());

class RequestAchievedGoal {
  String? aQuestionSet1;
  String? aQuestionSet2;
  String? aQuestionSet3;
  int? goalId;
  String? selectedNextId;
  String? sphereId;
  String? step;

  RequestAchievedGoal({
    this.aQuestionSet1,
    this.aQuestionSet2,
    this.aQuestionSet3,
    this.goalId,
    this.selectedNextId,
    this.sphereId,
    this.step,
  });

  factory RequestAchievedGoal.fromJson(Map<String, dynamic> json) =>
      RequestAchievedGoal(
        aQuestionSet1: json["a_question_set_1"],
        aQuestionSet2: json["a_question_set_2"],
        aQuestionSet3: json["a_question_set_3"],
        goalId: json["goal_id"],
        selectedNextId: json["selected_next_id"],
        sphereId: json["sphere_id"],
        step: json["step"],
      );

  Map<String, dynamic> toJson() => {
        "a_question_set_1": aQuestionSet1,
        "a_question_set_2": aQuestionSet2,
        "a_question_set_3": aQuestionSet3,
        "goal_id": goalId,
        "selected_next_id": selectedNextId,
        "sphere_id": sphereId,
        "steap": step,
      };
}
