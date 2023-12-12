

class InvitedByModel {
  int? id;
  String? first_name;
  String? last_name;
  String? email;

  InvitedByModel({this.id, this.first_name, this.last_name, this.email});

  factory InvitedByModel.fromJson(Map<String, dynamic> json) {
    return InvitedByModel(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['email']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['email'] = this.email;
    return data;
  }
}