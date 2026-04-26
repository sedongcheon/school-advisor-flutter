import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/core/db/app_database.dart';
import 'package:school_advisor/features/notifications/data/inbox_repository.dart';
import 'package:school_advisor/features/report/data/reports_repository.dart';

void main() {
  late AppDatabase db;
  late ReportsRepository reports;
  late InboxRepository inbox;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    reports = ReportsRepository(db);
    inbox = InboxRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ReportsRepository (drift in-memory)', () {
    test('create 시 receiptNo 가 R-yyyy-mmdd-NNNN 형식으로 발급된다', () async {
      final row = await reports.create(
        role: '피해 학생 본인',
        gradeBand: '중',
        types: {'사이버폭력'},
        whenLabel: '오늘',
        whereLabel: '온라인',
        body: 'test body',
        anonymous: true,
      );
      expect(row.receiptNo, matches(RegExp(r'^R-\d{4}-\d{4}-\d{4}$')));
      expect(row.role, '피해 학생 본인');
      expect(row.statusCode, 'received');
    });

    test('findByReceiptNo 로 동일 행을 가져올 수 있다', () async {
      final created = await reports.create(
        role: '목격자',
        gradeBand: '고',
        types: {'언어폭력', '따돌림'},
        whenLabel: '이번 주',
        whereLabel: '교실',
        body: '',
        anonymous: false,
      );
      final found = await reports.findByReceiptNo(created.receiptNo);
      expect(found, isNotNull);
      expect(found!.id, created.id);
      expect(
        ReportsRepository.decodeTypes(found.typesJson),
        containsAll(['언어폭력', '따돌림']),
      );
      expect(found.anonymous, isFalse);
    });

    test(
      'advanceStatus 가 received → investigating → review → concluded',
      () async {
        final r = await reports.create(
          role: '피해 학생 본인',
          gradeBand: '중',
          types: {'사이버폭력'},
          whenLabel: '오늘',
          whereLabel: '온라인',
          body: '',
          anonymous: true,
        );

        var result = await reports.advanceStatus(r.receiptNo);
        expect(result, ('received', 'investigating'));
        expect(
          (await reports.findByReceiptNo(r.receiptNo))!.statusCode,
          'investigating',
        );

        result = await reports.advanceStatus(r.receiptNo);
        expect(result, ('investigating', 'review'));

        result = await reports.advanceStatus(r.receiptNo);
        expect(result, ('review', 'concluded'));

        result = await reports.advanceStatus(r.receiptNo);
        expect(result, isNull);
        expect(
          (await reports.findByReceiptNo(r.receiptNo))!.statusCode,
          'concluded',
        );
      },
    );

    test('deleteByReceiptNo 가 행을 제거한다', () async {
      final r = await reports.create(
        role: '교사',
        gradeBand: '초',
        types: {'신체폭력'},
        whenLabel: '어제',
        whereLabel: '복도',
        body: '',
        anonymous: true,
      );
      final removed = await reports.deleteByReceiptNo(r.receiptNo);
      expect(removed, isTrue);
      expect(await reports.findByReceiptNo(r.receiptNo), isNull);
      expect(await reports.deleteByReceiptNo('R-9999-9999-0000'), isFalse);
    });
  });

  group('InboxRepository (drift in-memory)', () {
    test('create 후 watchAll 이 최신순 반환', () async {
      await inbox.create(kind: 'milestone', title: 'first');
      await inbox.create(kind: 'event', title: 'second', detail: 'detail');
      final list = await inbox.watchAll().first;
      expect(list.length, 2);
      expect(list.first.title, 'second');
      expect(list[1].title, 'first');
    });

    test('markAllRead 호출 시 모든 isRead = true', () async {
      await inbox.create(kind: 'milestone', title: 'a');
      await inbox.create(kind: 'guide', title: 'b');
      await inbox.markAllRead();
      final list = await inbox.watchAll().first;
      expect(list.every((it) => it.isRead), isTrue);
    });

    test('markRead 는 단일 항목만', () async {
      final id1 = await inbox.create(kind: 'milestone', title: 'a');
      await inbox.create(kind: 'milestone', title: 'b');
      await inbox.markRead(id1);
      final list = await inbox.watchAll().first;
      final aRow = list.firstWhere((it) => it.id == id1);
      final bRow = list.firstWhere((it) => it.id != id1);
      expect(aRow.isRead, isTrue);
      expect(bRow.isRead, isFalse);
    });

    test('delete 후 watchAll 에서 사라짐', () async {
      final id = await inbox.create(kind: 'event', title: 'x');
      await inbox.delete(id);
      final list = await inbox.watchAll().first;
      expect(list.where((it) => it.id == id), isEmpty);
    });
  });
}
