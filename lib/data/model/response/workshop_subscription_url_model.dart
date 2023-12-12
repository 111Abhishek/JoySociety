class WorkshopSubscriptionUrlModel {
  String _checkoutSessionUrl = "";

  WorkshopSubscriptionUrlModel({required String checkoutSessionUrl}) {
    _checkoutSessionUrl = checkoutSessionUrl;
  }

  String get checkoutSessionUrl => _checkoutSessionUrl;

  factory WorkshopSubscriptionUrlModel.fromJson(Map<String, dynamic> data) {
    return WorkshopSubscriptionUrlModel(
        checkoutSessionUrl: data["checkout_session_url"] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["checkout_session_url"] = _checkoutSessionUrl;

    return data;
  }
}
