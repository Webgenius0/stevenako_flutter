class PostStripeConnectModel {
  final bool? success;
  final String? message;
  final StripeConnectData? data;
  final int? code;

  PostStripeConnectModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory PostStripeConnectModel.fromJson(Map<String, dynamic> json) {
    return PostStripeConnectModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? StripeConnectData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map))
          : null,
      code: json['code'] is int
          ? json['code'] as int
          : int.tryParse(json['code']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'code': code,
    };
  }
}

class StripeConnectData {
  final String? url;
  final String? stripeConnectId;

  StripeConnectData({
    this.url,
    this.stripeConnectId,
  });

  factory StripeConnectData.fromJson(Map<String, dynamic> json) {
    return StripeConnectData(
      url: json['url'] as String?,
      stripeConnectId: json['stripe_connect_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'stripe_connect_id': stripeConnectId,
    };
  }
}
