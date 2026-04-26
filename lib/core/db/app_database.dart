import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Conversations, Messages, Reports, InboxItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'school_advisor'));

  /// 인메모리 테스트용 — `NativeDatabase.memory()` 등 임의 executor 주입.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(reports);
        await m.createTable(inboxItems);
      }
    },
  );
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
