import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/profile/model/get_my_vidoe_post_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetMyVideoPostRx
    extends RxResponseInt<GetMyVodeoPostModel> {
  final GetMyVideoPostApi api = GetMyVideoPostApi.instance;

  final ValueNotifier<bool> isLoading =
  ValueNotifier<bool>(false);

  GetMyVideoPostRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetMyVodeoPostModel> get stream =>
      dataFetcher.stream;

  Future<GetMyVodeoPostModel?> getVideo() async {
    try {
      isLoading.value = true;

      final GetMyVodeoPostModel data =
      await api.getVideo();

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'GetMyVideoPost Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetMyVodeoPostModel handleSuccessWithReturn(
      GetMyVodeoPostModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetMyVodeoPostModel? handleErrorWithReturn(
      dynamic error,
      ) {
    String message =
        'Something went wrong. Please try again.';

    if (error is Exception) {
      message = error
          .toString()
          .replaceFirst('Exception: ', '')
          .trim();

      if (message.isEmpty) {
        message =
        'Something went wrong. Please try again.';
      }
    } else if (error is String &&
        error.trim().isNotEmpty) {
      message = error.trim();
    }

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}