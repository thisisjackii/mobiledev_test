import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobiledev_test/features/login/models/login_response.dart';

class LoginException implements Exception {
  LoginException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => 'LoginException: $message (Status: $statusCode)';
}

class LoginService {
  LoginService({required Dio dio});

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'fluttertest@swamedia.com' && password == 'fluttertest') {
      debugPrint('Login Sukses (Hardcoded)');

      final fakeToken =
          'dummy-token-for-$email-at-${DateTime.now().toIso8601String()}';
      final fakeUserResponse = {
        'id': 'user-swamedia-test',
        'email': email,
        'name': 'Flutter Test User',
      };

      return LoginResponse.fromJson({
        'success': true,
        'token': fakeToken,
        'user': fakeUserResponse,
      });
    } else {
      debugPrint('Login Gagal (Hardcoded)');
      throw LoginException(
        'Email / Password yang dimasukan salah.',
        statusCode: 401,
      );
    }
  }
}
