import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/payment/top_up_stripe/model/top_up_stripe_model.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class TopUpStripeApi {
  static final TopUpStripeApi _instance = TopUpStripeApi._internal();

  TopUpStripeApi._internal();

  static TopUpStripeApi get instance => _instance;

  Future<TopUpStripeModel> createDeposit({
    required num amount,
    String? successUrl,
    String? cancelUrl,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        'amount': amount,
      };

      if (successUrl != null && successUrl.trim().isNotEmpty) {
        bodyData['success_url'] = successUrl.trim();
      }
      if (cancelUrl != null && cancelUrl.trim().isNotEmpty) {
        bodyData['cancel_url'] = cancelUrl.trim();
      }

      final FormData formData = FormData.fromMap(bodyData);

      final Response response = await postHttp(
        Endpoints.walletDeposit(),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          response.data is String
              ? json.decode(response.data as String)
              : response.data as Map,
        );
        return TopUpStripeModel.fromJson(data);
      } else {
        throw Exception('Failed to create deposit session.');
      }
    } catch (error, stackTrace) {
      log('TopUp Stripe API Unexpected Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
