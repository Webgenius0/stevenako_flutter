import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/post_flow_model.dart';
import 'api.dart';

final class PostFlowRx extends RxResponseInt<PostFlowModel> {
  final PostFlowApi api = PostFlowApi.instance;

  final ValueNotifier<bool> isLoading =
  ValueNotifier<bool>(false);

  PostFlowRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostFlowModel> get stream =>
      dataFetcher.stream;

  Future<PostFlowModel?> post({
    required int userId,
  }) async {
    try {
      isLoading.value = true;

      final PostFlowModel result =
      await api.flow(
        userId: userId,
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'PostFlow Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostFlowModel handleSuccessWithReturn(
      PostFlowModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  PostFlowModel? handleErrorWithReturn(
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