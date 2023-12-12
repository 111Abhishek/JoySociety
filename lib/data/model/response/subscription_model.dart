// To parse this JSON data, do
//
//     final subscriptionOptionsModel = subscriptionOptionsModelFromJson(jsonString);

import 'dart:convert';

SubscriptionOptionsResponse subscriptionOptionsModelFromJson(String str) =>
    SubscriptionOptionsResponse.fromJson(json.decode(str));

String subscriptionOptionsModelToJson(SubscriptionOptionsResponse data) =>
    json.encode(data.toJson());

class SubscriptionOptionsResponse {
  int? count;
  dynamic next;
  dynamic previous;
  List<SubsOption>? results;

  SubscriptionOptionsResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory SubscriptionOptionsResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionOptionsResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<SubsOption>.from(
            json["results"].map((x) => SubsOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class SubsOption {
  int id;
  String name;
  String internalNote;
  String salesPitch;
  String description;
  String benefits;
  String image;
  int displayPrice;
  int discount;
  int offerPrice;
  String paymentType;
  int days;
  bool isActive;
  bool isDraft;

  SubsOption({
    required this.id,
    required this.name,
    required this.internalNote,
    required this.salesPitch,
    required this.description,
    required this.benefits,
    required this.image,
    required this.displayPrice,
    required this.discount,
    required this.offerPrice,
    required this.paymentType,
    required this.days,
    required this.isActive,
    required this.isDraft,
  });

  factory SubsOption.fromJson(Map<String, dynamic> json) => SubsOption(
        id: json["id"],
        name: json["name"],
        internalNote: json["internal_note"],
        salesPitch: json["sales_pitch"],
        description: json["description"],
        benefits: json["benefits"],
        image: json["image"],
        displayPrice: json["display_price"],
        discount: json["discount"],
        offerPrice: json["offer_price"],
        paymentType: json["payment_type"],
        days: json["days"],
        isActive: json["is_active"],
        isDraft: json["is_draft"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "internal_note": internalNote,
        "sales_pitch": salesPitch,
        "description": description,
        "benefits": benefits,
        "image": image,
        "display_price": displayPrice,
        "discount": discount,
        "offer_price": offerPrice,
        "payment_type": paymentType,
        "days": days,
        "is_active": isActive,
        "is_draft": isDraft,
      };
}
