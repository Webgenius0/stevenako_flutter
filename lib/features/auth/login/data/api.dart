import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../model/login_model.dart';

final class SigninApi {
  static final SigninApi _instance = SigninApi._internal();

  SigninApi._internal();

  static SigninApi get instance => _instance;

  Future<PostLoginModel> signInFun({
    required String email,
    required String password,
  }) async {
    final formData = FormData.fromMap({
      'email': email.trim(),
      'password': password,
    });

    final Response response = await postHttp(
      Endpoints.login(),
      formData,
    );

    final data = response.data;

    if (response.statusCode == 200 &&
        data is Map<String, dynamic>) {
      final model = PostLoginModel.fromJson(data);

      if (model.success == true) {
        return model;
      }

      throw Exception(
        model.message ?? 'Login failed. Please try again.',
      );
    }

    throw DataSource.DEFAULT.getFailure();
  }
}