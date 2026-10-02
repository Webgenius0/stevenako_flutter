class TopUpStripeModel {
  final bool? success;
  final String? message;
  final TopUpStripeData? data;
  final int? code;

  TopUpStripeModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory TopUpStripeModel.fromJson(Map<String, dynamic> json) =>
      TopUpStripeModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : TopUpStripeData.fromJson(json["data"] as Map<String, dynamic>),
        code: json["code"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}

class TopUpStripeData {
  final int? depositId;
  final num? amount;
  final String? currency;
  final String? checkoutUrl;
  final String? sessionId;
  final String? clientSecret;
  final String? stripePaymentIntentId;

  TopUpStripeData({
    this.depositId,
    this.amount,
    this.currency,
    this.checkoutUrl,
    this.sessionId,
    this.clientSecret,
    this.stripePaymentIntentId,
  });

  factory TopUpStripeData.fromJson(Map<String, dynamic> json) =>
      TopUpStripeData(
        depositId: json["deposit_id"] as int?,
        amount: json["amount"] as num?,
        currency: json["currency"] as String?,
        checkoutUrl: json["checkout_url"] as String?,
        sessionId: json["session_id"] as String?,
        clientSecret: json["client_secret"] as String?,
        stripePaymentIntentId: json["stripe_payment_intent_id"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "deposit_id": depositId,
        "amount": amount,
        "currency": currency,
        "checkout_url": checkoutUrl,
        "session_id": sessionId,
        "client_secret": clientSecret,
        "stripe_payment_intent_id": stripePaymentIntentId,
      };
}
