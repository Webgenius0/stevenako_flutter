class GetWalletModel {
  final bool? success;
  final String? message;
  final WalletData? data;
  final int? code;

  GetWalletModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory GetWalletModel.fromJson(Map<String, dynamic> json) => GetWalletModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : WalletData.fromJson(json["data"] as Map<String, dynamic>),
        code: json["code"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}

class WalletData {
  final WalletInfo? wallet;

  WalletData({this.wallet});

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        wallet: json["wallet"] == null
            ? null
            : WalletInfo.fromJson(json["wallet"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "wallet": wallet?.toJson(),
      };
}

class WalletInfo {
  final num? totalEarnings;
  final num? viewsEarnings;
  final num? tipsEarnings;
  final num? withdrawnAmount;
  final num? pendingWithdrawalAmount;
  final num? availableBalance;
  final String? currency;
  final String? stripeConnectId;
  final bool? isEligibleForWithdrawal;

  WalletInfo({
    this.totalEarnings,
    this.viewsEarnings,
    this.tipsEarnings,
    this.withdrawnAmount,
    this.pendingWithdrawalAmount,
    this.availableBalance,
    this.currency,
    this.stripeConnectId,
    this.isEligibleForWithdrawal,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) => WalletInfo(
        totalEarnings: json["total_earnings"] as num?,
        viewsEarnings: json["views_earnings"] as num?,
        tipsEarnings: json["tips_earnings"] as num?,
        withdrawnAmount: json["withdrawn_amount"] as num?,
        pendingWithdrawalAmount: json["pending_withdrawal_amount"] as num?,
        availableBalance: json["available_balance"] as num?,
        currency: json["currency"] as String?,
        stripeConnectId: json["stripe_connect_id"] as String?,
        isEligibleForWithdrawal: json["is_eligible_for_withdrawal"] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "total_earnings": totalEarnings,
        "views_earnings": viewsEarnings,
        "tips_earnings": tipsEarnings,
        "withdrawn_amount": withdrawnAmount,
        "pending_withdrawal_amount": pendingWithdrawalAmount,
        "available_balance": availableBalance,
        "currency": currency,
        "stripe_connect_id": stripeConnectId,
        "is_eligible_for_withdrawal": isEligibleForWithdrawal,
      };
}
