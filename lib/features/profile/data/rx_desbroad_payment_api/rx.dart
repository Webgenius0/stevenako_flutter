import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/get_payment_dashboard_model.dart';
import 'api.dart';

final class GetPaymentDashboardRx
    extends RxResponseInt<GetPaymentDashboardModel> {
  final GetPaymentDashboardApi api = GetPaymentDashboardApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetPaymentDashboardRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetPaymentDashboardModel> get stream => dataFetcher.stream;

  Future<GetPaymentDashboardModel?> getDashboard({int? userId}) async {
    try {
      isLoading.value = true;
      final GetPaymentDashboardModel result =
          await api.getDashboard(userId: userId);
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'GetPaymentDashboard Error: $error',
        stackTrace: stackTrace,
      );
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetPaymentDashboardModel handleSuccessWithReturn(
    GetPaymentDashboardModel data,
  ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetPaymentDashboardModel? handleErrorWithReturn(dynamic error) {
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
