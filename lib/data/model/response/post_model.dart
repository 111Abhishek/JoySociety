import 'package:joy_society/data/model/response/post_gallery.dart';
import 'package:joy_society/data/model/response/user_model.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';

class PostUserModel {
  int _id = 0;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _profilePic;

  PostUserModel(
      {required int id,
      String? firstName,
      String? lastName,
      String? email,
      String? profilePic}) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _profilePic = profilePic;
  }

  int get id => _id;

  String get firstName => _firstName ?? "";

  String get lastName => _lastName ?? "";

  String? get email => _email;

  String? get profilePic => _profilePic;

  String get fullName => "$firstName $lastName";

  factory PostUserModel.fromJson(Map<String, dynamic> json) {
    return PostUserModel(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        profilePic: json['profile_pic'],
        email: json['email']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    if (_firstName != null) data['first_name'] = _firstName;
    if (_lastName != null) data['last_name'] = _lastName;
    if (_email != null) data['email'] = _email;
    if (_profilePic != null) data['profile_pic'] = _profilePic;

    return data;
  }
}

class PostTopicModel {
  int _id = 0;
  String _name = "";

  PostTopicModel({required int id, required String name}) {
    _id = id;
    _name = name;
  }

  int get id => _id;

  String get name => _name;

  factory PostTopicModel.fromJson(Map<String, dynamic> json) {
    return PostTopicModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    return data;
  }
}

class PostContentModel {
  int _id = 0;
  String? _post;
  int? _workshop;
  PostUserModel? _user;
  int? _topic;
  int? _tribe;
  DateTime? _schedule;
  String? _type;
  List<String>? _answers;
  List<String>? _myAnswer;
  List<String>? _answerChoice;
  // List<dynamic> _answers;
  // List<String> _myAnswer;
  String? _question;

  PostContentModel(
      {required int id,
      String? post,
      int? workshop,
      String? type,
      List<String>? answers,
      List<String>? myAnswer,
      String? question,
      PostUserModel? user,
      int? topic,
      int? tribe,
      List<String>? answerChoice,
      DateTime? schedule}) {
    _id = id;
    _workshop = workshop;
    _user = user;
    _post = post;
    _topic = topic;
    _tribe = tribe;
    _schedule = schedule;
    _answers = answers;
    _question = question;
    _myAnswer = myAnswer;
    _answerChoice = answerChoice;
    // _answers = answers;
    _type = type;
  }

  int get id => _id;

  PostUserModel? get user => _user;

  int? get workshop => _workshop;

  List<String>? get answers => _answers;
  List<String>? get myAnswer => _myAnswer;
  List<String>? get answer_choice => _answerChoice;
  String? get question => _question;

  int? get topic => _topic;
  String? get type => _type;
  String? get post => _post;

  int? get tribe => _tribe;

  DateTime? get schedule => _schedule;

  factory PostContentModel.fromJson(Map<String, dynamic> json) {
    return PostContentModel(
        id: json['id'],
        post: json['post'],
        workshop: json['workshop'],
        question: json["question"] ?? '',
        user:
            json['user'] != null ? PostUserModel.fromJson(json['user']) : null,
        topic: json['topic'],
        tribe: json['tribe'],
        answerChoice: List<String>.from(
          json["answer_choice"] != null
              ? List<String>.from(json["answer_choice"].map((x) => x))
              : null.toList(),
        ),
        answers: List<String>.from(
          json["answers"] != null
              ? List<String>.from(json["answers"].map((x) => x))
              : null.toList(),
        ),
        myAnswer: List<String>.from(
          json["my_answer"] != null
              ? List<String>.from(json["my_answer"].map((x) => x))
              : null.toList(),
        ),
        schedule:
            json['schedule'] != null ? DateTime.parse(json['schedule']) : null,
        type: json["_type"] ?? '');
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = _id;
    if (_post != null) json['post'] = _post;
    if (_workshop != null) json['workshop'] = _workshop;
    if (_user != null) json['user'] = _user!.toJson();
    if (_topic != null) json['topic'] = _topic;
    if (_tribe != null) json['tribe'] = _tribe;
    if (_schedule != null) json['schedule'] = _schedule!.toIso8601String();
    if (_type != null) json['schedule'] = _schedule!.toIso8601String();
    return json;
  }
}

class PostCommentModel {
  int _id = 0;
  String _comment = "";
  List<PostCommentModel>? _children;
  List<PostUserModel>? _likes;
  int? _likeCount;
  String? _image;
  DateTime? _createdOn;
  PostUserModel? _createdBy;

