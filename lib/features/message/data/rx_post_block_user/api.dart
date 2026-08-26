import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class BlockUserApi {
  static final BlockUserApi _instance = BlockUserApi._internal();

  BlockUserApi._internal();

  static BlockUserApi get instance => _instance;

  Future<Map<String, dynamic>> blockUser(String userId) async {
    try {
      final Response response = await postHttp(
        Endpoints.blockUser(userId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          json.decode(json.encode(response.data)),
        );
        return data;
      } else {
        throw Exception('Block user action failed.');
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 405) {
        final Response response = await getHttp(
          Endpoints.blockUser(userId),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = Map<String, dynamic>.from(
            json.decode(json.encode(response.data)),
          );
          return data;
        }
      }
      log('Block User API Unexpected Error: $e');
      rethrow;
    }
  }
}
