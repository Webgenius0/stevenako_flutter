import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/profile/model/user_post_like_model.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class UserPostLikeApi {
  static final UserPostLikeApi _singleton = UserPostLikeApi._internal();

  UserPostLikeApi._internal();

  static UserPostLikeApi get instance => _singleton;

  Future<UserPostLikeModel> toggleLike({
    required dynamic postId,
  }) async {
    try {
      final Response response = await postHttp(
        Endpoints.userPostLike(postId),
        {},
      );

      final dynamic responseData = response.data;

      if (response.statusCode != 200 && response.statusCode != 201) {
        if (responseData is Map<String, dynamic>) {
          throw Exception(
            responseData['message']?.toString() ?? 'Failed to update like status.',
          );
        }
        throw Exception('Failed to update like status.');
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