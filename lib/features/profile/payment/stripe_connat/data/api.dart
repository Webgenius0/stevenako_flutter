import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/payment/stripe_connat/model/post_stripe_connat_mode.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class PostStripeConnectApi {
  static final PostStripeConnectApi _instance =
      PostStripeConnectApi._internal();

  PostStripeConnectApi._internal();

  static PostStripeConnectApi get instance => _instance;

  Future<PostStripeConnectModel> getConnectUrl() async {
    try {
      Response response;
      try {
        response = await postHttp(Endpoints.stripeConnect());
      } on DioException catch (dioErr) {
        if (dioErr.response?.statusCode == 405) {
          response = await getHttp(Endpoints.stripeConnect());
        } else {
          rethrow;
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          response.data is String
              ? json.decode(response.data as String)
              : response.data as Map,
        );
        return PostStripeConnectModel.fromJson(data);
      } else {
        throw Exception('Failed to generate Stripe Connect onboarding URL.');
      }
    } catch (error, stackTrace) {
      log('Stripe Connect API Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
