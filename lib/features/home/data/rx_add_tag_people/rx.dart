import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/home/model/get_tag_people_model.dart';
import 'package:stevenako_flutter/networks/rx_base.dart';

import '../../../../helpers/toast.dart';
import 'api.dart';

final class TagPeopleRx extends RxResponseInt<GetTapPeopleModel> {
  final TagPeopleApi api = TagPeopleApi.instance;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  TagPeopleRx({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetTapPeopleModel> get stream => dataFetcher.stream;

  Future<GetTapPeopleModel?> fetchTagPeople(String query) async {
    try {
      isLoading.value = true;

      final result = await api.fetchTagPeople(query);

      return handleSuccessWithReturn(result);
    } catch (error, stackTrace) {
      log(
        'TagPeopleRx Error: $error',
        stackTrace: stackTrace,
      );

      return handleErrorWithReturn(error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  GetTapPeopleModel handleSuccessWithReturn(GetTapPeopleModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  GetTapPeopleModel? handleErrorWithReturn(dynamic error) {
    final String message = error.toString().replaceFirst('Exception: ', '');

    ToastUtil.showShortToast(message);

    dataFetcher.sink.addError(message);

    return null;
  }
}
