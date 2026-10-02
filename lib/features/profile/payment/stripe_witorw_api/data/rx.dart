import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/profile/payment/stripe_witorw_api/data/api.dart';
import 'package:stevenako_flutter/features/profile/payment/stripe_witorw_api/modle/creator_withdraw_model.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

final class CreatorWithdrawRx extends RxResponseInt<CreatorWithdrawModel> {
  final CreatorWithdrawApi api = CreatorWithdrawApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  String? lastErrorMessage;
  bool lastErrorIsStripeVerification = false;

  CreatorWithdrawRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<CreatorWithdrawModel> get stream => dataFetcher.stream;

  Future<CreatorWithdrawModel?> requestWithdrawal({
    required num amount,
  }) async {
    lastErrorMessage = null;
    lastErrorIsStripeVerification = false;
    try {
      isLoading.value = true;
      final CreatorWithdrawModel result = await api.withdraw(amount: amount);
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'CreatorWithdrawRx Error: $error',
        stackTrace: stackTrace,
      );
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  CreatorWithdrawModel handleSuccessWithReturn(CreatorWithdrawModel data) {
    lastErrorMessage = null;
    lastErrorIsStripeVerification = false;
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  CreatorWithdrawModel? handleErrorWithReturn(dynamic error) {
    String message = 'Failed to submit withdrawal request.';

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

    lastErrorMessage = message;
    final lower = message.toLowerCase();
    if (lower.contains('stripe') ||
        lower.contains('connect') ||
        lower.contains('verification') ||
        lower.contains('bank account')) {
      lastErrorIsStripeVerification = true;
    } else {
      lastErrorIsStripeVerification = false;
    }

    ToastUtil.showShortToast(message);
    return null;
  }
}
