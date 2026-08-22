import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/auth/profile_setup/model/sing_up_profiel_satep_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class PostSetProfileApi {
  static final PostSetProfileApi _singleton =
  PostSetProfileApi._internal();

  PostSetProfileApi._internal();

  static PostSetProfileApi get instance => _singleton;

  Future<PostSingUpProfielSatipModel> setProfile({
    String? name,
    String? username,
    required String bio,
    required String gender,
    required String dateOfBirth,
    File? avatar,
  }) async {
    final Map<String, dynamic> bodyMap = {
      'bio': bio.trim(),
      'gender': gender.trim().toLowerCase(),
      'date_of_birth': dateOfBirth.trim(),
    };

    if (name != null && name.trim().isNotEmpty) {
      bodyMap['name'] = name.trim();
    }

    if (username != null && username.trim().isNotEmpty) {
      bodyMap['username'] = username.trim().replaceAll('@', '');
    }

    if (avatar != null) {
      bodyMap['avatar'] = await MultipartFile.fromFile(
        avatar.path,
        filename: avatar.path.split('/').last,
      );
    }

    final FormData data = FormData.fromMap(bodyMap);

    final Response response = await postHttp(
      Endpoints.setProfile(),
      data,
    );

    final res = response.data;

    if (res is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        res['message']?.toString() ?? 'Profile update failed',
      );
    }

    return PostSingUpProfielSatipModel.fromJson(res);
  }
}