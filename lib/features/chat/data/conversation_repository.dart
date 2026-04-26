import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/sse/sse_event.dart';

/// 로컬 SQLite 대화 이력 리포지토리.
class ConversationRepository {
  ConversationRepository(this._db);
  final AppDatabase _db;

  Stream<List<ConversationRow>> watchAll() {
    return (_db.select(
      _db.conversations,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();
  }

  Future<int> create({required String sessionId}) async {
    return _db
        .into(_db.conversations)
        .insert(ConversationsCompanion.insert(sessionId: sessionId));
  }

  Future<ConversationRow?> findById(int localId) async {
    return (_db.select(
      _db.conversations,
    )..where((t) => t.id.equals(localId))).getSingleOrNull();
  }

  Future<void> updateMeta({
    required int localId,
    String? title,
    String? conversationId,
    String? lastPreview,
  }) async {
    await (_db.update(
      _db.conversations,
    )..where((t) => t.id.equals(localId))).write(
      ConversationsCompanion(
        title: title == null ? const Value.absent() : Value(title),
        conversationId: conversationId == null
            ? const Value.absent()
            : Value(conversationId),
        lastPreview: lastPreview == null
            ? const Value.absent()
            : Value(lastPreview),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> addMessage({
    required int conversationLocalId,
    required String role,
    String content = '',
    List<CitationChunk>? citations,
    String? errorMessage,
  }) async {
    return _db
        .into(_db.messages)
        .insert(
          MessagesCompanion.insert(
            conversationLocalId: conversationLocalId,
            role: role,
            content: Value(content),
            citationsJson: Value(_encodeCitations(citations ?? const [])),
            errorMessage: Value(errorMessage),
          ),
        );
  }

  Future<void> updateMessage({
    required int localId,
    String? content,
    List<CitationChunk>? citations,
    String? errorMessage,
  }) async {
    await (_db.update(_db.messages)..where((t) => t.id.equals(localId))).write(
      MessagesCompanion(
        content: content == null ? const Value.absent() : Value(content),
        citationsJson: citations == null
            ? const Value.absent()
            : Value(_encodeCitations(citations)),
        errorMessage: errorMessage == null
            ? const Value.absent()
            : Value(errorMessage),
      ),
    );
  }

  Future<List<MessageRow>> getMessages(int conversationLocalId) async {
    return (_db.select(_db.messages)
          ..where((t) => t.conversationLocalId.equals(conversationLocalId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> delete(int localId) async {
    await (_db.delete(
      _db.conversations,
    )..where((t) => t.id.equals(localId))).go();
  }

  Future<int> count() async {
    final query = _db.selectOnly(_db.conversations)
      ..addColumns([_db.conversations.id.count()]);
    final result = await query.getSingle();
    return result.read(_db.conversations.id.count()) ?? 0;
  }

  static String _encodeCitations(List<CitationChunk> citations) {
    return jsonEncode([
      for (final c in citations)
        {'id': c.id, 'law': c.law, if (c.url != null) 'url': c.url},
    ]);
  }

  static List<CitationChunk> decodeCitations(String json) {
    final raw = jsonDecode(json);
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic> &&
            item['id'] is int &&
            item['law'] is String)
          CitationChunk(
            id: item['id'] as int,
            law: item['law'] as String,
            url: item['url'] as String?,
          ),
    ];
  }
}

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepository(ref.watch(appDatabaseProvider));
});
