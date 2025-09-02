import 'package:flutter/material.dart';
import 'package:mobiledev_test/core/services/hive_service.dart';
import 'package:mobiledev_test/core/services/service_locator.dart';

class UserSessionData {
  UserSessionData({required this.id, required this.email});
  final String id;
  final String email;
}

class AuthState extends ChangeNotifier {
  AuthState() {
    tryAutoLogin();
  }
  UserSessionData? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  UserSessionData? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    final hiveService = sl<HiveService>();
    final token = await hiveService.getAuthToken();

    if (token != null && token.isNotEmpty) {
      try {
        _isAuthenticated = true;
        final emailFromFakeToken = token
            .split('-at-')
            .first
            .replaceFirst('dummy-token-for-', '');
        _currentUser = UserSessionData(
          id: 'user-swamedia-test',
          email: emailFromFakeToken,
        );

        debugPrint(
          '[AuthState] Auto-login successful based on token existence.',
        );
      } catch (e) {
        debugPrint(
          '[AuthState] Auto-login failed (token parsing error): $e. Clearing token.',
        );
        await hiveService.deleteAuthToken();
        _isAuthenticated = false;
        _currentUser = null;
      }
    } else {
      _isAuthenticated = false;
      _currentUser = null;
      debugPrint('[AuthState] No token found for auto-login.');
    }
    _isLoading = false;
    notifyListeners();
  }

  void processLoginSuccess(String token, Map<String, dynamic> userPayload) {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = UserSessionData(
        id: userPayload['id'] as String? ?? '',
        email: userPayload['email'] as String? ?? '',
      );

      if (_currentUser!.id.isEmpty) {
        throw Exception('User ID missing in payload after login');
      }

      _isAuthenticated = true;
      debugPrint('[AuthState] Login processed for user: ${_currentUser?.id}');
    } catch (e) {
      debugPrint(
        '[AuthState] Error processing payload on login: $e. Forcing logout state.',
      );
      _isAuthenticated = false;
      _currentUser = null;
      sl<HiveService>().deleteAuthToken();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    final hiveService = sl<HiveService>();
    await hiveService.deleteAuthToken();
    _currentUser = null;
    _isAuthenticated = false;
    debugPrint('[AuthState] User logged out.');
    _isLoading = false;
    notifyListeners();
  }
}
