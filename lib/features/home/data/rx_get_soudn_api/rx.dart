import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/get_soudn_modle.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

import '../../../../helpers/toast.dart';
import 'api.dart';

final class GetSoundRx extends RxResponseInt<GetuserModel> {
  final GetSoundApi api = GetSoundApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  GetSoundRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetuserModel> get stream => dataFetcher.stream;

  Future<GetuserModel?> fetchSounds() async {
    try {
      isLoading.value = true;

      final result = await api.fetchSounds();

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'GetSoundRx Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetuserModel handleSuccessWithReturn(GetuserModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetuserModel? handleErrorWithReturn(dynamic error) {
    final String message = error.toString().replaceFirst('Exception: ', '');

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}
