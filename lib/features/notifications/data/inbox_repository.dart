import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';

/// 알림 인박스. FCM 수신·진행 변화 등이 누적된다.
class InboxRepository {
  InboxRepository(this._db);
  final AppDatabase _db;

  Stream<List<InboxRow>> watchAll() {
    return (_db.select(
      _db.inboxItems,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<int> create({
    required String kind,
    required String title,
    String detail = '',
    String? receiptNo,
  }) {
    return _db
        .into(_db.inboxItems)
        .insert(
          InboxItemsCompanion.insert(
            kind: kind,
            title: title,
            detail: Value(detail),
            receiptNo: Value(receiptNo),
          ),
        );
  }

  Future<void> markAllRead() async {
    await _db
        .update(_db.inboxItems)
        .write(const InboxItemsCompanion(isRead: Value(true)));
  }

  Future<void> markRead(int id) async {
    await (_db.update(_db.inboxItems)..where((t) => t.id.equals(id))).write(
      const InboxItemsCompanion(isRead: Value(true)),
    );
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.inboxItems)..where((t) => t.id.equals(id))).go();
  }
}

final inboxRepositoryProvider = Provider<InboxRepository>((ref) {
  return InboxRepository(ref.watch(appDatabaseProvider));
});
