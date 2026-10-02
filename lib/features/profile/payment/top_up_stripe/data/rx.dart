import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/profile/payment/top_up_stripe/data/api.dart';
import 'package:stevenako_flutter/features/profile/payment/top_up_stripe/model/top_up_stripe_model.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

final class TopUpStripeRx extends RxResponseInt<TopUpStripeModel> {
  final TopUpStripeApi api = TopUpStripeApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  TopUpStripeRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<TopUpStripeModel> get stream => dataFetcher.stream;

  Future<TopUpStripeModel?> createDeposit({
    required num amount,
    String? successUrl,
    String? cancelUrl,
  }) async {
    try {
      isLoading.value = true;
      final TopUpStripeModel result = await api.createDeposit(
        amount: amount,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'TopUpStripe Error: $error',
        stackTrace: stackTrace,
      );
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  TopUpStripeModel handleSuccessWithReturn(TopUpStripeModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  TopUpStripeModel? handleErrorWithReturn(dynamic error) {
    String message = 'Something went wrong. Please try again.';

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (error.message != null && error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '').trim();
    }

    ToastUtil.showShortToast(message);
    dataFetcher.sink.addError(message);
    return null;
  }
}
