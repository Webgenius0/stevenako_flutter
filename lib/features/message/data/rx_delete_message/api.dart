import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class DeleteMessageApi {
  static final DeleteMessageApi _instance = DeleteMessageApi._internal();

  DeleteMessageApi._internal();

  static DeleteMessageApi get instance => _instance;

  Future<Map<String, dynamic>> deleteMessage(String messageId) async {
    try {
      final Response response = await deleteHttp(
        Endpoints.deleteMessage(messageId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return Map<String, dynamic>.from(response.data);
        }
        return {};
      }

      throw Exception('Failed to delete message');
    } on DioException catch (error, stackTrace) {
      log('Delete Message API DioException: ${error.message}',
          stackTrace: stackTrace);
      final dynamic responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final dynamic message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }
      throw Exception(error.message ?? 'Failed to delete message');
    } catch (error, stackTrace) {
      log('Delete Message API Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
