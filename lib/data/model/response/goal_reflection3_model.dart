

class GoalReflection3ModelModel {
  int? _sphere_1 = 0;
  int? _sphere_2 = 0;
  String? _sphere_1_answer;
  String? _sphere_2_answer;

  GoalReflection3ModelModel(
      {
        int? sphere_1,
        int? sphere_2,
        String? sphere_1_answer,
        String? sphere_2_answer,
      }) {
    this._sphere_1 = sphere_1;
    this._sphere_2 = sphere_2;
    this._sphere_1_answer = sphere_1_answer;
    this._sphere_2_answer = sphere_2_answer;
  }

  int? get sphere_1 => _sphere_1;
  int? get sphere_2 => _sphere_2;
  String? get sphere_1_answer => _sphere_1_answer ?? "";
  String? get sphere_2_answer => _sphere_2_answer ?? "";

  factory GoalReflection3ModelModel.fromJson(Map<String, dynamic> json) {
    return GoalReflection3ModelModel(
        sphere_1 : json['sphere_1'],
        sphere_2 : json['sphere_2'],
        sphere_1_answer : json['sphere_1_answer'],
        sphere_2_answer : json['sphere_2_answer']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._sphere_1 != null) {
      data['sphere_1'] = this.sphere_1;
    }
    if (this._sphere_2 != null) {
      data['sphere_2'] = this._sphere_2;
    }
    if (this._sphere_1_answer != null) {
      data['sphere_1_answer'] = this._sphere_1_answer;
    }
    if (this._sphere_2_answer != null) {
      data['sphere_2_answer'] = this._sphere_2_answer;
    }
    return data;
  }
}