import 'dart:convert';

class GetPaymentDashboardModel {
  final bool? success;
  final String? message;
  final Data? data;
  final int? code;

  GetPaymentDashboardModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  GetPaymentDashboardModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) =>
      GetPaymentDashboardModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory GetPaymentDashboardModel.fromRawJson(String str) =>
      GetPaymentDashboardModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaymentDashboardModel.fromJson(Map<String, dynamic> json) =>
      GetPaymentDashboardModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: (json["code"] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "code": code,
  };
}

class Data {
  final Stats? stats;
  final List<GraphDatum>? graphData;
  final List<dynamic>? recentTips;
  final List<TopContent>? topContent;
  final TotalGift? totalGift;
  final Settings? settings;
  final List<dynamic>? recentWithdrawals;
  final StripeStatus? stripeStatus;

  Data({
    this.stats,
    this.graphData,
    this.recentTips,
    this.topContent,
    this.totalGift,
    this.settings,
    this.recentWithdrawals,
    this.stripeStatus,
  });

  Data copyWith({
    Stats? stats,
    List<GraphDatum>? graphData,
    List<dynamic>? recentTips,
    List<TopContent>? topContent,
    TotalGift? totalGift,
    Settings? settings,
    List<dynamic>? recentWithdrawals,
    StripeStatus? stripeStatus,
  }) =>
      Data(
        stats: stats ?? this.stats,
        graphData: graphData ?? this.graphData,
        recentTips: recentTips ?? this.recentTips,
        topContent: topContent ?? this.topContent,
        totalGift: totalGift ?? this.totalGift,
        settings: settings ?? this.settings,
        recentWithdrawals: recentWithdrawals ?? this.recentWithdrawals,
        stripeStatus: stripeStatus ?? this.stripeStatus,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
    graphData: json["graph_data"] == null
        ? []
        : List<GraphDatum>.from(
        json["graph_data"].map((x) => GraphDatum.fromJson(x))),
    recentTips: json["recent_tips"] == null
        ? []
        : List<dynamic>.from(json["recent_tips"]),
    topContent: json["top_content"] == null
        ? []
        : List<TopContent>.from(
        json["top_content"].map((x) => TopContent.fromJson(x))),
    totalGift: json["total_gift"] == null
        ? null
        : TotalGift.fromJson(json["total_gift"]),
    settings: json["settings"] == null
        ? null
        : Settings.fromJson(json["settings"]),
    recentWithdrawals: json["recent_withdrawals"] == null
        ? []
        : List<dynamic>.from(json["recent_withdrawals"]),
    stripeStatus: json["stripe_status"] == null
        ? null
        : StripeStatus.fromJson(json["stripe_status"]),
  );

  Map<String, dynamic> toJson() => {
    "stats": stats?.toJson(),
    "graph_data": graphData == null
        ? []
        : List<dynamic>.from(graphData!.map((x) => x.toJson())),
    "recent_tips": recentTips,
    "top_content": topContent == null
        ? []
        : List<dynamic>.from(topContent!.map((x) => x.toJson())),
    "total_gift": totalGift?.toJson(),
    "settings": settings?.toJson(),
    "recent_withdrawals": recentWithdrawals,
    "stripe_status": stripeStatus?.toJson(),
  };
}

class GraphDatum {
  final DateTime? date;
  final String? label;
  final num? views;
  final num? tips;

  GraphDatum({
    this.date,
    this.label,
    this.views,
    this.tips,
  });

  GraphDatum copyWith({
    DateTime? date,
    String? label,
    num? views,
    num? tips,
  }) =>
      GraphDatum(
        date: date ?? this.date,
        label: label ?? this.label,
        views: views ?? this.views,
        tips: tips ?? this.tips,
      );

  factory GraphDatum.fromRawJson(String str) =>
      GraphDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
    date: json["date"] == null ? null : DateTime.tryParse(json["date"].toString()),
    label: json["label"] as String?,
    views: json["views"] as num?,
    tips: json["tips"] as num?,
  );

  Map<String, dynamic> toJson() => {
    "date": date == null
        ? null
        : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "label": label,
    "views": views,
    "tips": tips,
  };
}

