import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/core/error/app_exception.dart';
import 'package:school_advisor/core/error/error_mapper.dart';

void main() {
  group('mapErrorToMessage', () {
    test('AppException 의 code 별로 한국어 문구를 돌려준다', () {
      expect(mapErrorToMessage(const NetworkException()), contains('네트워크'));
      expect(mapErrorToMessage(const TimeoutException()), contains('오래'));
      expect(mapErrorToMessage(const RateLimitException()), contains('천천히'));
      expect(mapErrorToMessage(const QuotaExceededException()), contains('한도'));
      expect(mapErrorToMessage(const ServerException()), contains('일시적인'));
      expect(mapErrorToMessage(const ValidationException()), contains('입력값'));
    });

    test('알 수 없는 Object 는 unknown 메시지로 매핑된다', () {
      expect(mapErrorToMessage(Exception('foo')), contains('알 수 없는'));
    });
  });
}
