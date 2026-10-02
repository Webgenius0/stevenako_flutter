class GetPaymentDashboardModel {
  bool? success;
  String? message;
  DashboardData? data;
  int? code;

  GetPaymentDashboardModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory GetPaymentDashboardModel.fromJson(Map<String, dynamic> json) {
    return GetPaymentDashboardModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
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

class DashboardData {
  DashboardStats? stats;
  List<GraphData>? graphData;
  List<dynamic>? recentTips;
  List<TopContent>? topContent;
  TotalGift? totalGift;
  DashboardSettings? settings;
  List<dynamic>? recentWithdrawals;
  StripeStatus? stripeStatus;

  DashboardData({
    this.stats,
    this.graphData,
    this.recentTips,
    this.topContent,
    this.totalGift,
    this.settings,
    this.recentWithdrawals,
    this.stripeStatus,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      stats: json['stats'] != null && json['stats'] is Map<String, dynamic>
          ? DashboardStats.fromJson(json['stats'])
          : null,
      graphData: json['graph_data'] != null && json['graph_data'] is List
          ? (json['graph_data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((v) => GraphData.fromJson(v))
              .toList()
          : [],
      recentTips: json['recent_tips'] != null && json['recent_tips'] is List
          ? (json['recent_tips'] as List)
              .map((v) => v is Map<String, dynamic> ? RecentTip.fromJson(v) : v)
              .toList()
          : [],
      topContent: json['top_content'] != null && json['top_content'] is List
          ? (json['top_content'] as List)
              .whereType<Map<String, dynamic>>()
              .map((v) => TopContent.fromJson(v))
              .toList()
          : [],
      totalGift: json['total_gift'] != null && json['total_gift'] is Map<String, dynamic>
          ? TotalGift.fromJson(json['total_gift'])
          : null,
      settings: json['settings'] != null && json['settings'] is Map<String, dynamic>
          ? DashboardSettings.fromJson(json['settings'])
          : null,
      recentWithdrawals: json['recent_withdrawals'] ?? [],
      stripeStatus: json['stripe_status'] != null && json['stripe_status'] is Map<String, dynamic>
          ? StripeStatus.fromJson(json['stripe_status'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats?.toJson(),
      'graph_data': graphData?.map((v) => v.toJson()).toList(),
      'recent_tips': recentTips,
      'top_content': topContent?.map((v) => v.toJson()).toList(),
      'total_gift': totalGift?.toJson(),
      'settings': settings?.toJson(),
      'recent_withdrawals': recentWithdrawals,
      'stripe_status': stripeStatus?.toJson(),
    };
  }
}

class DashboardStats {
  StatItem? totalViews;
  StatItem? peakViewers;
  StatItem? duration;
  StatItem? newFollowers;

  DashboardStats({
    this.totalViews,
    this.peakViewers,
    this.duration,
    this.newFollowers,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalViews: json['total_views'] != null
          ? StatItem.fromJson(json['total_views'])
          : null,
      peakViewers: json['peak_viewers'] != null
          ? StatItem.fromJson(json['peak_viewers'])
          : null,
      duration: json['duration'] != null
          ? StatItem.fromJson(json['duration'])
          : null,
      newFollowers: json['new_followers'] != null
          ? StatItem.fromJson(json['new_followers'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_views': totalViews?.toJson(),
      'peak_viewers': peakViewers?.toJson(),
      'duration': duration?.toJson(),
      'new_followers': newFollowers?.toJson(),
    };
  }
}

class StatItem {
  dynamic value;
  String? formatted;
  String? changePercentage;

  StatItem({
    this.value,
    this.formatted,
    this.changePercentage,
  });

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      value: json['value'],
      formatted: json['formatted'],
      changePercentage: json['change_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'formatted': formatted,
      'change_percentage': changePercentage,
    };
  }
}

class GraphData {
  String? date;
  String? label;
  num? views;
  num? tips;

  GraphData({
    this.date,
    this.label,
    this.views,
    this.tips,
  });

  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      date: json['date'],
      label: json['label'],
      views: json['views'],
      tips: json['tips'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'label': label,
      'views': views,
      'tips': tips,
    };
  }
}

class TopContent {
  int? rank;
  int? id;
  String? title;
  String? type;
  String? typeLabel;
  num? viewsCount;
  String? formattedViews;
  num? earnings;
  String? formattedEarnings;

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

  factory TopContent.fromJson(Map<String, dynamic> json) {
    return TopContent(
      rank: json['rank'] is int ? json['rank'] : int.tryParse(json['rank']?.toString() ?? ''),
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title']?.toString(),
      type: json['type']?.toString(),
      typeLabel: json['type_label']?.toString(),
      viewsCount: json['views_count'] is num ? json['views_count'] : num.tryParse(json['views_count']?.toString() ?? ''),
      formattedViews: json['formatted_views']?.toString(),
      earnings: json['earnings'] is num ? json['earnings'] : num.tryParse(json['earnings']?.toString() ?? ''),
      formattedEarnings: json['formatted_earnings']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'id': id,
      'title': title,
      'type': type,
      'type_label': typeLabel,
      'views_count': viewsCount,
      'formatted_views': formattedViews,
      'earnings': earnings,
      'formatted_earnings': formattedEarnings,
    };
  }
}

class TotalGift {
  num? amount;
  String? formatted;
  String? formattedEur;

  TotalGift({
    this.amount,
    this.formatted,
    this.formattedEur,
  });

  factory TotalGift.fromJson(Map<String, dynamic> json) {
    return TotalGift(
      amount: json['amount'] is num ? json['amount'] : num.tryParse(json['amount']?.toString() ?? ''),
      formatted: json['formatted']?.toString(),
      formattedEur: json['formatted_eur']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'formatted': formatted,
      'formatted_eur': formattedEur,
    };
  }
}

class DashboardSettings {
  num? earningsRate;
  String? formattedEarningsRate;
  num? platformTipFee;
  String? formattedPlatformTipFee;

  DashboardSettings({
    this.earningsRate,
    this.formattedEarningsRate,
    this.platformTipFee,
    this.formattedPlatformTipFee,
  });

  factory DashboardSettings.fromJson(Map<String, dynamic> json) {
    return DashboardSettings(
      earningsRate: json['earnings_rate'] is num ? json['earnings_rate'] : num.tryParse(json['earnings_rate']?.toString() ?? ''),
      formattedEarningsRate: json['formatted_earnings_rate']?.toString(),
      platformTipFee: json['platform_tip_fee'] is num ? json['platform_tip_fee'] : num.tryParse(json['platform_tip_fee']?.toString() ?? ''),
      formattedPlatformTipFee: json['formatted_platform_tip_fee']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'earnings_rate': earningsRate,
      'formatted_earnings_rate': formattedEarningsRate,
      'platform_tip_fee': platformTipFee,
      'formatted_platform_tip_fee': formattedPlatformTipFee,
    };
  }
}

class StripeStatus {
  String? stripeConnectId;
  bool? stripeOnboardingCompleted;
  bool? isEligibleForWithdrawal;

  StripeStatus({
    this.stripeConnectId,
    this.stripeOnboardingCompleted,
    this.isEligibleForWithdrawal,
  });

  factory StripeStatus.fromJson(Map<String, dynamic> json) {
    return StripeStatus(
      stripeConnectId: json['stripe_connect_id'],
      stripeOnboardingCompleted: json['stripe_onboarding_completed'],
      isEligibleForWithdrawal: json['is_eligible_for_withdrawal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stripe_connect_id': stripeConnectId,
      'stripe_onboarding_completed': stripeOnboardingCompleted,
      'is_eligible_for_withdrawal': isEligibleForWithdrawal,
    };
  }
}

class RecentTip {
  int? id;
  num? amount;
  num? netAmount;
  String? formattedAmount;
  String? timeAgo;
  String? createdAt;
  TipSender? sender;

  RecentTip({
    this.id,
    this.amount,
    this.netAmount,
    this.formattedAmount,
    this.timeAgo,
    this.createdAt,
    this.sender,
  });

  factory RecentTip.fromJson(Map<String, dynamic> json) {
    return RecentTip(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      amount: json['amount'] is num ? json['amount'] : num.tryParse(json['amount']?.toString() ?? ''),
      netAmount: json['net_amount'] is num ? json['net_amount'] : num.tryParse(json['net_amount']?.toString() ?? ''),
      formattedAmount: json['formatted_amount']?.toString(),
      timeAgo: json['time_ago']?.toString(),
      createdAt: json['created_at']?.toString(),
      sender: json['sender'] != null && json['sender'] is Map<String, dynamic>
          ? TipSender.fromJson(json['sender'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'net_amount': netAmount,
      'formatted_amount': formattedAmount,
      'time_ago': timeAgo,
      'created_at': createdAt,
      'sender': sender?.toJson(),
    };
  }
}

class TipSender {
  int? id;
  String? name;
  String? username;
  String? avatar;

  TipSender({
    this.id,
    this.name,
    this.username,
    this.avatar,
  });

  factory TipSender.fromJson(Map<String, dynamic> json) {
    return TipSender(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
    };
  }
}
