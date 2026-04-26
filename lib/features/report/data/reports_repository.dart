import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';

/// 신고서 데이터 레이어 (로컬 SQLite mock).
class ReportsRepository {
  ReportsRepository(this._db);

  final AppDatabase _db;
  static final _rng = Random.secure();

  Stream<List<ReportRow>> watchAll() {
    return (_db.select(
      _db.reports,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<ReportRow?> findByReceiptNo(String receiptNo) {
    return (_db.select(_db.reports)
          ..where((t) => t.receiptNo.equals(receiptNo))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<ReportRow> create({
    required String role,
    required String gradeBand,
    required Set<String> types,
    required String whenLabel,
    required String whereLabel,
    required String body,
    required bool anonymous,
  }) async {
    final receiptNo = _generateReceiptNo();
    final id = await _db
        .into(_db.reports)
        .insert(
          ReportsCompanion.insert(
            receiptNo: receiptNo,
            role: role,
            gradeBand: gradeBand,
            typesJson: Value(jsonEncode(types.toList())),
            whenLabel: whenLabel,
            whereLabel: whereLabel,
            body: Value(body),
            anonymous: Value(anonymous),
          ),
        );
    return (_db.select(_db.reports)..where((t) => t.id.equals(id))).getSingle();
  }

  /// `R-yyyy-mmdd-NNNN` 형식. NNNN 은 랜덤 4자리.
  static String _generateReceiptNo() {
    final now = DateTime.now();
    final yyyy = now.year.toString().padLeft(4, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final nnnn = (1000 + _rng.nextInt(9000)).toString();
    return 'R-$yyyy-$mm$dd-$nnnn';
  }

  static List<String> decodeTypes(String json) {
    final raw = jsonDecode(json);
    if (raw is! List) return const [];
    return [
      for (final s in raw)
        if (s is String) s,
    ];
  }

  /// `statusCode` → 4단계 진행 인덱스(0~3).
  static int stageIndex(String statusCode) => switch (statusCode) {
    'received' => 0,
    'investigating' => 1,
    'review' => 2,
    'concluded' => 3,
    _ => 0,
  };

  static String statusLabel(String code) => switch (code) {
    'received' => '접수 완료',
    'investigating' => '사안 조사 중',
    'review' => '심의 진행',
    'concluded' => '조치 완료',
    _ => '진행 중',
  };
}

/// 교사 홈 KPI 요약.
class ReportsKpi {
  const ReportsKpi({
    required this.inProgress,
    required this.reviewSoon,
    required this.total,
  });
  final int inProgress;
  final int reviewSoon;
  final int total;
}

/// reports 전체 watch.
final reportsAllProvider = StreamProvider<List<ReportRow>>((ref) {
  return ref.watch(reportsRepositoryProvider).watchAll();
});

/// 가장 최근 1건 (보호자 홈 자녀 카드용).
final latestReportProvider = Provider<ReportRow?>((ref) {
  final state = ref.watch(reportsAllProvider);
  return state.maybeWhen(
    data: (list) => list.isEmpty ? null : list.first,
    orElse: () => null,
  );
});

/// 교사 홈 KPI.
final reportsKpiProvider = Provider<ReportsKpi>((ref) {
  final state = ref.watch(reportsAllProvider);
  final list = state.value ?? const <ReportRow>[];
  final inProgress = list
      .where(
        (r) =>
            r.statusCode == 'received' ||
            r.statusCode == 'investigating' ||
            r.statusCode == 'review',
      )
      .length;
  final reviewSoon = list.where((r) => r.statusCode == 'review').length;
  return ReportsKpi(
    inProgress: inProgress,
    reviewSoon: reviewSoon,
    total: list.length,
  );
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.watch(appDatabaseProvider));
});
