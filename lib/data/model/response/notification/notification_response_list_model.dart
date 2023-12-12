import 'package:joy_society/data/model/response/notification/notification_response_model.dart';

class NotificationResponseListModel {
  int? _count;
  String? _next;
  String? _previous;
  List<NotificationResponseModel> _results = [];

  NotificationResponseListModel(
      {int? count,
      String? next,
      String? previous,
      List<NotificationResponseModel>? results}) {
    _count = count;
    _next = next;
    _previous = previous;
    _results = results ?? [];
  }

  int? get count => _count;

  String? get next => _next;

  String? get previous => _previous;

  List<NotificationResponseModel> get results => _results;

  set results(List<NotificationResponseModel> newResult) {
    _results = newResult;
  }

  factory NotificationResponseListModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseListModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        results: json['results'] != null
            ? (json['results'] as List)
                .map((e) => NotificationResponseModel.fromJson(e))
                .toList()
            : []);
  }
}