class Settings {
  final num? earningsRate;
  final String? formattedEarningsRate;
  final num? platformTipFee;
  final String? formattedPlatformTipFee;

  Settings({
    this.earningsRate,
    this.formattedEarningsRate,
    this.platformTipFee,
    this.formattedPlatformTipFee,
  });

  Settings copyWith({
    num? earningsRate,
    String? formattedEarningsRate,
    num? platformTipFee,
    String? formattedPlatformTipFee,
  }) =>
      Settings(
        earningsRate: earningsRate ?? this.earningsRate,
        formattedEarningsRate:
        formattedEarningsRate ?? this.formattedEarningsRate,
        platformTipFee: platformTipFee ?? this.platformTipFee,
        formattedPlatformTipFee:
        formattedPlatformTipFee ?? this.formattedPlatformTipFee,
      );

  factory Settings.fromRawJson(String str) =>
      Settings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    earningsRate: json["earnings_rate"] as num?,
    formattedEarningsRate: json["formatted_earnings_rate"] as String?,
    platformTipFee: json["platform_tip_fee"] as num?,
    formattedPlatformTipFee: json["formatted_platform_tip_fee"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "earnings_rate": earningsRate,
    "formatted_earnings_rate": formattedEarningsRate,
    "platform_tip_fee": platformTipFee,
    "formatted_platform_tip_fee": formattedPlatformTipFee,
  };
}

class Stats {
  final MetricStat? totalViews;
  final MetricStat? peakViewers;
  final DurationStat? duration;
  final MetricStat? newFollowers;

  Stats({
    this.totalViews,
    this.peakViewers,
    this.duration,
    this.newFollowers,
  });

  Stats copyWith({
    MetricStat? totalViews,
    MetricStat? peakViewers,
    DurationStat? duration,
    MetricStat? newFollowers,
  }) =>
      Stats(
        totalViews: totalViews ?? this.totalViews,
        peakViewers: peakViewers ?? this.peakViewers,
        duration: duration ?? this.duration,
        newFollowers: newFollowers ?? this.newFollowers,
      );

  factory Stats.fromRawJson(String str) => Stats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    totalViews: json["total_views"] == null
        ? null
        : MetricStat.fromJson(json["total_views"]),
    peakViewers: json["peak_viewers"] == null
        ? null
        : MetricStat.fromJson(json["peak_viewers"]),
    duration: json["duration"] == null
        ? null
        : DurationStat.fromJson(json["duration"]),
    newFollowers: json["new_followers"] == null
        ? null
        : MetricStat.fromJson(json["new_followers"]),
  );

  Map<String, dynamic> toJson() => {
    "total_views": totalViews?.toJson(),
    "peak_viewers": peakViewers?.toJson(),
    "duration": duration?.toJson(),
    "new_followers": newFollowers?.toJson(),
  };
}

class DurationStat {
  final String? value;
  final String? changePercentage;

  DurationStat({
    this.value,
    this.changePercentage,
  });

  DurationStat copyWith({
    String? value,
    String? changePercentage,
  }) =>
      DurationStat(
        value: value ?? this.value,
        changePercentage: changePercentage ?? this.changePercentage,
      );

  factory DurationStat.fromRawJson(String str) =>
      DurationStat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DurationStat.fromJson(Map<String, dynamic> json) => DurationStat(
    value: json["value"]?.toString(),
    changePercentage: json["change_percentage"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "change_percentage": changePercentage,
  };
}

class MetricStat {
  final num? value;
  final String? formatted;
  final String? changePercentage;

  MetricStat({
    this.value,
    this.formatted,
    this.changePercentage,
  });

  MetricStat copyWith({
    num? value,
    String? formatted,
    String? changePercentage,
  }) =>
      MetricStat(
        value: value ?? this.value,
        formatted: formatted ?? this.formatted,
        changePercentage: changePercentage ?? this.changePercentage,
      );

  factory MetricStat.fromRawJson(String str) =>
      MetricStat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetricStat.fromJson(Map<String, dynamic> json) => MetricStat(
    value: json["value"] as num?,
    formatted: json["formatted"] as String?,
    changePercentage: json["change_percentage"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "formatted": formatted,
    "change_percentage": changePercentage,
  };
}

class StripeStatus {
  final String? stripeConnectId;
  final bool? stripeOnboardingCompleted;
  final bool? isEligibleForWithdrawal;

