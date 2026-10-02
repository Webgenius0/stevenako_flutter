class SentTipModel {
  bool? success;
  String? message;
  TipData? data;
  int? code;

  SentTipModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory SentTipModel.fromJson(Map<String, dynamic> json) {
    return SentTipModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? TipData.fromJson(json['data']) : null,
      code: json['code'],
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

class TipData {
  dynamic tipId;
  num? amount;
  num? platformFee;
  num? netToCreator;

  TipData({
    this.tipId,
    this.amount,
    this.platformFee,
    this.netToCreator,
  });

  factory TipData.fromJson(Map<String, dynamic> json) {
    return TipData(
      tipId: json['tip_id'],
      amount: json['amount'],
      platformFee: json['platform_fee'],
      netToCreator: json['net_to_creator'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tip_id': tipId,
      'amount': amount,
      'platform_fee': platformFee,
      'net_to_creator': netToCreator,
    };
  }
}
