import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/profile/payment/data/api.dart';
import 'package:stevenako_flutter/features/profile/payment/model/get_walit_model.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

final class GetWalletRx extends RxResponseInt<GetWalletModel> {
  final GetWalletApi api = GetWalletApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetWalletRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetWalletModel> get stream => dataFetcher.stream;

  Future<GetWalletModel?> getWallet() async {
    try {
      isLoading.value = true;
      final GetWalletModel result = await api.getWallet();
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'GetWallet Error: $error',
        stackTrace: stackTrace,
      );
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetWalletModel handleSuccessWithReturn(GetWalletModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetWalletModel? handleErrorWithReturn(dynamic error) {
    String message = 'Something went wrong. Please try again.';

    if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '').trim();
      if (message.isEmpty) {
        message = 'Something went wrong. Please try again.';
      }
    } else if (error is String && error.trim().isNotEmpty) {
      message = error.trim();
    }

    ToastUtil.showShortToast(message);
    dataFetcher.sink.addError(message);
    return null;
  }
}
