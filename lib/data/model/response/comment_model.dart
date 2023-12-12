import 'package:flutter/foundation.dart';
import 'package:joy_society/data/model/response/like_model.dart';
import 'package:joy_society/data/model/response/workshop_profile_model.dart';

class CommentModel {
  int _id = 0;
  String? _comment;
  List<CommentModel>? _children;
  List<LikeModel>? _likes;
  int? _totalLikes;
  WorkshopProfileModel? _createdBy;
  String? _image;
  String? _createdOn;

  CommentModel(
      {required int id,
      String? comment,
      List<CommentModel>? children,
      List<LikeModel>? likes,
      int? totalLikes,
      WorkshopProfileModel? createdBy,
      String? image,
      String? createdOn}) {
    _id = id;
    _comment = comment;
    _children = children;
    _likes = likes;
    _totalLikes = totalLikes;
    _createdBy = createdBy;
    _image = image;
    _createdOn = createdOn;
  }

  int? get id => _id;
  String? get comment => _comment;
  List<CommentModel>? get children => _children;
  List<LikeModel>? get likes => _likes;
  int? get totalLikes => _totalLikes;
  WorkshopProfileModel? get createdBy => _createdBy;
  String? get image => _image;
  String? get createdOn => _createdOn;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        id: json['id'],
        comment: json['comment'],
        children: (json['child'] != null)
            ? (json['child'] as List)
                .map((comment) => CommentModel.fromJson(comment))
                .toList()
            : null,
        likes: (json['like'] != null)
            ? (json['like'] as List)
                .map((like) => LikeModel.fromJson(like))
                .toList()
            : null,
        totalLikes: json['like_count'],
        image: json['image'],
        createdBy: json['created_by'] != null
            ? WorkshopProfileModel.fromJson(json['created_by'])
            : null,
        createdOn: json['created_on']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = _id;
    if (_comment != null) {
      data['comment'] = _comment;
    }
    if (_children != null) {
      data['child'] = _children?.map((child) => child.toJson()).toList();
    }
    if (_totalLikes != null) {
      data['like_count'] = _totalLikes;
    }
    if (_image != null) {
      data['image'] = _image;
    }
    if (_createdBy != null) {
      data['created_by'] = _createdBy?.toJson();
    }
    if (_createdOn != null) {
      data['created_on'] = _createdOn;
    }

    return data;
  }
}
