import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobiledev_test/core/services/hive_service.dart';
import 'package:mobiledev_test/core/services/service_locator.dart';
import 'package:mobiledev_test/core/state/auth_state.dart';
import 'package:mobiledev_test/core/utils/logging_interceptor.dart';

Dio createDioInstance() {
  const baseUrl = 'https://placeholder.api.swamedia.com/api/v1/';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LoggingInterceptor());
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final hiveService = sl<HiveService>();
        final token = await hiveService.getAuthToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          if (sl.isRegistered<AuthState>()) {
            await sl<AuthState>().logout();
          }
        }
        return handler.next(e);
      },
    ),
  );
  return dio;
}
