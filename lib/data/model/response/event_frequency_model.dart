

class EventFrequencyModel {
  String? frequency;
  String? occurrence;
  String? repeat_ends;
  String? occurrence_frequency;
  String? repeat_ends_value;
  List<String>? repeat_on = [];

  EventFrequencyModel({this.frequency, this.occurrence, this.repeat_ends,
    this.occurrence_frequency, this.repeat_ends_value, this.repeat_on});

  factory EventFrequencyModel.fromJson(Map<String, dynamic> json) {
    return EventFrequencyModel(
        frequency: json['frequency'],
        occurrence: json['occurrence'],
        repeat_ends: json['repeat_ends'],
        occurrence_frequency: json['occurrence_frequency'],
        repeat_ends_value: json['repeat_ends_value'],
        repeat_on : json['repeat_on'] != null ? json['repeat_on'].cast<String>() : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.frequency != null) {
      data['frequency'] = this.frequency;
    }
    if(this.occurrence != null) {
      data['occurrence'] = this.occurrence;
    }
    if(this.repeat_ends != null) {
      data['repeat_ends'] = this.repeat_ends;
    }
    if(this.occurrence_frequency != null) {
      data['occurrence_frequency'] = this.occurrence_frequency;
    }
    if(this.repeat_ends_value != null) {
      data['repeat_ends_value'] = this.repeat_ends_value;
    }
    if(this.repeat_on != null) {
      data['repeat_on'] = this.repeat_on;
    }
    return data;
  }
}