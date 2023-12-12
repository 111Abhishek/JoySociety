class LikeModel {
  int _id = 0;
  String? _firstName;
  String? _lastName;
  String? _email;

  LikeModel(
      {required int id, String? firstName, String? lastName, String? email}) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
  }

  int get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    if (_firstName != null) data['first_name'] = _firstName;
    if (_lastName != null) data['last_name'] = _lastName;
    if (_email != null) data['email'] = _email;

    return data;
  }
}
