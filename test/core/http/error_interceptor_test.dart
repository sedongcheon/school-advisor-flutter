import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/core/error/app_exception.dart';
import 'package:school_advisor/core/http/error_interceptor.dart';

DioException _err({required DioExceptionType type, int? statusCode}) {
  final options = RequestOptions(path: '/test');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(requestOptions: options, statusCode: statusCode),
  );
}

class _Capturer extends ErrorInterceptorHandler {
  AppException? captured;

  @override
  void reject(
    DioException error, [
    bool callFollowingErrorInterceptor = false,
  ]) {
    final e = error.error;
    if (e is AppException) {
      captured = e;
    }
  }
}

void main() {
  const sut = ErrorInterceptor();

  test('connectionError → NetworkException', () {
    final h = _Capturer();
    sut.onError(_err(type: DioExceptionType.connectionError), h);
    expect(h.captured, isA<NetworkException>());
  });

  test('connectionTimeout → TimeoutException', () {
    final h = _Capturer();
    sut.onError(_err(type: DioExceptionType.connectionTimeout), h);
    expect(h.captured, isA<TimeoutException>());
  });

  test('badResponse 401 → UnauthorizedException', () {
    final h = _Capturer();
    sut.onError(_err(type: DioExceptionType.badResponse, statusCode: 401), h);
    expect(h.captured, isA<UnauthorizedException>());
  });

  test('badResponse 429 → RateLimitException', () {
    final h = _Capturer();
    sut.onError(_err(type: DioExceptionType.badResponse, statusCode: 429), h);
    expect(h.captured, isA<RateLimitException>());
  });

  test('badResponse 500 → ServerException', () {
    final h = _Capturer();
    sut.onError(_err(type: DioExceptionType.badResponse, statusCode: 500), h);
    expect(h.captured, isA<ServerException>());
  });

  test('badResponse 422 → ValidationException', () {
    final h = _Capturer();
    sut.onError(_err(type: DioExceptionType.badResponse, statusCode: 422), h);
    expect(h.captured, isA<ValidationException>());
  });
}
