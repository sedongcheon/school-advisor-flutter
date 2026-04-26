import 'package:dio/dio.dart';

import '../error/app_exception.dart';

/// `DioException` 을 도메인 예외(`AppException`) 로 변환한다.
///
/// 변환된 예외는 `handler.reject` 의 `error` 로 다시 흘려보내고,
/// 호출 측은 try/catch 에서 `AppException` 만 처리하면 된다.
class ErrorInterceptor extends Interceptor {
  const ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _toAppException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mapped,
        response: err.response,
        type: err.type,
        stackTrace: err.stackTrace,
      ),
    );
  }

  AppException _toAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(cause: err, stackTrace: err.stackTrace);
      case DioExceptionType.connectionError:
        return NetworkException(cause: err, stackTrace: err.stackTrace);
      case DioExceptionType.badCertificate:
        return NetworkException(cause: err, stackTrace: err.stackTrace);
      case DioExceptionType.cancel:
        return UnknownException(cause: err, stackTrace: err.stackTrace);
      case DioExceptionType.unknown:
        return UnknownException(cause: err, stackTrace: err.stackTrace);
      case DioExceptionType.badResponse:
        return _fromStatus(err);
    }
  }

  AppException _fromStatus(DioException err) {
    final status = err.response?.statusCode ?? 0;
    if (status == 401) {
      return UnauthorizedException(cause: err, stackTrace: err.stackTrace);
    }
    if (status == 400 || status == 422) {
      return ValidationException(cause: err, stackTrace: err.stackTrace);
    }
    if (status == 429) {
      return RateLimitException(cause: err, stackTrace: err.stackTrace);
    }
    if (status >= 500) {
      return ServerException(cause: err, stackTrace: err.stackTrace);
    }
    return UnknownException(cause: err, stackTrace: err.stackTrace);
  }
}
