import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/user_search_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GET /user/search?query={query}
// ─────────────────────────────────────────────────────────────────────────────

final class UserSearchApi {
  static final UserSearchApi _instance = UserSearchApi._internal();
  UserSearchApi._internal();
  static UserSearchApi get instance => _instance;

  Future<UserSearchModel> searchUsers({required String query}) async {
    final Response response = await getHttp(
      Endpoints.tagPeople(query),
    );

    final data = response.data;

    if (response.statusCode == 200 && data is Map<String, dynamic>) {
      final model = UserSearchModel.fromJson(data);

      if (model.success == true) {
        return model;
      }

      throw Exception(model.message ?? 'Search failed. Please try again.');
    }

    throw DataSource.DEFAULT.getFailure();
  }
}
