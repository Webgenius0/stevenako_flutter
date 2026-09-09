import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/post_my_commants_model.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';

import 'api.dart';

final class PostCommantsRx
    extends RxResponseInt<PostSentMyCommantsModel> {
  final PostCommantsApi api = PostCommantsApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PostCommantsRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostSentMyCommantsModel> get stream =>
      dataFetcher.stream;

  Future<PostSentMyCommantsModel?> post({
    required int userId,
    required String content,
  }) async {
    try {
      isLoading.value = true;

      final PostSentMyCommantsModel result = await api.sent(
        userId: userId,
        content: content,
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'PostCommants Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostSentMyCommantsModel handleSuccessWithReturn(
      PostSentMyCommantsModel data,
      ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  PostSentMyCommantsModel? handleErrorWithReturn(
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