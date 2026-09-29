import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/payment/stripe_witorw_api/modle/creator_withdraw_model.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class CreatorWithdrawApi {
  static final CreatorWithdrawApi _instance = CreatorWithdrawApi._internal();

  CreatorWithdrawApi._internal();

  static CreatorWithdrawApi get instance => _instance;

  Future<CreatorWithdrawModel> withdraw({
    required num amount,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        'amount': amount,
      });

      final Response response = await postHttp(
        Endpoints.creatorWithdraw(),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          response.data is String
              ? json.decode(response.data as String)
              : response.data as Map,
        );
        return CreatorWithdrawModel.fromJson(data);
      } else {
        throw Exception('Failed to submit withdrawal request.');
      }
    } catch (error, stackTrace) {
      log('Creator Withdraw API Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
