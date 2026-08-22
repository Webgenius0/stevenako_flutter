import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class DeleteUserApi {
  static final DeleteUserApi _singleton = DeleteUserApi._internal();

  DeleteUserApi._internal();

  static DeleteUserApi get instance => _singleton;

  Future<Map<String, dynamic>> deleteUserFun() async {
    try {
      final Response response = await deleteHttp(
        Endpoints.deleteUser(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          json.decode(json.encode(response.data)),
        );
        return data;
      } else {
        throw Exception('Delete user account failed');
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 405) {
        final Response response = await postHttp(
          Endpoints.deleteUser(),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = Map<String, dynamic>.from(
            json.decode(json.encode(response.data)),
          );
          return data;
        }
      }
      rethrow;
    }
  }
}
