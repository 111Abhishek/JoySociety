import 'package:joy_society/data/model/response/workshop_member_model.dart';

class MembersListModel {
  int? _count;
  String? _next;
  String? _previous;
  List<WorkshopMemberModel>? _members;

  MembersListModel(
      {int? count,
      String? next,
      String? previous,
      List<WorkshopMemberModel>? members}) {
    _count = count;
    _next = next;
    _previous = previous;
    _members = members;
  }

  int? get count => _count;
  String? get next => _next;
  String? get previous => _previous;
  List<WorkshopMemberModel>? get members => _members;

  factory MembersListModel.fromJson(Map<String, dynamic> json) {
    return MembersListModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        members: json['results'] != null
            ? (json['results'] as List)
                .map((result) => WorkshopMemberModel.fromJson(result))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_count != null) {
      data['count'] = _count;
    }
    if (_previous != null) {
      data['previous'] = _previous;
    }
    if (_next != null) {
      data['next'] = _next;
    }
    if (_members != null) {
      data['results'] = _members!.map((member) => member.toJson()).toList();
    }
    return data;
  }
}
