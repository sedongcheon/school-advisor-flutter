import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Conversations, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'school_advisor'));

  @override
  int get schemaVersion => 1;
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
