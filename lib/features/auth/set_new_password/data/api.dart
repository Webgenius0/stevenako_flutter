import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../model/set_new_passwrod_model.dart';

final class SetNewPasswordApi {
  static final SetNewPasswordApi _singleton = SetNewPasswordApi._internal();

  SetNewPasswordApi._internal();

  static SetNewPasswordApi get instance => _singleton;

  Future<PostSetNewPasswordModel> setNewPasswordFun({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String resetToken,
  }) async {
    final FormData data = FormData.fromMap({
      'email': email.trim(),
      'password': password.trim(),
      'password_confirmation': passwordConfirmation.trim(),
      'reset_token': resetToken.trim(),
    });

    final Response response = await postHttp(
      Endpoints.setNewPassword(),
      data,
    );

    final res = response.data;

    if (res is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        res['message']?.toString() ?? 'Password reset failed',
      );
    }

    return PostSetNewPasswordModel.fromJson(res);
  }
}
