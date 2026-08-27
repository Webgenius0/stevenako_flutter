import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'package:stevenako_flutter/features/profile/model/get_my_photo_post_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetMyPhotoPostRx
    extends RxResponseInt<GetMyPhotoPostModel> {
  final GetMyPhotoPostApi api = GetMyPhotoPostApi.instance;

  final ValueNotifier<bool> isLoading =
  ValueNotifier<bool>(false);

  GetMyPhotoPostRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetMyPhotoPostModel> get stream =>
      dataFetcher.stream;

  Future<GetMyPhotoPostModel?> getData() async {
    try {
      isLoading.value = true;

      final GetMyPhotoPostModel data =
      await api.getData();

      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'GetMyPhotoPost Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetMyPhotoPostModel handleSuccessWithReturn(
      GetMyPhotoPostModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetMyPhotoPostModel? handleErrorWithReturn(
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