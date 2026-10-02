import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class DeletePostRx extends RxResponseInt<bool> {
  final DeletePostApi api = DeletePostApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  DeletePostRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<bool> get stream => dataFetcher.stream;

  Future<bool> deletePost(dynamic postId) async {
    try {
      isLoading.value = true;
      final bool result = await api.deletePost(postId);
      handleSuccessWithReturn(result);
      return result;
    } catch (error, stackTrace) {
      log('Delete post error: $error', stackTrace: stackTrace);
      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  bool handleSuccessWithReturn(bool data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  bool handleErrorWithReturn(dynamic error) {
    dataFetcher.sink.add(false);
    return false;
  }
}
