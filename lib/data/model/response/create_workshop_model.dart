

  class CreateWorkshopModel {
  int? _order = 0;
  String? _title;
  String? _tagline;
  String? _description;
  String? _privacy;
  String? _table_of_content;
  String? _lessons;
  String? _sections;
  String? _instructors;

  CreateWorkshopModel(
      {
        int? order,
        String? title,
        String? tagline,
        String? description,
        String? privacy,
        String? table_of_content,
        String? lessons,
        String? sections,
        String? instructors
      }) {
    this._order = order;
    this._title = title;
    this._tagline = tagline;
    this._description = description;
    this._privacy = privacy;
    this._table_of_content = table_of_content;
    this._lessons = lessons;
    this._sections = sections;
    this._instructors = instructors;
  }

  int? get order => _order;
  String get title => _title ?? "";
  String get tagline => _tagline ?? "";
  String get description => _description ?? "";
  String get privacy => _privacy ?? "";
  String get table_of_content => _table_of_content ?? "";
  String get lessons => _lessons ?? "";
  String get sections => _sections ?? "";
  String get instructors => _instructors ?? "";

  factory CreateWorkshopModel.fromJson(Map<String, dynamic> json) {
    return CreateWorkshopModel(
        order : json['order'],
        title : json['title'],
        tagline : json['tagline'],
        description : json['description'],
        privacy : json['privacy'],
        table_of_content : json['table_of_content'],
        lessons : json['lessons'],
        sections : json['sections'],
        instructors : json['instructors']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._order != null) {
      data['order'] = this.order;
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
    return data;
  }
}