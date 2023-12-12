class TribeModel {
  int? _id = 0;
  String? _title;
  String? _tagline;
  String? _description;
  String? _privacy;
  String? _tribe_url;
  String? _group;
  int? _order;
  String? _joined;
  int? _memberCount;

  TribeModel(
      {int? id,
      String? title,
      String? tagline,
      String? description,
      String? privacy,
      String? tribe_url,
      String? group,
      int? order,
      String? joined,
      int? memberCount}) {
    this._id = id;
    this._title = title;
    this._tagline = tagline;
    this._description = description;
    this._privacy = privacy;
    this._tribe_url = tribe_url;
    this._group = group;
    this._order = order;
    this._joined = joined;
    this._memberCount = memberCount;
  }

  int? get id => _id;
  String? get title => _title ?? "";
  String? get tagline => _tagline;
  String? get description => _description ?? "";
  String? get privacy => _privacy;
  String? get tribe_url => _tribe_url ?? "";
  String? get group => _group;
  int? get order => _order;
  int? get membercount => _memberCount;
  String? get joined => _joined;

  factory TribeModel.fromJson(Map<String, dynamic> json) {
    return TribeModel(
        id: json['id'],
        title: json['title'],
        tagline: json['tagline'],
        description: json['description'],
        privacy: json['privacy'],
        tribe_url: json['tribe_url'],
        group: json['group'],
        joined: json['joined'],
        memberCount: json['member_count'],
        order: json['order']);
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
    //if (this._tribe_url != null) {
    data['tribe_url'] = this._tribe_url;
    //}
    //if (this._group != null) {
    data['group'] = this._group;
    //}
    if (this._order != null) {
      data['order'] = this._order;
    }
    return data;
  }
}
