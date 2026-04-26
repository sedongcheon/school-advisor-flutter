import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/features/report/data/reports_repository.dart';

void main() {
  group('ReportsRepository.nextStatus', () {
    test('received → investigating', () {
      expect(ReportsRepository.nextStatus('received'), 'investigating');
    });
    test('investigating → review', () {
      expect(ReportsRepository.nextStatus('investigating'), 'review');
    });
    test('review → concluded', () {
      expect(ReportsRepository.nextStatus('review'), 'concluded');
    });
    test('concluded → null (마지막 단계)', () {
      expect(ReportsRepository.nextStatus('concluded'), isNull);
    });
    test('알 수 없는 코드 → null', () {
      expect(ReportsRepository.nextStatus('unknown'), isNull);
      expect(ReportsRepository.nextStatus(''), isNull);
    });
  });

  group('ReportsRepository.stageIndex', () {
    test('각 코드별 정확한 인덱스', () {
      expect(ReportsRepository.stageIndex('received'), 0);
      expect(ReportsRepository.stageIndex('investigating'), 1);
      expect(ReportsRepository.stageIndex('review'), 2);
      expect(ReportsRepository.stageIndex('concluded'), 3);
    });
    test('알 수 없는 코드는 0 (안전)', () {
      expect(ReportsRepository.stageIndex('unknown'), 0);
    });
  });

  group('ReportsRepository.statusLabel', () {
    test('각 코드를 한국어로 매핑', () {
      expect(ReportsRepository.statusLabel('received'), '접수 완료');
      expect(ReportsRepository.statusLabel('investigating'), '사안 조사 중');
      expect(ReportsRepository.statusLabel('review'), '심의 진행');
      expect(ReportsRepository.statusLabel('concluded'), '조치 완료');
    });
    test('알 수 없는 코드는 진행 중 라벨', () {
      expect(ReportsRepository.statusLabel('unknown'), '진행 중');
    });
  });

  group('ReportsRepository.milestoneTitle', () {
    test('각 단계 전환별 milestone 제목', () {
      expect(
        ReportsRepository.milestoneTitle('received', 'investigating'),
        contains('조사'),
      );
      expect(
        ReportsRepository.milestoneTitle('investigating', 'review'),
        contains('심의'),
      );
      expect(
        ReportsRepository.milestoneTitle('review', 'concluded'),
        contains('조치'),
      );
    });
  });

  group('ReportsRepository.decodeTypes', () {
    test('정상 JSON 배열 디코드', () {
      final json = jsonEncode(['사이버폭력', '언어폭력']);
      expect(ReportsRepository.decodeTypes(json), ['사이버폭력', '언어폭력']);
    });
    test('빈 배열', () {
      expect(ReportsRepository.decodeTypes('[]'), isEmpty);
    });
    test('배열이 아니면 빈 리스트', () {
      expect(ReportsRepository.decodeTypes('{}'), isEmpty);
    });
    test('비-string 항목은 무시', () {
      final json = jsonEncode(['사이버폭력', 123, null, '언어폭력']);
      expect(ReportsRepository.decodeTypes(json), ['사이버폭력', '언어폭력']);
    });
  });
}
