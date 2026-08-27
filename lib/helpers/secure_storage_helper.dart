import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';

final class SecureStorageHelper {
  SecureStorageHelper._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static FlutterSecureStorage get instance => _storage;

  static Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, s) {
      log('SecureStorage write error ($key): $e', stackTrace: s);
    }
  }

  static Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e, s) {
      log('SecureStorage read error ($key): $e', stackTrace: s);
      return null;
    }
  }

  static Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e, s) {
      log('SecureStorage delete error ($key): $e', stackTrace: s);
    }
  }

  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, s) {
      log('SecureStorage deleteAll error: $e', stackTrace: s);
    }
  }

  // Auth Token Specific Helpers
  static Future<void> saveAccessToken(String token) async {
    await write(key: kKeyAccessToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await read(key: kKeyAccessToken);
  }

  static Future<void> clearAccessToken() async {
    await delete(key: kKeyAccessToken);
  }
}
