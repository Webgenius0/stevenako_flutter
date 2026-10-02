import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/profile/payment/stripe_connat/data/api.dart';
import 'package:stevenako_flutter/features/profile/payment/stripe_connat/model/post_stripe_connat_mode.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

final class PostStripeConnectRx extends RxResponseInt<PostStripeConnectModel> {
  final PostStripeConnectApi api = PostStripeConnectApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PostStripeConnectRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostStripeConnectModel> get stream => dataFetcher.stream;

  Future<PostStripeConnectModel?> createConnectAccount() async {
    try {
      isLoading.value = true;
      final PostStripeConnectModel result = await api.getConnectUrl();
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'PostStripeConnectRx Error: $error',
        stackTrace: stackTrace,
      );
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostStripeConnectModel handleSuccessWithReturn(PostStripeConnectModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  PostStripeConnectModel? handleErrorWithReturn(dynamic error) {
    String message = 'Something went wrong. Please try again.';

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
