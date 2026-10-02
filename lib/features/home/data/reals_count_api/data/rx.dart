import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/data/reals_count_api/data/api.dart';
import 'package:stevenako_flutter/features/home/data/reals_count_api/model/relas_caount_model.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

final class ReelsCountRx extends RxResponseInt<ReelsCountModel> {
  final ReelsCountApi api = ReelsCountApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  ReelsCountRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<ReelsCountModel> get stream => dataFetcher.stream;

  Future<ReelsCountModel?> recordPostView({
    required dynamic postId,
  }) async {
    try {
      isLoading.value = true;
      final ReelsCountModel result = await api.recordPostView(postId: postId);
      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log('ReelsCountRx Error: $error', stackTrace: stackTrace);
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  ReelsCountModel handleSuccessWithReturn(ReelsCountModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  ReelsCountModel? handleErrorWithReturn(dynamic error) {
    log('Failed to record reel view: $error');
    return null;
  }
}
