import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stevenako_flutter/helpers/toast.dart';

final class InternetCheckerService {
  InternetCheckerService._();

  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static bool _wasOffline = false;

  static Future<void> init() async {
    try {
      final List<ConnectivityResult> initialResults =
          await _connectivity.checkConnectivity();
      _handleConnectivityChange(initialResults, isInitial: true);

      _subscription?.cancel();
      _subscription =
          _connectivity.onConnectivityChanged.listen((results) {
        _handleConnectivityChange(results);
      });
    } catch (e, stackTrace) {
      log('Error initializing InternetCheckerService: $e', stackTrace: stackTrace);
    }
  }

  static void _handleConnectivityChange(
    List<ConnectivityResult> results, {
    bool isInitial = false,
  }) {
    final bool isOffline = results.contains(ConnectivityResult.none) ||
        results.isEmpty;

    if (isOffline) {
      log('=== Internet Connection Status: OFFLINE ===');
      _wasOffline = true;
      if (!isInitial) {
        ToastUtil.showNoInternetToast();
      }
    } else {
      log('=== Internet Connection Status: ONLINE (${results.join(", ")}) ===');
      if (_wasOffline) {
        _wasOffline = false;
        ToastUtil.showShortToast('Back online!');
      }
    }
  }

  static Future<bool> hasConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return !results.contains(ConnectivityResult.none) && results.isNotEmpty;
    } catch (e) {
      return true;
    }
  }

  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
