import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/data/repot_user/data/api.dart';
import 'package:stevenako_flutter/features/home/data/repot_user/model/repot_user_model.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

final class ReportPostRx extends RxResponseInt<ReportPostModel> {
  final ReportPostApi api = ReportPostApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  ReportPostRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<ReportPostModel> get stream => dataFetcher.stream;

  Future<ReportPostModel?> reportPost({
    required dynamic postId,
    required String reason,
    required String description,
  }) async {
    try {
      isLoading.value = true;
      final result = await api.reportPost(
        postId: postId,
        reason: reason,
        description: description,
      );
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'Report post error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  ReportPostModel handleSuccessWithReturn(ReportPostModel data) {
    final String message =
        data.message ?? 'Post reported successfully.';
    if (message.isNotEmpty) {
      ToastUtil.showShortToast(message);
    }
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  ReportPostModel? handleErrorWithReturn(dynamic error) {
    String message = 'Something went wrong. Please try again.';

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (error.message != null && error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceAll('Exception: ', '');
    }

    ToastUtil.showShortToast(message);
    return null;
  }
}
