import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/data/reals_count_api/model/relas_caount_model.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class ReelsCountApi {
  static final ReelsCountApi _singleton = ReelsCountApi._internal();

  ReelsCountApi._internal();

  static ReelsCountApi get instance => _singleton;

  Future<ReelsCountModel> recordPostView({
    required dynamic postId,
  }) async {
    try {
      final Response response = await postHttp(
        Endpoints.postView(postId),
        {},
      );

      final dynamic responseData = response.data;

      if (response.statusCode != 200 && response.statusCode != 201) {
        if (responseData is Map<String, dynamic>) {
          throw Exception(
            responseData['message']?.toString() ??
                'Failed to record post view.',
          );
        }
        throw Exception('Failed to record post view.');
      }

      final data = Map<String, dynamic>.from(
        responseData is String ? json.decode(responseData) : responseData as Map,
      );

      return ReelsCountModel.fromJson(data);
    } catch (error, stackTrace) {
      log('ReelsCountApi Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
