class CreateGoalModel {
  int _sphere = 0;
  String? _define_goal;
  String? _why;
  String? _action_step_1;
  String? _completion_date_1;
  String? _action_step_2;
  String? _completion_date_2;
  String? _action_step_3;
  String? _completion_date_3;
  String? _action_step_4;
  String? _completion_date_4;
  String? _action_step_5;
  String? _completion_date_5;
  String? _action_step_6;
  String? _completion_date_6;
  String? _potential_barriers;
  String? _support_and_resources;
  bool? _connection_sessions;
  bool? _networking_connecting;
  bool? _accountablity_checkpoint;
  bool? _self_paced_learning;
  bool? _wducationnal_webinar;
  bool? _join_tribe;
  String? _completion_date;
  String? _question1;
  String? _question2;
  String? _question3;
  String? _question4;

  int? _actionFreq1;
  int? _actionFreq2;
  int? _actionFreq3;
  int? _actionFreq4;
  int? _actionFreq5;
  int? _actionFreq6;

  CreateGoalModel({
    required int sphere,
    String? define_goal,
    String? why,
    String? action_step_1,
    String? completion_date_1,
    String? action_step_2,
    String? completion_date_2,
    String? action_step_3,
    String? completion_date_3,
    String? action_step_4,
    String? completion_date_4,
    String? action_step_5,
    String? completion_date_5,
    String? action_step_6,
    String? completion_date_6,
    String? potential_barriers,
    String? support_and_resources,
    bool? connection_sessions,
    bool? networking_connecting,
    bool? accountablity_checkpoint,
    bool? self_paced_learning,
    bool? wducationnal_webinar,
    bool? join_tribe,
    String? completion_date,
    String? question1,
    String? question2,
    String? question3,
    String? question4,
    int? actionFreq1,
    int? actionFreq2,
    int? actionFreq3,
    int? actionFreq4,
    int? actionFreq5,
    int? actionFreq6,
  }) {
    this._sphere = sphere;
    this._define_goal = define_goal;
    this._why = why;
    this._action_step_1 = action_step_1;
    this._completion_date_1 = completion_date_1;
    this._action_step_2 = action_step_2;
    this._completion_date_2 = completion_date_2;
    this._action_step_3 = action_step_3;
    this._completion_date_3 = completion_date_3;
    this._action_step_4 = action_step_4;
    this._completion_date_4 = completion_date_4;
    this._action_step_5 = action_step_5;
    this._completion_date_5 = completion_date_5;
    this._action_step_6 = action_step_6;
    this._completion_date_6 = completion_date_6;
    this._potential_barriers = potential_barriers;
    this._support_and_resources = support_and_resources;
    this._connection_sessions = connection_sessions;
    this._networking_connecting = networking_connecting;
    this._accountablity_checkpoint = accountablity_checkpoint;
    this._self_paced_learning = self_paced_learning;
    this._wducationnal_webinar = wducationnal_webinar;
    this._join_tribe = join_tribe;
    this._completion_date = completion_date;
    this._question1 = question1;
    this._question2 = question2;
    this._question3 = question3;
    this._question4 = question4;
    this._actionFreq1 = actionFreq1;
    this._actionFreq2 = actionFreq2;
    this._actionFreq3 = actionFreq3;
    this._actionFreq4 = actionFreq4;
    this._actionFreq5 = actionFreq5;
    this._actionFreq6 = actionFreq6;
  }

  int get sphere => _sphere;
  String? get define_goal => _define_goal ?? "";
  String? get why => _why;
  String? get action_step_1 => _action_step_1 ?? "";
  String? get completion_date_1 => _completion_date_1;
  String? get action_step_2 => _action_step_2 ?? "";
  String? get completion_date_2 => _completion_date_2;
  String? get action_step_3 => _action_step_3 ?? "";
  String? get completion_date_3 => _completion_date_3;
  String? get action_step_4 => _action_step_4 ?? "";
  String? get completion_date_4 => _completion_date_4;
  String? get action_step_5 => _action_step_5 ?? "";
  String? get completion_date_5 => _completion_date_5;
  String? get action_step_6 => _action_step_6 ?? "";
  String? get completion_date_6 => _completion_date_6;
  String? get potential_barriers => _potential_barriers;
  String? get support_and_resources => _support_and_resources;
  bool? get connection_sessions => _connection_sessions;
  bool? get networking_connecting => _networking_connecting;
  bool? get accountablity_checkpoint => _accountablity_checkpoint;
  bool? get self_paced_learning => _self_paced_learning;
  bool? get wducationnal_webinar => _wducationnal_webinar;
  bool? get join_tribe => _join_tribe;
  String? get completion_date => _completion_date;
  String? get question1 => _question1;
  String? get question2 => _question2;
  String? get question3 => _question3;
  String? get question4 => _question4;

