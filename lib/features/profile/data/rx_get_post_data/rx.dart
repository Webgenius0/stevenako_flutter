import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/get_post_model.dart';
import 'api.dart';

final class GetPostDataRx extends RxResponseInt<GetPostModel> {
  final GetPostDataApi api = GetPostDataApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetPostDataRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetPostModel> get stream => dataFetcher.stream;

  Future<GetPostModel?> getPostData() async {
    try {
      isLoading.value = true;

      final GetPostModel data = await api.getPostData();

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'GetPostData Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetPostModel handleSuccessWithReturn(
    GetPostModel data,
  ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetPostModel? handleErrorWithReturn(
    dynamic error,
  ) {
    String message = 'Something went wrong. Please try again.';

    if (error is Exception) {
      message = error
          .toString()
          .replaceFirst('Exception: ', '')
          .trim();

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
