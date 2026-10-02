import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class DeletePostApi {
  static final DeletePostApi _instance = DeletePostApi._internal();

  DeletePostApi._internal();

  static DeletePostApi get instance => _instance;

  Future<bool> deletePost(dynamic postId) async {
    try {
      final Response response = await deleteHttp(
        Endpoints.deletePost(postId),
      );

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e, stackTrace) {
      log('DeletePost Error: $e', stackTrace: stackTrace);
      // Fallback for backends requiring POST with _method: DELETE
      try {
        final Response response = await postHttp(
          Endpoints.deletePost(postId),
          FormData.fromMap({'_method': 'DELETE'}),
        );
        return response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204;
      } catch (_) {
        return false;
      }
    }
  }
}
