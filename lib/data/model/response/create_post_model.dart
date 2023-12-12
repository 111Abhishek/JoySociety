class CreatePostModel {
  int? _id = 0;
  String? _post;
  String? _question;
  List<dynamic>? _answer_choice;
  String? _type;
  int? _workshop;
  int? _topic;
  int? _user;
  String? _tribe;
  String? _commnet;
  int? _timeline;
  dynamic? _image;
  dynamic? _parent;

  CreatePostModel({
    int? id,
    String? post,
    String? question,
    List<dynamic>? answer_choice,
    String? type,
    int? workshop,
    int? topic,
    int? user,
    String? tribe,
    String? commnet,
    int? timeline,
    dynamic image,
    dynamic? parent,
  }) {
    this._id = id;
    this._post = post;
    this._question = question;
    this._answer_choice = answer_choice;
    this._type = type;
    this._workshop = workshop;
    this._topic = topic;
    this._user = user;
    this._tribe = tribe;
    this._commnet = commnet;
    this._timeline= timeline;
    this._parent = parent;
  }

  factory CreatePostModel.addAnswerChoices(
    CreatePostModel createPostModel,
    List<dynamic>? answer_choice,
  ) {
    return CreatePostModel(
      id: createPostModel.id,
      post: createPostModel.post,
      question: createPostModel.question,
      answer_choice: answer_choice,
      type: createPostModel.type,
      workshop: createPostModel.workshop,
      topic: createPostModel.topic,
      user: createPostModel.user,
    );
  }

  int? get id => _id;
  String get post => _post ?? "";
  String get question => _question ?? "";
  List<dynamic> get answer_choice => _answer_choice ?? [];
  String get type => _type ?? "";
  int? get workshop => _workshop;
  int? get topic => _topic;
  int? get user => _user;

  factory CreatePostModel.fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
      id: json['id'],
      post: json['post'],
      question: json['question'],
      answer_choice: json['answer_choice'],
      type: json['_type'],
      workshop: json['workshop'],
      topic: json['topic'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._id != null) {
      data['id'] = this.id;
    }
    if (this._post != null) {
      data['post'] = this._post;
    }
    if (this._question != null) {
      data['question'] = this._question;
    }
    if (this._answer_choice != null) {
      data['answer_choice'] = this._answer_choice;
    }
    if (this._type != null) {
      data['_type'] = this._type;
    }
    if (this._workshop != null) {
      data['workshop'] = this._workshop;
    }
    if (this._topic != null) {
      data['topic'] = this._topic;
    }
    if (this._user != null) {
      data['user'] = this._user;
    }
    if (this._tribe != null) {
      data['tribe'] = this._tribe;
    }
    if (this._commnet != null) {
      data['comment'] = this._commnet;
    }
     if (this._timeline != null) {
      data['timeline'] = this._timeline;
    }
     if (this._image != null) {
      data['image'] = this._image;
    }
     if (this._parent != null) {
      data['parent'] = this._parent;
    }
    return data;
  }
}
