import 'dart:convert';

class PostFlowModel {
  bool? success;
  String? message;
  PostFlowData? data;
  int? code;

  PostFlowModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  PostFlowModel copyWith({
    bool? success,
    String? message,
    PostFlowData? data,
    int? code,
  }) {
    return PostFlowModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  factory PostFlowModel.fromRawJson(String str) {
    return PostFlowModel.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory PostFlowModel.fromJson(Map<String, dynamic> json) {
    return PostFlowModel(
      success: json['success'] is bool
          ? json['success']
          : null,
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? PostFlowData.fromJson(json['data'])
          : null,
      code: json['code'] is int
          ? json['code']
          : int.tryParse(
        json['code']?.toString() ?? '',
      ),
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

class PostFlowData {
  bool? isFollowing;

  PostFlowData({
    this.isFollowing,
  });

  PostFlowData copyWith({
    bool? isFollowing,
  }) {
    return PostFlowData(
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  factory PostFlowData.fromRawJson(String str) {
    return PostFlowData.fromJson(json.decode(str));
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  factory PostFlowData.fromJson(Map<String, dynamic> json) {
    return PostFlowData(
      isFollowing: _parseBool(json['is_following']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_following': isFollowing,
    };
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      if (value == 1) return true;
      if (value == 0) return false;
    }

    if (value is String) {
      final String normalized = value
          .trim()
          .toLowerCase();

      if (normalized == 'true' || normalized == '1') {
        return true;
      }

      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    return null;
  }
}