  PostCommentModel(
      {required int id,
      required String comment,
      List<PostCommentModel>? children,
      List<PostUserModel>? likes,
      int? likeCount,
      String? image,
      PostUserModel? createdBy,
      DateTime? createdOn}) {
    _id = id;
    _comment = comment;
    _children = children;
    _likes = likes;
    _likeCount = likeCount;
    _image = image;
    _createdOn = createdOn;
    _createdBy = createdBy;
  }

  int get id => _id;

  String get comment => _comment;

  List<PostCommentModel>? get children => _children;

  set children(List<PostCommentModel>? newChildren) {
    _children = newChildren;
  }

  List<PostUserModel>? get likes => _likes;

  set likes(List<PostUserModel>? newLikes) {
    _likes = newLikes;
  }

  PostUserModel? get createdBy => _createdBy;

  set createdBy(PostUserModel? model) {
    _createdBy = model;
  }

  int? get likeCount => _likeCount ?? 0;

  set likeCount(int? newLikeCount) {
    _likeCount = newLikeCount;
  }

  String? get image => _image;

  DateTime? get createdOn => _createdOn;

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
        id: json['id'],
        comment: json['comment'],
        likeCount: json['like_count'],
        likes: json['like'] != null
            ? (json['like'] as List)
                .map((e) => PostUserModel.fromJson(e))
                .toList()
            : [],
        children: json['child'] != null
            ? (json['child'] as List)
                .map((e) => PostCommentModel.fromJson(e))
                .toList()
            : [],
        image: json['image'],
        createdBy: json['created_by'] != null
            ? PostUserModel.fromJson(json['created_by'])
            : null,
        createdOn: (json['created_on']) != null
            ? DateTime.parse(json['created_on'])
            : DateTime.now());
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = _id;
    json['comment'] = _comment;
    if (_likes != null) json['like'] = _likes!.map((e) => e.toJson()).toList();
    if (_children != null) {
      json['child'] = _children!.map((e) => e.toJson()).toList();
    }
    if (_image != null) json['image'] = _image;
    if (_createdBy != null) json['created_by'] = _createdBy!.toJson();
    if (_createdOn != null) json['created_on'] = _createdOn!.toIso8601String();
    json['like_count'] = _likeCount ?? 0;

    return json;
  }
}

class PostModel {
  int _id = 0;
  DateTime? _createdOn;
  PostContentModel? _content;
  String? _contentType;
  int? _likeCount;
  PostTopicModel? _topic;
  List<PostUserModel>? _likes = [];
  List<PostCommentModel>? _comments = [];

  PostModel(
      {required int id,
      DateTime? createdOn,
      PostContentModel? content,
      String? contentType,
      int? likeCount,
      PostTopicModel? topic,
      List<PostUserModel>? likes,
      List<PostCommentModel>? comments}) {
    _id = id;
    _createdOn = createdOn;
    _content = content;
    _contentType = contentType;
    _likeCount = likeCount;
    _topic = topic;
    _likes = likes;
    _comments = comments;
  }

  int get id => _id;

  DateTime? get createdOn => _createdOn;

  PostContentModel? get content => _content;

  String? get contentType => _contentType;

  int? get likeCount => _likeCount;

  set likeCount(int? newCount) {
    _likeCount = newCount;
  }

  PostTopicModel? get topic => _topic;

  List<PostUserModel>? get likes => _likes;

  set likes(List<PostUserModel>? newLikes) {
    _likes = newLikes;
  }

  List<PostCommentModel>? get comments => _comments;

  set comments(List<PostCommentModel>? newComments) {
    _comments = newComments;
  }

  bool isLikedByUser(int userId) {
    print(_likes);
    return _likes?.any((element) {
          print("Like id: ${element.id}, UserId: ${userId}");
          return element.id == userId;
        }) ??
        false;
  }

  // bool isVideoPost(){
  //   return gallery.first.mediaType == 2;
  // }

