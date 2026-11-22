import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/network/api_config.dart';

/// Creates the single, centrally configured HTTP client of the app.
///
/// Base URL, timeouts and headers are set here only once, so screens and
/// repositories never configure their own `Dio()` instance.
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      responseType: ResponseType.json,
      headers: const {'Accept': 'application/json'},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  return dio;
}

/// Exposes the shared [Dio] client through Riverpod.
///
/// A provider (instead of a static singleton) keeps the configuration in one
/// place while letting tests replace the client via
/// `dioProvider.overrideWithValue(...)`, so no real server is needed.
final dioProvider = Provider<Dio>((ref) {
  final dio = createDio();
  ref.onDispose(dio.close);
  return dio;
});
