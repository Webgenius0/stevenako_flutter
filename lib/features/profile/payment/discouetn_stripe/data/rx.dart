import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/profile/payment/discouetn_stripe/data/api.dart';
import 'package:stevenako_flutter/features/profile/payment/discouetn_stripe/model/disconnect_stripe_model.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

final class DisconnectStripeRx extends RxResponseInt<DisconnectStripeModel> {
  final DisconnectStripeApi api = DisconnectStripeApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  DisconnectStripeRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<DisconnectStripeModel> get stream => dataFetcher.stream;

  Future<DisconnectStripeModel?> disconnect() async {
    try {
      isLoading.value = true;
      final DisconnectStripeModel result = await api.disconnect();
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'DisconnectStripeRx Error: $error',
        stackTrace: stackTrace,
      );
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  DisconnectStripeModel handleSuccessWithReturn(DisconnectStripeModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  DisconnectStripeModel? handleErrorWithReturn(dynamic error) {
    String message = 'Failed to disconnect Stripe account.';

    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map && responseData['message'] != null) {
        message = responseData['message'].toString();
      } else if (error.message != null && error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    }

    ToastUtil.showShortToast(message);
    return null;
  }
}
