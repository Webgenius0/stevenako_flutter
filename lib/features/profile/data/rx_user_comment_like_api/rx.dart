import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/user_post_like_model.dart';
import 'api.dart';

final class UserCommentLikeRx extends RxResponseInt<UserPostLikeModel> {
  final UserCommentLikeApi api = UserCommentLikeApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  UserCommentLikeRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<UserPostLikeModel> get stream => dataFetcher.stream;

  Future<UserPostLikeModel?> toggleLike({
    required dynamic commentId,
  }) async {
    try {
      isLoading.value = true;

      final UserPostLikeModel result = await api.toggleLike(
        commentId: commentId,
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'UserCommentLikeRx Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  UserPostLikeModel handleSuccessWithReturn(UserPostLikeModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  UserPostLikeModel? handleErrorWithReturn(dynamic error) {
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
