import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/start_convergatosn_model.dart';
import '../../../helpers/toast.dart';
import '../../../networks/rx_base.dart';
import 'api.dart';

final class PostStartConversationRx
    extends RxResponseInt<PostStartConversationModel> {
  final PostStartConversationApi api = PostStartConversationApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PostStartConversationRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<PostStartConversationModel> get stream => dataFetcher.stream;

  Future<PostStartConversationModel?> startConversation({
    required dynamic receiverId,
  }) async {
    try {
      isLoading.value = true;

      final PostStartConversationModel result = await api.startConversation(
        receiverId: receiverId,
      );

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'PostStartConversationRx Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  PostStartConversationModel handleSuccessWithReturn(
    PostStartConversationModel data,
  ) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  PostStartConversationModel? handleErrorWithReturn(dynamic error) {
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
