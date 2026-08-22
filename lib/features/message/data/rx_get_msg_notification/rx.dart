// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/toast.dart';
import '../../../../networks/rx_base.dart';
import '../../model/msg_notification_model.dart';
import 'api.dart';

final class GetMsgNotificationRx extends RxResponseInt<MsgNotificationModel> {
  static const String _boxName = 'msg_notification_box';
  static const String _cacheKey = 'cached_notifications';

  final GetMsgNotificationApi api = GetMsgNotificationApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetMsgNotificationRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<MsgNotificationModel> get stream => dataFetcher.stream;

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
          final model = MsgNotificationModel.fromJson(jsonMap);
          dataFetcher.sink.add(model);
        }
      }
    } catch (e) {
      log('Hive Load Cache Error: $e');
    }
  }

  Future<MsgNotificationModel?> getMsgNotification() async {
    // 1. Load cached data from Hive immediately for instant rendering
    _loadFromCache();

    try {
      // 2. Only show loading spinner if we have no current data in stream
      if (!dataFetcher.hasValue || dataFetcher.value.data == null) {
        isLoading.value = true;
      }

      final MsgNotificationModel data = await api.getMsgNotification();
      return handleSuccessWithReturn(data);
    } catch (error, stackTrace) {
      log(
        'Get Msg Notification Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  MsgNotificationModel handleSuccessWithReturn(MsgNotificationModel data) {
    // Save fresh response to Hive cache asynchronously
    _saveToCache(data);

    dataFetcher.sink.add(data);
    return data;
  }

  void _saveToCache(MsgNotificationModel data) async {
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
  MsgNotificationModel? handleErrorWithReturn(dynamic error) {
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

    // If we have cached data, don't break the UI stream with an error
    if (!dataFetcher.hasValue) {
      dataFetcher.sink.addError(message);
    }

    return null;
  }
}
