import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../env.dart';
import '../../features/notifications/data/inbox_repository.dart';
import '../../features/onboarding/application/disclaimer_notifier.dart'
    show sharedPreferencesProvider;
import '../../features/report/data/reports_repository.dart';

const _seededKey = 'demo_seed_v1';

/// `--dart-define=SEED_DEMO=true` 빌드에서만, 그리고 처음 1회만 mock 데이터를
/// reports/inbox 테이블에 적재한다. 운영 빌드는 항상 no-op.
class DemoSeeder {
  const DemoSeeder._();

  static Future<void> maybeSeed(WidgetRef ref) async {
    if (!Env.seedDemo) return;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (prefs.getBool(_seededKey) ?? false) {
      debugPrint('[demo-seed] already seeded; skip');
      return;
    }

    final reports = ref.read(reportsRepositoryProvider);
    final inbox = ref.read(inboxRepositoryProvider);

    debugPrint('[demo-seed] seeding mock reports + inbox');

    final r1 = await reports.create(
      role: '피해 학생 본인',
      gradeBand: '중',
      types: {'사이버폭력', '언어폭력'},
      whenLabel: '이번 주',
      whereLabel: '온라인',
      body: '단톡방에서 반복적으로 비하 메시지를 받았어요.',
      anonymous: true,
    );
    await reports.advanceStatus(r1.receiptNo); // received → investigating

    final r2 = await reports.create(
      role: '목격자',
      gradeBand: '고',
      types: {'따돌림'},
      whenLabel: '지난 주',
      whereLabel: '교실',
      body: '같은 반 친구가 점심시간마다 혼자 앉아 있었어요.',
      anonymous: false,
    );
    // r2 는 received 단계 그대로

    await reports.create(
      role: '보호자',
      gradeBand: '초',
      types: {'신체폭력'},
      whenLabel: '오늘',
      whereLabel: '학교 밖',
      body: '하굣길에서 다른 학생에게 떠밀렸다고 합니다.',
      anonymous: false,
    );

    await inbox.create(
      kind: 'milestone',
      title: '신고가 접수되었어요',
      detail: '${r1.receiptNo} · 곧 사안 조사가 시작돼요',
      receiptNo: r1.receiptNo,
    );
    await inbox.create(
      kind: 'event',
      title: '면담 일정이 안내되었어요',
      detail: '내일 14:00 · 학생부실',
      receiptNo: r2.receiptNo,
    );
    await inbox.create(
      kind: 'guide',
      title: '심의 전 준비할 것들',
      detail: '진술서·증거 정리 가이드를 확인해 보세요',
    );

    await prefs.setBool(_seededKey, true);
    debugPrint('[demo-seed] done');
  }
}