  StripeStatus({
    this.stripeConnectId,
    this.stripeOnboardingCompleted,
    this.isEligibleForWithdrawal,
  });

  StripeStatus copyWith({
    String? stripeConnectId,
    bool? stripeOnboardingCompleted,
    bool? isEligibleForWithdrawal,
  }) =>
      StripeStatus(
        stripeConnectId: stripeConnectId ?? this.stripeConnectId,
        stripeOnboardingCompleted:
        stripeOnboardingCompleted ?? this.stripeOnboardingCompleted,
        isEligibleForWithdrawal:
        isEligibleForWithdrawal ?? this.isEligibleForWithdrawal,
      );

  factory StripeStatus.fromRawJson(String str) =>
      StripeStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StripeStatus.fromJson(Map<String, dynamic> json) => StripeStatus(
    stripeConnectId: json["stripe_connect_id"]?.toString(),
    stripeOnboardingCompleted: json["stripe_onboarding_completed"] as bool?,
    isEligibleForWithdrawal: json["is_eligible_for_withdrawal"] as bool?,
  );

  Map<String, dynamic> toJson() => {
    "stripe_connect_id": stripeConnectId,
    "stripe_onboarding_completed": stripeOnboardingCompleted,
    "is_eligible_for_withdrawal": isEligibleForWithdrawal,
  };
}

class TopContent {
  final int? rank;
  final int? id;
  final String? title;
  final String? type;
  final String? typeLabel;
  final num? viewsCount;
  final String? formattedViews;
  final num? earnings;
  final String? formattedEarnings;

  TopContent({
    this.rank,
    this.id,
    this.title,
    this.type,
    this.typeLabel,
    this.viewsCount,
    this.formattedViews,
    this.earnings,
    this.formattedEarnings,
  });

  TopContent copyWith({
    int? rank,
    int? id,
    String? title,
    String? type,
    String? typeLabel,
    num? viewsCount,
    String? formattedViews,
    num? earnings,
    String? formattedEarnings,
  }) =>
      TopContent(
        rank: rank ?? this.rank,
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        typeLabel: typeLabel ?? this.typeLabel,
        viewsCount: viewsCount ?? this.viewsCount,
        formattedViews: formattedViews ?? this.formattedViews,
        earnings: earnings ?? this.earnings,
        formattedEarnings: formattedEarnings ?? this.formattedEarnings,
      );

  factory TopContent.fromRawJson(String str) =>
      TopContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TopContent.fromJson(Map<String, dynamic> json) => TopContent(
    rank: (json["rank"] as num?)?.toInt(),
    id: (json["id"] as num?)?.toInt(),
    title: json["title"] as String?,
    type: json["type"] as String?,
    typeLabel: json["type_label"] as String?,
    viewsCount: json["views_count"] as num?,
    formattedViews: json["formatted_views"] as String?,
    earnings: json["earnings"] as num?,
    formattedEarnings: json["formatted_earnings"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "rank": rank,
    "id": id,
    "title": title,
    "type": type,
    "type_label": typeLabel,
    "views_count": viewsCount,
    "formatted_views": formattedViews,
    "earnings": earnings,
    "formatted_earnings": formattedEarnings,
  };
}

class TotalGift {
  final num? amount;
  final String? formatted;
  final String? formattedEur;

  TotalGift({
    this.amount,
    this.formatted,
    this.formattedEur,
  });

  TotalGift copyWith({
    num? amount,
    String? formatted,
    String? formattedEur,
  }) =>
      TotalGift(
        amount: amount ?? this.amount,
        formatted: formatted ?? this.formatted,
        formattedEur: formattedEur ?? this.formattedEur,
      );

  factory TotalGift.fromRawJson(String str) =>
      TotalGift.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalGift.fromJson(Map<String, dynamic> json) => TotalGift(
    amount: json["amount"] as num?,
    formatted: json["formatted"] as String?,
    formattedEur: json["formatted_eur"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "formatted": formatted,
    "formatted_eur": formattedEur,
  };
}