// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/conversation_details_model.dart';
import 'api.dart';

final class GetConversationMessagesRx
    extends RxResponseInt<ConversationDetailsModel> {
  static const String _boxName = 'conversation_messages_box';

  final GetConversationMessagesApi api = GetConversationMessagesApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetConversationMessagesRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<ConversationDetailsModel> get stream => dataFetcher.stream;

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

  void _loadFromCache(String cId) async {
    try {
      final box = await _getBox();
      if (box != null) {
        final cachedData = box.get('cached_messages_$cId');
        if (cachedData != null) {
          final Map<String, dynamic> jsonMap =
              Map<String, dynamic>.from(jsonDecode(jsonEncode(cachedData)));
          final model = ConversationDetailsModel.fromJson(jsonMap);
          dataFetcher.sink.add(model);
        }
      }
    } catch (e) {
      log('Hive Load Cache Error: $e');
    }
  }

  String? _lastCId;

  Future<ConversationDetailsModel?> getConversationMessages(String cId) async {
    if (_lastCId != cId) {
      _lastCId = cId;
      dataFetcher.sink.add(empty);
    }
    _loadFromCache(cId);

    try {
      if (!dataFetcher.hasValue || dataFetcher.value.data == null) {
        isLoading.value = true;
      }

      final ConversationDetailsModel data =
          await api.getConversationMessages(cId);
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get Conversation Messages Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  ConversationDetailsModel handleSuccessWithReturn(
      ConversationDetailsModel data) {
    if (_lastCId != null) {
      _saveToCache(_lastCId!, data);
    }

    dataFetcher.sink.add(data);
    return data;
  }

  void _saveToCache(String cId, ConversationDetailsModel data) async {
    try {
      final box = await _getBox();
      if (box != null) {
        await box.put('cached_messages_$cId', data.toJson());
      }
    } catch (e) {
      log('Hive Save Cache Error: $e');
    }
  }

  @override
  ConversationDetailsModel? handleErrorWithReturn(dynamic error) {
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