  factory PostModel.fromJson(dynamic json, {bool filters = false}) {
    return PostModel(
        id: json['id'],
        createdOn: json['created_on'] != null
            ? DateTime.parse(json['created_on'])
            : DateTime.now(),
        content: json['content'] != null
            ? PostContentModel.fromJson(json['content'])
            : null,
        contentType: json['content_type'],
        likeCount: json['like_count'],
        topic: json['topic'] != null
            ? PostTopicModel.fromJson(json['topic'])
            : null,
        likes: json['like'] != null
            ? (json['like'] as List)
                .map((e) => PostUserModel.fromJson(e))
                .toList()
            : [],
        comments: json['comments'] != null
            ? (json['comments'] as List)
                .map((e) => PostCommentModel.fromJson(e))
                .toList()
            : []);

    /*model.createDate =
        DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000).toUtc();*/

    //model.postTime = model.createDate.toString();//timeago.format(model.createDate!);

    // final days = model.createDate!.difference(DateTime.now()).inDays;
    // if (days == 0) {
    //   model.postTime = ApplicationLocalizations.of(
    //           NavigationService.instance.getCurrentStateContext())
    //       .translate('today_text');
    // } else if (days == 1) {
    //   model.postTime = ApplicationLocalizations.of(
    //           NavigationService.instance.getCurrentStateContext())
    //       .translate('yesterday_text');
    // } else {
    //   String dateString = DateFormat('MMM dd, yyyy').format(model.createDate!);
    //   String timeString = DateFormat('hh:ss a').format(model.createDate!);
    //   model.postTime =
    //       '$dateString ${ApplicationLocalizations.of(NavigationService.instance.getCurrentStateContext()).translate('at_text')} $timeString';
    // }
  }

// bool get containVideoPost {
//   return gallery.where((element) => element.isVideoPost()).isNotEmpty;
// }

/*bool get isMyPost {
    return user.id == getIt<UserProfileManager>().user!.id;
  }*/
}

class MentionedUsers {
  int id = 0;
  String userName = '';

  MentionedUsers();

  factory MentionedUsers.fromJson(dynamic json) {
    MentionedUsers model = MentionedUsers();
    model.id = json['user_id'];
    model.userName = json['username'].toString().toLowerCase();
    return model;
  }
}

// import 'dart:convert';

// TribeFeedResponse tribeFeedResponseFromJson(String str) =>
//     TribeFeedResponse.fromJson(json.decode(str));

// String tribeFeedResponseToJson(TribeFeedResponse data) =>
//     json.encode(data.toJson());

// class TribeFeedResponse {
//   int? count;
//   String? next;
//   dynamic previous;
//   List<PostContentModel>? results;

//   TribeFeedResponse({
//     this.count,
//     this.next,
//     this.previous,
//     this.results,
//   });

//   factory TribeFeedResponse.fromJson(Map<String, dynamic> json) =>
//       TribeFeedResponse(
//         count: json["count"],
//         next: json["next"],
//         previous: json["previous"],
//         results:
//             List<PostContentModel>.from(json["results"].map((x) => PostContentModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "count": count,
//         "next": next,
//         "previous": previous,
//         "results": List<dynamic>.from(results!.map((x) => x.toJson())),
//       };
// }

// class PostContentModel {
//   int? id;
//   DateTime? createdOn;
//   Content? content;
//   String? contentType;
//   List<Comment>? comments;
//   List<PostUserModel>? like;
//   int? likeCount;
//   Topic? topic;

//   PostContentModel({
//     this.id,
//     this.createdOn,
//     this.content,
//     this.contentType,
//     this.comments,
//     this.like,
//     this.likeCount,
//     this.topic,
//   });

//   factory PostContentModel.fromJson(Map<String, dynamic> json) => PostContentModel(
//         id: json["id"],
//         createdOn: DateTime.parse(json["created_on"]),
//         content: Content.fromJson(json["content"]),
//         contentType: json["content_type"],
//         comments: List<Comment>.from(
//             json["comments"].map((x) => Comment.fromJson(x))),
//         like: List<PostUserModel>.from(json["like"].map((x) => PostUserModel.fromJson(x))),
//         likeCount: json["like_count"],
//         topic: json["topic"] != null ? Topic.fromJson(json["topic"]) : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "created_on": createdOn!.toIso8601String(),
//         "content": content!.toJson(),
//         "content_type": contentType,
//         "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
//         "like": List<dynamic>.from(like!.map((x) => x.toJson())),
//         "like_count": likeCount,
//         "topic": topic!.toJson(),
//       };
// }

// class Comment {
//   int? id;
//   String? comment;
//   List<Comment>? child;
//   List<PostUserModel>? like;
//   int? likeCount;
//   PostUserModel? createdBy;
//   dynamic image;
//   DateTime? createdOn;

//   Comment({
//     this.id,
//     this.comment,
//     this.child,
//     this.like,
//     this.likeCount,
//     this.createdBy,
//     this.image,
//     this.createdOn,
//   });

