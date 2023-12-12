class TopicDeleteModel {
  String? name;

  TopicDeleteModel({
    this.name,
  });

  TopicDeleteModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null && this.name!.isNotEmpty) {
      data['name'] = this.name;
    }
    return data;
  }
}
