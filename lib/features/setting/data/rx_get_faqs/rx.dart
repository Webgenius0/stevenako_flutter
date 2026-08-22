import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/faqs_model.dart';
import 'api.dart';

final class GetFaqsRx extends RxResponseInt<FaqsModel> {
  final GetFaqsApi api = GetFaqsApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetFaqsRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<FaqsModel> get stream => dataFetcher.stream;

  Future<FaqsModel?> getFaqs() async {
    try {
      isLoading.value = true;
      final FaqsModel data = await api.getFaqs();
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get Faqs Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  FaqsModel handleSuccessWithReturn(FaqsModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  FaqsModel? handleErrorWithReturn(dynamic error) {
    String message = 'Something went wrong. Please try again.';

    if (error is DioException) {
      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic apiMessage = responseData['message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      if (message == 'Something went wrong. Please try again.' &&
          error.message != null &&
          error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}
