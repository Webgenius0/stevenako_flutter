import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

final class CommentActionsApi {
  static final CommentActionsApi instance = CommentActionsApi._internal();

  CommentActionsApi._internal();

  Future<bool> editComment({
    required dynamic commentId,
    required String content,
  }) async {
    try {
      final Response response = await putHttp(
        Endpoints.userComment(commentId),
        FormData.fromMap({'content': content}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      log('EditComment Error: $e', stackTrace: stackTrace);
      try {
        final Response response = await postHttp(
          Endpoints.userComment(commentId),
          FormData.fromMap({
            'content': content,
            '_method': 'PUT',
          }),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (_) {
        return false;
      }
    }
  }

  Future<bool> deleteComment({
    required dynamic commentId,
  }) async {
    try {
      final Response response = await deleteHttp(
        Endpoints.userComment(commentId),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, stackTrace) {
      log('DeleteComment Error: $e', stackTrace: stackTrace);
      try {
        final Response response = await postHttp(
          Endpoints.userComment(commentId),
          FormData.fromMap({'_method': 'DELETE'}),
        );
        return response.statusCode == 200 || response.statusCode == 204;
      } catch (_) {
        return false;
      }
    }
  }
}
