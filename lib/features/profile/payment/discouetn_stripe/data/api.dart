import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/payment/discouetn_stripe/model/disconnect_stripe_model.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class DisconnectStripeApi {
  static final DisconnectStripeApi _instance = DisconnectStripeApi._internal();

  DisconnectStripeApi._internal();

  static DisconnectStripeApi get instance => _instance;

  Future<DisconnectStripeModel> disconnect() async {
    try {
      Response response;
      try {
        response = await postHttp(Endpoints.stripeDisconnect());
      } on DioException catch (dioErr) {
        if (dioErr.response?.statusCode == 405) {
          response = await getHttp(Endpoints.stripeDisconnect());
        } else {
          rethrow;
        }
      }

      final data = Map<String, dynamic>.from(
        response.data is String
            ? json.decode(response.data as String)
            : response.data as Map,
      );
      return DisconnectStripeModel.fromJson(data);
    } catch (error, stackTrace) {
      log('Disconnect Stripe API Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
