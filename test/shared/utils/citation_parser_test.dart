import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/shared/utils/citation_parser.dart';

void main() {
  group('CitationParser.parse', () {
    test('법률명 + 조 + 항 형태를 분해한다', () {
      final r = CitationParser.parse('학폭예방법 제17조 제1항');
      expect(r, isNotNull);
      expect(r!.lawName, '학폭예방법');
      expect(r.articleNo, '제17조');
      expect(r.paragraph, '제1항');
    });

    test('항이 없는 형태도 분해한다', () {
      final r = CitationParser.parse('학폭예방법 시행령 제22조');
      expect(r!.lawName, '학폭예방법 시행령');
      expect(r.articleNo, '제22조');
      expect(r.paragraph, isNull);
    });

    test('조의N 패턴도 인식한다', () {
      final r = CitationParser.parse('학교폭력예방 및 대책에 관한 법률 제17조의2');
      expect(r!.articleNo, '제17조의2');
    });

    test('형식이 다른 문자열은 null', () {
      expect(CitationParser.parse('그냥 법령명'), isNull);
      expect(CitationParser.parse('17조 1항'), isNull);
    });
  });
}
