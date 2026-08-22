import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class ChangePasswordApi {
  static final ChangePasswordApi _singleton = ChangePasswordApi._internal();

  ChangePasswordApi._internal();

  static ChangePasswordApi get instance => _singleton;

  Future<Map<String, dynamic>> changePasswordFun({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final FormData data = FormData.fromMap({
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    });

    final Response response = await postHttp(
      Endpoints.changePassword(),
      data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = Map<String, dynamic>.from(
        json.decode(json.encode(response.data)),
      );
      return data;
    } else {
      throw Exception('Password change failed');
    }
  }
}
