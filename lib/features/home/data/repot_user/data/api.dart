import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/data/repot_user/model/repot_user_model.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class ReportPostApi {
  static final ReportPostApi _instance = ReportPostApi._internal();

  ReportPostApi._internal();

  static ReportPostApi get instance => _instance;

  Future<ReportPostModel> reportPost({
    required dynamic postId,
    required String reason,
    required String description,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        'reason': reason,
        'description': description,
      });

      final Response response = await postHttp(
        Endpoints.reportPost(postId),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          response.data is String
              ? json.decode(response.data as String)
              : response.data as Map,
        );
        return ReportPostModel.fromJson(data);
      } else {
        throw Exception('Failed to report post.');
      }
    } catch (error, stackTrace) {
      log('Report Post API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
