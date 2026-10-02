class DisconnectStripeModel {
  final bool? status;
  final String? message;
  final dynamic data;
  final int? code;

  DisconnectStripeModel({
    this.status,
    this.message,
    this.data,
    this.code,
  });

  factory DisconnectStripeModel.fromJson(Map<String, dynamic> json) {
    return DisconnectStripeModel(
      status: (json['status'] ?? json['success']) as bool?,
      message: json['message'] as String?,
      data: json['data'],
      code: json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'code': code,
    };
  }
}
