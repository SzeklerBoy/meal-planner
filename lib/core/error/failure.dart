/// Application-level errors.
///
/// The data layer turns technical exceptions (e.g. `DioException`,
/// `FormatException`) into one of these, so the UI only has to show
/// [message] and never deals with HTTP or parsing details.
sealed class Failure implements Exception {
  const Failure();

  String get message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  String get message => "You're offline. Check your connection and try again.";
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure();

  @override
  String get message => "The server is taking too long. Please try again.";
}

final class ServerFailure extends Failure {
  const ServerFailure([this.statusCode]);

  final int? statusCode;

  @override
  String get message => "We couldn't load the recipes. Please try again later.";
}

final class ParsingFailure extends Failure {
  const ParsingFailure([this.details]);

  final String? details;

  @override
  String get message => 'We received unexpected data. Please try again later.';
}

final class UnknownFailure extends Failure {
  const UnknownFailure([this.error]);

  final Object? error;

  @override
  String get message => 'Something went wrong. Please try again.';
}
