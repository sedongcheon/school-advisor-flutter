/// 앱 전체에서 사용하는 도메인 예외.
///
/// `error_mapper` 가 사용자 노출 메시지로 변환하므로,
/// UI 레이어는 이 타입만 캐치하고 raw `DioException` 은 보지 않는다.
sealed class AppException implements Exception {
  const AppException({required this.code, this.cause, this.stackTrace});

  /// `error_mapper` 의 키. 안정적인 식별자.
  final String code;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException(code: $code, cause: $cause)';
}

class NetworkException extends AppException {
  const NetworkException({super.cause, super.stackTrace})
    : super(code: 'network_error');
}

class TimeoutException extends AppException {
  const TimeoutException({super.cause, super.stackTrace})
    : super(code: 'timeout');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.cause, super.stackTrace})
    : super(code: 'unauthorized');
}

class RateLimitException extends AppException {
  const RateLimitException({super.cause, super.stackTrace})
    : super(code: 'rate_limited');
}

class QuotaExceededException extends AppException {
  const QuotaExceededException({super.cause, super.stackTrace})
    : super(code: 'quota_exceeded');
}

class ServerException extends AppException {
  const ServerException({super.cause, super.stackTrace})
    : super(code: 'server_error');
}

class ValidationException extends AppException {
  const ValidationException({super.cause, super.stackTrace})
    : super(code: 'validation_error');
}

class UnknownException extends AppException {
  const UnknownException({super.cause, super.stackTrace})
    : super(code: 'unknown');
}