  factory CreateGoalModel.fromJson(Map<String, dynamic> json) {
    return CreateGoalModel(
      sphere: json['sphere'],
      define_goal: json['define_goal'],
      why: json['why'],
      action_step_1: json['action_step_1'],
      completion_date_1: json['completion_date_1'],
      action_step_2: json['action_step_2'],
      completion_date_2: json['completion_date_2'],
      action_step_3: json['action_step_3'],
      completion_date_3: json['completion_date_3'],
      action_step_4: json['action_step_4'],
      completion_date_4: json['completion_date_4'],
      action_step_5: json['action_step_4'],
      completion_date_5: json['completion_date_5'],
      action_step_6: json['action_step_6'],
      completion_date_6: json['completion_date_6'],
      potential_barriers: json['potential_barriers'],
      support_and_resources: json['support_and_resources'],
      connection_sessions: json['connection_sessions'],
      networking_connecting: json['networking_connecting'],
      accountablity_checkpoint: json['accountablity_checkpoint'],
      self_paced_learning: json['self_paced_learning'],
      wducationnal_webinar: json['wducationnal_webinar'],
      join_tribe: json['join_tribe'],
      completion_date: json['completion_date'],
      actionFreq1: json["action_freq_count_1"],
      actionFreq2: json["action_freq_count_2"],
      actionFreq3: json["action_freq_count_3"],
      actionFreq4: json["action_freq_count_4"],
      actionFreq5: json["action_freq_count_5"],
      actionFreq6: json["action_freq_count_6"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._sphere != null) {
      data['sphere'] = this.sphere;
    }
    if (this._define_goal != null) {
      data['define_goal'] = this._define_goal;
    }
    if (this._why != null) {
      data['why'] = this._why;
    }
    if (this._completion_date_1 != null && !this._completion_date_1!.isEmpty) {
      data['completion_date_1'] = this._completion_date_1;
      if (this._action_step_1 != null) {
        data['action_step_1'] = this._action_step_1;
      }
    }

    if (this._completion_date_2 != null && !this._completion_date_2!.isEmpty) {
      data['completion_date_2'] = this._completion_date_2;
      if (this._action_step_2 != null) {
        data['action_step_2'] = this._action_step_2;
      }
    }

    if (this._completion_date_3 != null && !this._completion_date_3!.isEmpty) {
      data['completion_date_3'] = this._completion_date_3;
      if (this._action_step_3 != null) {
        data['action_step_3'] = this._action_step_3;
      }
    }

    if (this._completion_date_4 != null && !this._completion_date_4!.isEmpty) {
      data['completion_date_4'] = this._completion_date_4;
      if (this._action_step_4 != null) {
        data['action_step_4'] = this._action_step_4;
      }
    }

    if (this._completion_date_5 != null && !this._completion_date_5!.isEmpty) {
      data['completion_date_5'] = this._completion_date_5;
      if (this._action_step_5 != null) {
        data['action_step_5'] = this._action_step_5;
      }
    }

    if (this._completion_date_6 != null && !this._completion_date_6!.isEmpty) {
      data['completion_date_6'] = this._completion_date_6;
      if (this._action_step_6 != null) {
        data['action_step_6'] = this._action_step_6;
      }
    }
    if (this.potential_barriers != null) {
      data['potential_barriers'] = this._potential_barriers;
    }
    if (this.support_and_resources != null) {
      data['support_and_resources'] = this._support_and_resources;
    }
    if (this.connection_sessions != null) {
      data['connection_sessions'] = this._connection_sessions;
    }
    if (this.networking_connecting != null) {
      data['networking_connecting'] = this._networking_connecting;
    }
    if (this.accountablity_checkpoint != null) {
      data['accountablity_checkpoint'] = this._accountablity_checkpoint;
    }
    if (this.self_paced_learning != null) {
      data['self_paced_learning'] = this._self_paced_learning;
    }
    if (this.wducationnal_webinar != null) {
      data['wducationnal_webinar'] = this._wducationnal_webinar;
    }
    if (this.join_tribe != null) {
      data['join_tribe'] = this._join_tribe;
    }
    if (this.completion_date != null) {
      data['completion_date'] = this._completion_date;
    }
    if (this.question1 != null) {
      data['question_1'] = this._question1;
    }
    if (this.question2 != null) {
      data['question_2'] = this._question2;
    }
    if (this.question3 != null) {
      data['question_3'] = this._question3;
    }
    if (this.question4 != null) {
      data['question_4'] = this._question4;
    }

    return data;
  }
}
