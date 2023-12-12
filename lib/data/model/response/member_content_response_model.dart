

class MemberContentResponseModel {
  String? _template;
  String? _invite_link;

  MemberContentResponseModel(
      {
        String? template,
        String? invite_link}) {
    this._template = template;
    this._invite_link = invite_link;
  }

  String? get template => _template ?? "";
  String? get invite_link => _invite_link ?? "";

  factory MemberContentResponseModel.fromJson(Map<String, dynamic> json) {
    return MemberContentResponseModel(
        template : json['template'],
        invite_link : json['invite_link']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._template != null) {
      data['template'] = this.template;
    }
    if (this._invite_link != null) {
      data['invite_link'] = this._invite_link;
    }
    return data;
  }
}