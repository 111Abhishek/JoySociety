

class AppListingModel {
  int? count;
  String? next;
  String? previous;
  List<CommonListData>? data;

  AppListingModel({this.count, this.next, this.previous, this.data});

  factory AppListingModel.fromJson(Map<String, dynamic> json) {
    return AppListingModel(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        data: json['results'] != null ? (json['results'] as List).map((i) => CommonListData.fromJson(i)).toList() : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.data != null) {
      data['results'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonListData {
  int? id;
  String? name;

  CommonListData({this.id, this.name});

  factory CommonListData.fromJson(Map<String, dynamic> json) {
    return CommonListData(
      id: json['id'],
      name: json['name']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}