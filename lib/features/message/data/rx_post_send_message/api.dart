import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class PostSendMessageApi {
  static final PostSendMessageApi _instance = PostSendMessageApi._internal();

  PostSendMessageApi._internal();

  static PostSendMessageApi get instance => _instance;

  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
    File? file,
  }) async {
    try {
      final Map<String, dynamic> bodyMap = {
        'message': message,
      };

      if (file != null) {
        bodyMap['file'] = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }

      final FormData formData = FormData.fromMap(bodyMap);

      final Response response = await postHttp(
        Endpoints.conversationMessages(conversationId),
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return Map<String, dynamic>.from(response.data);
        }
        return {};
      }

      throw Exception('Failed to send message.');
    } on DioException catch (error, stackTrace) {
      log('Send Message API DioException: ${error.message}',
          stackTrace: stackTrace);
      final dynamic responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final dynamic msg = responseData['message'];
        if (msg is String && msg.isNotEmpty) {
          throw Exception(msg);
        }
      }
      throw Exception(error.message ?? 'Failed to send message.');
    } catch (error, stackTrace) {
      log('Send Message API Error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}
