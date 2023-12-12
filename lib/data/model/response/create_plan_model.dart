import 'dart:ffi';

class CreatePlanModel {
  int? _id = 0;
  String? _name;
  String? _internal_note;
  String? _sales_pitch;
  String? _description;
  String? _benefits;
  String? _image;
  int? _display_price;
  int? _discount;
  int? _offer_price;
  String? _payment_type;
  int? _days;
  bool? _is_active;

  CreatePlanModel(
      {
        int? id,
        String? name,
        String? internal_note,
        String? sales_pitch,
        String? description,
        String? benefits,
        String? image,
        int? display_price,
        int? discount,
        int? offer_price,
        String? payment_type,
        int? days,
        bool? is_active
      }) {
    this._id = id;
    this._name = name;
    this._internal_note = internal_note;
    this._sales_pitch = sales_pitch;
    this._description = description;
    this._benefits = benefits;
    this._image = image;
    this._display_price = display_price;
    this._discount = discount;
    this._offer_price  = offer_price;
    this._payment_type  = payment_type;
    this._days  = days;
    this._is_active  = is_active;
  }

  int? get id => _id;
  String get name => _name ?? "";
  String get internal_note => _internal_note ?? "";
  String get sales_pitch => _sales_pitch ?? "";
  String get description => _description ?? "";
  String get benefits => _benefits ?? "";
  String get image => _image ?? "";
  int? get display_price => _display_price ;
  int? get discount => _discount ;
  int? get offer_price => _offer_price ;
  String get payment_type => _payment_type ?? "";
  int? get days => _days ;
  bool? get is_active => _is_active;

  factory CreatePlanModel.fromJson(Map<String, dynamic> json) {
    return CreatePlanModel(
        id : json['id'],
        name : json['name'],
        internal_note : json['internal_note'],
        sales_pitch : json['sales_pitch'],
        description : json['description'],
        benefits : json['benefits'],
        image : json['image'],
        display_price : json['display_price'],
        discount : json['discount'],
        offer_price : json['offer_price'],
        payment_type : json['payment_type'],
        days : json['days'],
        is_active : json['is_active']
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
    if (this._internal_note != null) {
      data['internal_note'] = this._internal_note;
    }
    if (this._sales_pitch != null) {
      data['sales_pitch'] = this._sales_pitch;
    }
    if (this._description != null) {
      data['description'] = this._description;
    }
    if (this._benefits != null) {
      data['benefits'] = this._benefits;
    }
    if (this._image != null) {
      data['image'] = this._image;
    }
    if (this._display_price != null) {
      data['display_price'] = this._display_price;
    }
    if (this._discount != null) {
      data['discount'] = this._discount;
    }
    if (this._offer_price != null) {
      data['offer_price'] = this._offer_price;
    }
    if (this._payment_type != null) {
      data['payment_type'] = this._payment_type;
    }
    if (this._days != null) {
      data['days'] = this._days;
    }
    if (this._is_active != null) {
      data['is_active'] = this._is_active;
    }
    return data;
  }
}