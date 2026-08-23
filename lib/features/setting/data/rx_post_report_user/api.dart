import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class ReportUserApi {
  static final ReportUserApi _instance = ReportUserApi._internal();

  ReportUserApi._internal();

  static ReportUserApi get instance => _instance;

  Future<Map<String, dynamic>> reportUser({
    required String userId,
    required String reason,
    required String description,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        'reason': reason,
        'description': description,
      });

      final Response response = await postHttp(
        Endpoints.reportUser(userId),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          json.decode(json.encode(response.data)),
        );
        return data;
      } else {
        throw Exception('Failed to report user.');
      }
    } catch (error, stackTrace) {
      log('Report User API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
