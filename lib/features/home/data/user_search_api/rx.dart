import 'dart:developer' as dev;

import 'package:dio/dio.dart';

import '../../model/user_search_model.dart';
import 'api.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Handles search API calls with debounce-safe results.
// ─────────────────────────────────────────────────────────────────────────────

final class UserSearchRx {
  final UserSearchApi _api = UserSearchApi.instance;

  Future<List<SearchedUser>> searchUsers({required String query}) async {
    dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'UserSearch');
    dev.log('🔍 Searching users for query: "$query"', name: 'UserSearch');

    try {
      final response = await _api.searchUsers(query: query);
      final users = response.data?.users ?? [];

      dev.log('✅ Search SUCCESS — found ${users.length} user(s):', name: 'UserSearch');
      for (final u in users) {
        dev.log('   ├─ id       : ${u.id}', name: 'UserSearch');
        dev.log('   ├─ name     : ${u.name}', name: 'UserSearch');
        dev.log('   ├─ username : ${u.username}', name: 'UserSearch');
        dev.log('   └─ avatar   : ${u.avatar}', name: 'UserSearch');
      }
      dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'UserSearch');

      return users;
    } catch (e, st) {
      dev.log('❌ Search ERROR: $e', name: 'UserSearch', error: e, stackTrace: st);
      dev.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'UserSearch');

      if (e is DioException) {
        final msg = e.response?.data?['message'];
        if (msg != null) dev.log('   └─ API message: $msg', name: 'UserSearch');
      }

      return [];
    }
  }
}
