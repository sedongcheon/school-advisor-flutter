import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/shared/utils/pii_detector.dart';

void main() {
  group('PiiDetector.scan', () {
    test('주민등록번호를 감지한다 (대시 / 공백 / 없음)', () {
      expect(PiiDetector.scan('내 번호 901231-1234567 임').ssns, isNotEmpty);
      expect(PiiDetector.scan('901231 1234567').ssns, isNotEmpty);
      expect(PiiDetector.scan('9012311234567').ssns, isNotEmpty);
    });

    test('주민번호 7번째가 1~4 가 아니면 감지하지 않는다', () {
      expect(PiiDetector.scan('901231-9234567').ssns, isEmpty);
    });

    test('휴대폰 번호를 감지한다', () {
      expect(PiiDetector.scan('010-1234-5678 로 연락주세요').phones, isNotEmpty);
      expect(PiiDetector.scan('011 123 4567').phones, isNotEmpty);
      expect(PiiDetector.scan('01012345678').phones, isNotEmpty);
    });

    test('학교명(초/중/고)을 감지한다', () {
      expect(PiiDetector.scan('서울중앙초등학교 다님').schools, ['서울중앙초등학교']);
      expect(PiiDetector.scan('한국고등학교').schools, ['한국고등학교']);
      expect(PiiDetector.scan('대학교 입학').schools, isEmpty);
    });

    test('아무것도 없으면 hasAny 가 false', () {
      expect(PiiDetector.scan('일반 질문입니다').hasAny, isFalse);
    });

    test('mask 는 검출된 패턴을 라벨로 치환한다', () {
      final masked = PiiDetector.mask('홍길동 010-1234-5678 서울중앙고등학교');
      expect(masked.contains('010'), isFalse);
      expect(masked.contains('서울중앙'), isFalse);
      expect(masked.contains('[전화번호]'), isTrue);
      expect(masked.contains('[학교명고등학교]'), isTrue);
    });

    test('labels 는 감지된 종류만 한국어로 반환', () {
      final r = PiiDetector.scan('010-1234-5678');
      expect(r.labels, ['휴대폰 번호']);
    });
  });
}
