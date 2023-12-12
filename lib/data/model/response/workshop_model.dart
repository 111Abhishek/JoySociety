import 'package:joy_society/utill/app_constants.dart';

class WorkshopModel {
  int _id = 0;
  String? _title;
  String? _tagline;
  String? _description;
  String? _privacy;
  String? _table_of_content;
  String? _lessons;
  String? _sections;
  String? _instructors;
  String? _workshopImageUrl;
  int? _price;
  bool? _subscribed;
  bool? _joined;
  int? _order;

  WorkshopModel(
      {required int id,
      String? title,
      String? tagline,
      String? description,
      String? privacy,
      String? table_of_content,
      String? lessons,
      String? sections,
      String? instructors,
      String? workshopImageUrl,
      String? price,
      bool? subscribed,
      bool? joined,
      int? order}) {
    this._id = id;
    this._title = title;
    this._tagline = tagline;
    this._description = description;
    this._privacy = privacy;
    this._table_of_content = table_of_content;
    this._lessons = lessons;
    this._sections = sections;
    this._instructors = instructors;
    this._order = order;
    _price = _convertPrice(price);
    _workshopImageUrl = _convertWorkshopImageUrl(workshopImageUrl);
    _joined = joined ?? false;
    _subscribed = subscribed ?? false;
  }

  int get id => _id;
  String? get title => _title ?? "";
  String? get tagline => _tagline;
  String? get description => _description ?? "";
  String? get privacy => _privacy;
  String? get table_of_content => _table_of_content ?? "";
  String? get lessons => _lessons;
  String? get sections => _sections;
  String? get instructors => _instructors;
  String? get workshopImageUrl => _workshopImageUrl;
  int? get price => _price;
  int? get order => _order;
  bool? get joined => _joined;
  bool? get subscribed => _subscribed;

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
        id: json['id'],
        title: json['title'],
        tagline: json['tagline'],
        description: json['description'],
        privacy: json['privacy'],
        table_of_content: json['table_of_content'],
        lessons: json['lessons'],
        sections: json['sections'],
        instructors: json['instructors'],
        workshopImageUrl: json['workshopImageUrl'],
        order: json['order'],
        subscribed: json['subscribed'],
        joined: json['joined'],
        price: json['price']);
  }

  int? _convertPrice(String? price) {
    return int.parse(price ?? "0");
  }

  String _convertWorkshopImageUrl(String? rawUrl) {
    String convertedUrl = rawUrl ?? AppConstants.DEFAULT_WORKSHOP_IMAGE_URL;
    if (convertedUrl.startsWith("http://127.0.0.1:800")) {
      convertedUrl = AppConstants.DEFAULT_WORKSHOP_IMAGE_URL;
    }
    return convertedUrl;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._id != null) {
      data['id'] = this.id;
    }
    if (this._title != null) {
      data['title'] = this._title;
    }
    if (this._tagline != null) {
      data['tagline'] = this._tagline;
    }
    if (this._description != null) {
      data['description'] = this._description;
    }
    if (this._privacy != null) {
      data['privacy'] = this._privacy;
    }
    if (this._table_of_content != null) {
      data['table_of_content'] = this._table_of_content;
    }
    if (this._lessons != null) {
      data['lessons'] = this._lessons;
    }
    if (this._sections != null) {
      data['sections'] = this._sections;
    }
    if (this._instructors != null) {
      data['instructors'] = this._instructors;
    }
    if (this._order != null) {
      data['order'] = this._order;
    }
    if (_workshopImageUrl != null) {
      data['workshopImageUrl'] = _workshopImageUrl;
    }
    if (_price != null) {
      data['price'] = _price.toString();
    }
    if (_joined != null) {
      data['joined'] = _joined;
    }
    if (_subscribed != null) {
      data['subscribed'] = _subscribed;
    }
    return data;
  }
}
