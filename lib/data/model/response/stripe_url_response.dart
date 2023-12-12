// To parse this JSON data, do
//
//     final stripeUrlResponse = stripeUrlResponseFromJson(jsonString);

import 'dart:convert';

StripeUrlResponse stripeUrlResponseFromJson(String str) => StripeUrlResponse.fromJson(json.decode(str));

String stripeUrlResponseToJson(StripeUrlResponse data) => json.encode(data.toJson());

class StripeUrlResponse {
    String? data;

    StripeUrlResponse({
        this.data,
    });

    factory StripeUrlResponse.fromJson(Map<String, dynamic> json) => StripeUrlResponse(
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "data": data,
    };
}
