import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stevenako_flutter/features/home/model/user_post_model.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';

final class UserPostApi {
  static final UserPostApi _singleton = UserPostApi._internal();

  UserPostApi._internal();

  static UserPostApi get instance => _singleton;

  Future<UserPostModel> post({
    required String type,
    required String caption,
    required String locationName,
    required double locationLat,
    required double locationLng,
    required String privacySetting,
    required int allowComments,
    required int allowGifts,
    required List<int> taggedUserIds,
    File? video,
    File? photo,
    int? soundId,
  }) async {
    try {
      final Map<String, dynamic> mapData = {
        'type': type.trim(),
        'caption': caption.trim(),
        'location_name': locationName.trim(),
        'location_lat': locationLat,
        'location_lng': locationLng,
        'privacy_setting': privacySetting,
        'allow_comments': allowComments,
        'allow_gifts': allowGifts,
      };

      if (soundId != null) {
        mapData['sound_id'] = soundId;
      }

      for (int i = 0; i < taggedUserIds.length; i++) {
        mapData['tagged_user_ids[$i]'] = taggedUserIds[i];
      }

      final FormData data = FormData.fromMap(mapData);

      if (photo != null) {
        final filename = photo.path.split('/').last;

        data.files.add(MapEntry(
          'photos',
          await MultipartFile.fromFile(photo.path, filename: filename),
        ));
        data.files.add(MapEntry(
          'photos[]',
          await MultipartFile.fromFile(photo.path, filename: filename),
        ));
        data.files.add(MapEntry(
          'photos[0]',
          await MultipartFile.fromFile(photo.path, filename: filename),
        ));
        data.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(photo.path, filename: filename),
        ));
      }

      if (video != null) {
        final filename = video.path.split('/').last;
        data.files.add(MapEntry(
          'video',
          await MultipartFile.fromFile(video.path, filename: filename),
        ));
      }

      final Response response = await postHttp(
        Endpoints.userPost(),
        data,
      );

      final res = response.data;

      if (res is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response.statusCode != 200 &&
          response.statusCode != 201) {
        throw Exception(
          res['message']?.toString() ??
              'Failed to create post',
        );
      }

      return UserPostModel.fromJson(res);
    } on DioException catch (e) {
      String message = 'Something went wrong';

      if (e.response?.data is Map<String, dynamic>) {
        message = e.response?.data['message']?.toString() ??
            message;
      } else if (e.message != null) {
        message = e.message!;
      }

      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}