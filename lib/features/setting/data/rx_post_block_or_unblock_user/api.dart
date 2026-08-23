import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class BlockOrUnblockUserApi {
  static final BlockOrUnblockUserApi _instance = BlockOrUnblockUserApi._internal();

  BlockOrUnblockUserApi._internal();

  static BlockOrUnblockUserApi get instance => _instance;

  Future<Map<String, dynamic>> blockOrUnblockUser(String userId) async {
    try {
      final Response response = await postHttp(
        Endpoints.blockOrUnblockUser(userId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = Map<String, dynamic>.from(
          json.decode(json.encode(response.data)),
        );
        return data;
      } else {
        throw Exception('Block/Unblock action failed.');
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 405) {
        final Response response = await getHttp(
          Endpoints.blockOrUnblockUser(userId),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = Map<String, dynamic>.from(
            json.decode(json.encode(response.data)),
          );
          return data;
        }
      }
      log('Block/Unblock User API Unexpected Error: $e');
      rethrow;
    }
  }
}
