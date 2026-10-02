import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../google_sing_in_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sends the Google access_token to the backend.
// POST /user/login/google
// Body: { "access_token": "ya29.xxx" }
// ─────────────────────────────────────────────────────────────────────────────

final class GoogleSignInApi {
  static final GoogleSignInApi _instance = GoogleSignInApi._internal();
  GoogleSignInApi._internal();
  static GoogleSignInApi get instance => _instance;

  Future<GoogleSignInModel> loginWithGoogle({
    required String accessToken,
  }) async {
    final formData = FormData.fromMap({
      'access_token': accessToken,
    });

    final Response response = await postHttp(
      Endpoints.googleLogin(),
      formData,
    );

    final data = response.data;

    if (response.statusCode == 200 && data is Map<String, dynamic>) {
      final model = GoogleSignInModel.fromJson(data);

      if (model.success == true) {
        return model;
      }

      throw Exception(
        model.message ?? 'Google login failed. Please try again.',
      );
    }

    throw DataSource.DEFAULT.getFailure();
  }
}
