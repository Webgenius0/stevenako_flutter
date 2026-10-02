import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/profile/payment/sent_tip_api/data/api.dart';
import 'package:stevenako_flutter/features/profile/payment/sent_tip_api/model/sent_tip_model.dart';
import 'package:stevenako_flutter/helpers/toast.dart';

final class SentTipRx {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final BehaviorSubject<SentTipModel> _subject = BehaviorSubject<SentTipModel>();

  Stream<SentTipModel> get stream => _subject.stream;
  ValueStream<SentTipModel> get dataFetcher => _subject.stream;

  Future<SentTipModel?> sendTip({
    required dynamic creatorId,
    required num amount,
    dynamic postId,
  }) async {
    isLoading.value = true;
    try {
      final SentTipModel response = await SentTipApi.instance.sendTip(
        creatorId: creatorId,
        amount: amount,
        postId: postId,
      );

      _subject.add(response);
      if (response.message != null && response.message!.isNotEmpty) {
        ToastUtil.showShortToast(response.message!);
      }
      return response;
    } catch (error) {
      if (error is DioException) {
        dynamic resp = error.response?.data;
        if (resp is String) {
          try {
            resp = json.decode(resp);
          } catch (_) {}
        }
        if (resp is Map) {
          if (resp['errors'] is Map) {
            final errors = resp['errors'] as Map;
            final firstKey = errors.keys.firstOrNull;
            if (firstKey != null &&
                errors[firstKey] is List &&
                (errors[firstKey] as List).isNotEmpty) {
              ToastUtil.showShortToast(errors[firstKey][0].toString());
              return null;
            }
          }
          if (resp['message'] != null &&
              resp['message'].toString().trim().isNotEmpty) {
            ToastUtil.showShortToast(resp['message'].toString());
            return null;
          }
        }
        ToastUtil.showShortToast('Failed to send tip. Please try again.');
      } else {
        ToastUtil.showShortToast('Failed to send tip.');
      }
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    _subject.close();
    isLoading.dispose();
  }
}
