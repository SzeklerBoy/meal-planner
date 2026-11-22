import 'package:dio/dio.dart';
import 'package:meal_planner/core/error/failure.dart';

/// Translates a technical [DioException] into an application [Failure].
///
/// Cancelled requests (`CancelToken.isCancel`) are intentionally not treated
/// as failures: callers should check for them and simply ignore the result.
Failure mapDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => const TimeoutFailure(),
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse => ServerFailure(
      exception.response?.statusCode,
    ),
    DioExceptionType.badCertificate ||
    DioExceptionType.cancel ||
    DioExceptionType.unknown => UnknownFailure(exception.error ?? exception),
  };
}
