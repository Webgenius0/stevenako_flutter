import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stevenako_flutter/features/auth/login/presentation/login_screen.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

class LogoutRx extends RxResponseInt<Map<String, dynamic>> {
  final api = LogoutApi.instance;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  LogoutRx({required super.empty, required super.dataFetcher});

  ValueStream<Map<String, dynamic>> get valueStreamData => dataFetcher.stream;

  Future<bool> logoutFun() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = await api.logoutFun();
      handleSuccessWithReturn(data);
      isLoading.value = false;
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      isLoading.value = false;
      return false;
    }
  }

  @override
  void handleSuccessWithReturn(data) async {
    String message =
        data["message"] ?? data["vendor_message"] ?? "Logged out successfully";

    await appData.erase();

    DioSingleton.instance.update('');

    ToastUtil.showShortToast(message);

    dataFetcher.sink.add(Map<String, dynamic>.from(data));
  }

  @override
  handleErrorWithReturn(error) {
    String errorMessage = "An unexpected error occurred";

    if (error is DioException) {
      if (error.response?.data is Map) {
        errorMessage =
            error.response?.data["message"] ??
            error.response?.data["vendor_message"] ??
            errorMessage;
      }

      if (error.type == DioExceptionType.connectionError) {
        errorMessage = "Check Your Network Connection";
      }

      if (errorMessage == 'Unauthenticated.') {
        DioSingleton.instance.update('');
        appData.erase();
        Get.offAll(() => const LoginScreen());
        return false;
      }
    } else if (error is String) {
      errorMessage = error;
    }

    ToastUtil.showShortToast(errorMessage);

    dataFetcher.sink.addError(errorMessage);
    return false;
  }
}
