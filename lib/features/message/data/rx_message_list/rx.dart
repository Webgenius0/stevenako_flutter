// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/conversation_list_model.dart';
import 'api.dart';

final class GetConversationListRx
    extends RxResponseInt<ConversationListModel> {
  static const String _boxName = 'conversation_list_box';
  static const String _cacheKey = 'cached_conversations';

  final GetConversationListApi api = GetConversationListApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetConversationListRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<ConversationListModel> get stream => dataFetcher.stream;

  Future<Box?> _getBox() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        return Hive.box(_boxName);
      } else {
        return await Hive.openBox(_boxName);
      }
    } catch (e) {
      log('Hive Box Error: $e');
      return null;
    }
  }

  void _loadFromCache() async {
    try {
      final box = await _getBox();
      if (box != null) {
        final cachedData = box.get(_cacheKey);
        if (cachedData != null) {
          final Map<String, dynamic> jsonMap =
              Map<String, dynamic>.from(jsonDecode(jsonEncode(cachedData)));
          final model = ConversationListModel.fromJson(jsonMap);
          dataFetcher.sink.add(model);
        }
      }
    } catch (e) {
      log('Hive Load Cache Error: $e');
    }
  }

  Future<ConversationListModel?> getConversationList() async {
    _loadFromCache();

    try {
      if (!dataFetcher.hasValue || dataFetcher.value.data == null) {
        isLoading.value = true;
      }

      final ConversationListModel data = await api.getConversationList();
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get Conversation List Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<ConversationListModel?> getMessages() => getConversationList();

  @override
  ConversationListModel handleSuccessWithReturn(ConversationListModel data) {
    _saveToCache(data);

    dataFetcher.sink.add(data);
    return data;
  }

  void _saveToCache(ConversationListModel data) async {
    try {
      final box = await _getBox();
      if (box != null) {
        await box.put(_cacheKey, data.toJson());
      }
    } catch (e) {
      log('Hive Save Cache Error: $e');
    }
  }

  @override
  ConversationListModel? handleErrorWithReturn(dynamic error) {
    String message = 'Something went wrong. Please try again.';

    if (error is DioException) {
      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final dynamic apiMessage = responseData['message'];

        if (apiMessage is String && apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      if (message == 'Something went wrong. Please try again.' &&
          error.message != null &&
          error.message!.isNotEmpty) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    }

    ToastUtil.showShortToast(message);

    if (!dataFetcher.hasValue) {
      dataFetcher.sink.addError(message);
    }

    return null;
  }
}
