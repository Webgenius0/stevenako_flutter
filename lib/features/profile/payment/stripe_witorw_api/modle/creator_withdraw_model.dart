class CreatorWithdrawModel {
  final bool? success;
  final String? message;
  final CreatorWithdrawData? data;
  final int? code;

  CreatorWithdrawModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory CreatorWithdrawModel.fromJson(Map<String, dynamic> json) {
    return CreatorWithdrawModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? CreatorWithdrawData.fromJson(
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

class CreatorWithdrawData {
  final WithdrawalItem? withdrawal;

  CreatorWithdrawData({
    this.withdrawal,
  });

  factory CreatorWithdrawData.fromJson(Map<String, dynamic> json) {
    return CreatorWithdrawData(
      withdrawal: json['withdrawal'] != null
          ? WithdrawalItem.fromJson(
              Map<String, dynamic>.from(json['withdrawal'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'withdrawal': withdrawal?.toJson(),
    };
  }
}

class WithdrawalItem {
  final dynamic id;
  final num? amount;
  final String? status;
  final String? createdAt;

  WithdrawalItem({
    this.id,
    this.amount,
    this.status,
    this.createdAt,
  });

  factory WithdrawalItem.fromJson(Map<String, dynamic> json) {
    return WithdrawalItem(
      id: json['id'],
      amount: json['amount'] is num
          ? json['amount'] as num
          : num.tryParse(json['amount']?.toString() ?? ''),
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
      'created_at': createdAt,
    };
  }
}
