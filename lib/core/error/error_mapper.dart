import 'package:dio/dio.dart';

import 'app_exception.dart';

/// `AppException.code` → 사용자 노출 한국어 메시지.
///
/// `DioException` 이 직접 들어와도 inner 의 `AppException` 을 우선 사용하고,
/// 없으면 `DioExceptionType` / status 를 보고 코드를 유추한다. 콘솔 스택트레이스나
/// 백엔드 원문은 사용자에게 노출하지 않는다.
String mapErrorToMessage(Object error) {
  if (error is AppException) {
    return _messageForCode(error.code);
  }
  if (error is DioException) {
    final inner = error.error;
    if (inner is AppException) {
      return _messageForCode(inner.code);
    }
    return _messageForCode(_codeFromDio(error));
  }
  return _messageForCode('unknown');
}

String _codeFromDio(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'timeout';
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return 'network_error';
    case DioExceptionType.cancel:
      return 'unknown';
    case DioExceptionType.badResponse:
      final s = e.response?.statusCode ?? 0;
      if (s == 401) return 'unauthorized';
      if (s == 400 || s == 422) return 'validation_error';
      if (s == 429) return 'rate_limited';
      if (s >= 500) return 'server_error';
      return 'unknown';
    case DioExceptionType.unknown:
      // socket-level transport 실패가 unknown 으로 흘러들어오는 경우가 많다.
      return 'network_error';
  }
}

String _messageForCode(String code) {
  switch (code) {
    case 'network_error':
      return '네트워크에 연결할 수 없어요. 잠시 후 다시 시도해 주세요.';
    case 'timeout':
      return '응답이 너무 오래 걸렸어요. 다시 시도해 주세요.';
    case 'unauthorized':
      return '기기 인증에 실패했어요. 앱을 재실행해 주세요.';
    case 'rate_limited':
      return '잠깐 천천히 부탁드려요. 잠시 후 다시 질문해 주세요.';
    case 'quota_exceeded':
      return '일일 이용 한도에 도달했어요. 이용권을 확인해 주세요.';
    case 'server_error':
      return '일시적인 오류가 발생했어요. 잠시 후 다시 시도해 주세요.';
    case 'validation_error':
      return '입력값을 다시 확인해 주세요.';
    case 'unknown':
    default:
      return '알 수 없는 오류가 발생했어요. 잠시 후 다시 시도해 주세요.';
  }
}
