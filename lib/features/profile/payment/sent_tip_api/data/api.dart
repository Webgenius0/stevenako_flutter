import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/payment/sent_tip_api/model/sent_tip_model.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class SentTipApi {
  static final SentTipApi _instance = SentTipApi._internal();

  SentTipApi._internal();

  static SentTipApi get instance => _instance;

  Future<SentTipModel> sendTip({
    required dynamic creatorId,
    required num amount,
    dynamic postId,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        'creator_id': creatorId,
        'amount': amount,
      };

      if (postId != null) {
        bodyData['post_id'] = postId;
      }

      final FormData formData = FormData.fromMap(bodyData);

      final Response response = await postHttp(
        Endpoints.sendTip(),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          response.data is String
              ? json.decode(response.data as String)
              : response.data as Map,
        );
        return SentTipModel.fromJson(data);
      } else {
        throw Exception('Failed to send tip.');
      }
    } catch (error, stackTrace) {
      if (error is! DioException) {
        log('Sent Tip API Error: $error', stackTrace: stackTrace);
      }
      rethrow;
    }
  }
}
