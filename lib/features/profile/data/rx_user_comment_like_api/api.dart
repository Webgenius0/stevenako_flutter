import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/model/user_post_like_model.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class UserCommentLikeApi {
  static final UserCommentLikeApi _singleton = UserCommentLikeApi._internal();

  UserCommentLikeApi._internal();

  static UserCommentLikeApi get instance => _singleton;

  Future<UserPostLikeModel> toggleLike({
    required dynamic commentId,
  }) async {
    try {
      final Response response = await postHttp(
        Endpoints.userCommentLike(commentId),
        {},
      );

      final dynamic responseData = response.data;

      if (response.statusCode != 200 && response.statusCode != 201) {
        if (responseData is Map<String, dynamic>) {
          throw Exception(
            responseData['message']?.toString() ??
                'Failed to update comment like status.',
          );
        }
        throw Exception('Failed to update comment like status.');
      }

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid response format.');
      }

      return UserPostLikeModel.fromJson(responseData);
    } catch (error) {
      rethrow;
    }
  }
}
