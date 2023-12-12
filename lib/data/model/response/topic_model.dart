
import 'dart:ffi';

class TopicModel {
  int _id = 0;
  String? _name;
  String? _contributor;
  String? _description;
  String? _color;
  String? _background_image;
  int _order = 0;

  TopicModel(
      {
        required int id,
        String? name,
        String? contributor,
        String? description,
        String? color,
        String? background_image,
        required int order}) {
    this._id = id;
    this._name = name;
    this._contributor = contributor;
    this._description = description;
    this._color = color;
    this._background_image = background_image;
    this._order = order;
  }

  int get id => _id;
  String? get name => _name ?? "";
  String? get contributor => _contributor;
  String? get description => _description ?? "";
  String? get color => _color;
  String get background_image => _background_image ?? "";
  int get order => _order;

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
        id : json['id'],
        name : json['name'],
        contributor : json['contributor'],
        description : json['description'],
        color : json['color'],
        background_image : json['background_image'],
        order : json['order']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._id != null) {
      data['id'] = this.id;
    }
    if (this._name != null) {
      data['name'] = this._name;
    }
    if (this._contributor != null) {
      data['contributor'] = this._contributor;
    }
    if (this._description != null) {
      data['description'] = this._description;
    }
    if (this._color != null) {
      data['color'] = this._color;
    }
    if (this._background_image != null) {
      data['background_image'] = this._background_image;
    }
    if (this._order != null) {
      data['order'] = this._order;
    }
    return data;
  }
}