//   factory Comment.fromJson(Map<String, dynamic> json) => Comment(
//         id: json["id"],
//         comment: json["comment"],
//         child: List<Comment>.from(json["child"] == null
//             ? []
//             : List<Comment>.from(
//                 json["child"].map((x) => Comment.fromJson(x)))),
//         like: List<PostUserModel>.from(json["like"].map((x) => PostUserModel.fromJson(x))),
//         likeCount: json["like_count"],
//         createdBy: PostUserModel.fromJson(json["created_by"]),
//         image: json["image"],
//         createdOn: DateTime.parse(json["created_on"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "comment": comment,
//         "child": List<dynamic>.from(child!.map((x) => x.toJson())),
//         "like": List<dynamic>.from(like!.map((x) => x.toJson())),
//         "like_count": likeCount,
//         "created_by": createdBy!.toJson(),
//         "image": image,
//         "created_on": createdOn!.toIso8601String(),
//       };
// }

// class PostUserModel {
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? profilePic;
//   int? profileId;

//   PostUserModel({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.profilePic,
//     this.profileId,
//   });

//   factory PostUserModel.fromJson(Map<String, dynamic> json) => PostUserModel(
//         id: json["id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         email: json["email"],
//         profilePic: json["profile_pic"],
//         profileId: json["profile_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "first_name": firstNameValues.reverse[firstName],
//         "last_name": lastName,
//         "email": emailValues.reverse[email],
//         "profile_pic": profilePic,
//         "profile_id": profileId,
//       };
// }

// enum Email { JOYSOCIETY1_SHARKLASERS_COM, JUSTIN_GMAIL_COM, TEST1_GMAIL_COM }

// final emailValues = EnumValues({
//   "joysociety1@sharklasers.com": Email.JOYSOCIETY1_SHARKLASERS_COM,
//   "justin@gmail.com": Email.JUSTIN_GMAIL_COM,
//   "test1@gmail.com": Email.TEST1_GMAIL_COM
// });

// enum FirstName { JUSTIN, TEST, TEST1 }

// final firstNameValues = EnumValues({
//   "Justin": FirstName.JUSTIN,
//   "test": FirstName.TEST,
//   "test1": FirstName.TEST1
// });

// class Content {
//   int? id;
//   String? question;
//   String? type;
//   List<FirstName>? answerChoice;
//   dynamic workshop;
//   PostUserModel? user;
//   int? topic;
//   List<dynamic>? answers;
//   List<String>? myAnswer;
//   dynamic tribe;
//   String? post;
//   DateTime? schedule;

//   Content({
//     this.id,
//     this.question,
//     this.type,
//     this.answerChoice,
//     this.workshop,
//     this.user,
//     this.topic,
//     this.answers,
//     this.myAnswer,
//     this.tribe,
//     this.post,
//     this.schedule,
//   });

//   factory Content.fromJson(Map<String, dynamic> json) => Content(
//         id: json["id"],
//         question: json["question"],
//         type: json["_type"],
//         answerChoice: List<FirstName>.from(json["answer_choice"] == null
//             ? []
//             : List<FirstName>.from(
//                 json["answer_choice"].map((x) => firstNameValues.map[x]))),
//         workshop: json["workshop"],
//         user: PostUserModel.fromJson(json["user"]),
//         topic: json["topic"],
//         answers: List<dynamic>.from(json["answers"] == null
//             ? []
//             : List<dynamic>.from(json["answers"].map((x) => x))),
//         myAnswer: List<String>.from(json["my_answer"] == null
//             ? []
//             : List<String>.from(json["my_answer"].map((x) => x))),
//         tribe: json["tribe"],
//         post: json["post"],
//         schedule: DateTime.parse(json["schedule"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "question": question,
//         "_type": type,
//         "answer_choice": List<dynamic>.from(
//             answerChoice!.map((x) => firstNameValues.reverse[x])),
//         "workshop": workshop,
//         "user": user!.toJson(),
//         "topic": topic,
//         "answers": List<dynamic>.from(answers!.map((x) => x)),
//         "my_answer": List<dynamic>.from(myAnswer!.map((x) => x)),
//         "tribe": tribe,
//         "post": post,
//         "schedule": schedule!.toIso8601String(),
//       };
// }

// class Topic {
//   int? id;
//   String? name;
//   dynamic contributor;
//   dynamic description;
//   dynamic color;
//   dynamic backgroundImage;
//   int? order;

//   Topic({
//     this.id,
//     this.name,
//     this.contributor,
//     this.description,
//     this.color,
//     this.backgroundImage,
//     this.order,
//   });

//   factory Topic.fromJson(Map<String, dynamic> json) => Topic(
//         id: json["id"],
//         name: json["name"],
//         contributor: json["contributor"],
//         description: json["description"],
//         color: json["color"],
//         backgroundImage: json["background_image"],
//         order: json["order"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "contributor": contributor,
//         "description": description,
//         "color": color,
//         "background_image": backgroundImage,
//         "order": order,
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
