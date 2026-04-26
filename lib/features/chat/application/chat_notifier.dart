import 'dart:async';
import 'dart:io' show SocketException;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/error/error_mapper.dart';
import '../../../core/sse/sse_event.dart';
import '../../feedback/data/feedback_dto.dart';
import '../../feedback/data/feedback_repository.dart';
import '../../user/data/user_repository.dart';
import '../data/chat_dto.dart';
import '../data/chat_repository.dart';
import '../data/conversation_repository.dart';

/// 채팅 화면 상태.
class ChatState {
  const ChatState({
    this.messages = const [],
    this.isComposing = false,
    this.sessionId,
    this.conversationLocalId,
  });

  final List<ChatMessage> messages;
  final bool isComposing;

  /// 동일 세션을 묶는 UUID. 첫 송신 직전에 생성된다.
  final String? sessionId;

  /// 로컬 DB conversations.id. 첫 송신 시점에 생성된다.
  final int? conversationLocalId;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isComposing,
    String? sessionId,
    int? conversationLocalId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isComposing: isComposing ?? this.isComposing,
      sessionId: sessionId ?? this.sessionId,
      conversationLocalId: conversationLocalId ?? this.conversationLocalId,
    );
  }
}

final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);

class ChatNotifier extends Notifier<ChatState> {
  static const _uuid = Uuid();

  CancelToken? _activeCancel;
  StreamSubscription<SseEvent>? _activeSub;

  @override
  ChatState build() {
    ref.onDispose(() {
      _activeCancel?.cancel();
      _activeSub?.cancel();
    });
    return const ChatState();
  }

  /// 새 대화 시작. in-memory 만 리셋. DB 행은 첫 send 시점에 생성된다.
  void startNewConversation() {
    _activeCancel?.cancel();
    _activeSub?.cancel();
    state = const ChatState();
  }

  /// 이력 화면에서 대화를 선택했을 때 호출.
  Future<void> loadConversation(int localId) async {
    final repo = ref.read(conversationRepositoryProvider);
    final conv = await repo.findById(localId);
    if (conv == null) return;
    final rows = await repo.getMessages(localId);
    final loaded = [
      for (final r in rows)
        ChatMessage(
          id: _uuid.v4(),
          dbId: r.id,
          role: r.role == 'user' ? ChatRole.user : ChatRole.assistant,
          content: r.content,
          citations: ConversationRepository.decodeCitations(r.citationsJson),
          errorMessage: r.errorMessage,
          conversationId: conv.conversationId,
        ),
    ];
    state = ChatState(
      messages: loaded,
      sessionId: conv.sessionId,
      conversationLocalId: localId,
    );
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isComposing) return;

    final repo = ref.read(conversationRepositoryProvider);
    final sessionId = state.sessionId ?? _uuid.v4();
    var conversationLocalId = state.conversationLocalId;

    // 첫 송신: conversation row 생성
    if (conversationLocalId == null) {
      conversationLocalId = await repo.create(sessionId: sessionId);
      await repo.updateMeta(
        localId: conversationLocalId,
        title: _truncate(trimmed, 30),
        lastPreview: _truncate(trimmed, 80),
      );
    } else {
      await repo.updateMeta(
        localId: conversationLocalId,
        lastPreview: _truncate(trimmed, 80),
      );
    }

    // user / assistant DB row + in-memory 메시지
    final userDbId = await repo.addMessage(
      conversationLocalId: conversationLocalId,
      role: 'user',
      content: trimmed,
    );
    final assistantDbId = await repo.addMessage(
      conversationLocalId: conversationLocalId,
      role: 'assistant',
    );

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      dbId: userDbId,
      role: ChatRole.user,
      content: trimmed,
    );
    final assistantInMemoryId = _uuid.v4();
    final assistantMsg = ChatMessage(
      id: assistantInMemoryId,
      dbId: assistantDbId,
      role: ChatRole.assistant,
      content: '',
      isStreaming: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg, assistantMsg],
      isComposing: true,
      sessionId: sessionId,
      conversationLocalId: conversationLocalId,
    );

    final cancel = CancelToken();
    _activeCancel = cancel;
    final completer = Completer<void>();

    try {
      final chatRepo = await ref.read(chatRepositoryProvider.future);
      final Stream<SseEvent> stream;
      try {
        stream = chatRepo.streamChat(
          ChatRequest(query: trimmed, sessionId: sessionId),
          cancelToken: cancel,
        );
      } on Object catch (e) {
        _onStreamError(assistantInMemoryId, e);
        await _persistAssistant(assistantInMemoryId);
        _finalize(assistantInMemoryId);
        return;
      }

      _activeSub = stream.listen(
        (event) => _onEvent(assistantInMemoryId, event),
        onDone: () async {
          await _persistAssistant(assistantInMemoryId);
          _finalize(assistantInMemoryId);
          completer.complete();
        },
        onError: (Object e, StackTrace _) async {
          _onStreamError(assistantInMemoryId, e);
          await _persistAssistant(assistantInMemoryId);
          _finalize(assistantInMemoryId);
          completer.complete();
        },
        cancelOnError: true,
      );
      await completer.future;
    } on SocketException catch (e) {
      _onStreamError(assistantInMemoryId, e);
      await _persistAssistant(assistantInMemoryId);
      _finalize(assistantInMemoryId);
    } on DioException catch (e) {
      _onStreamError(assistantInMemoryId, e);
      await _persistAssistant(assistantInMemoryId);
      _finalize(assistantInMemoryId);
    } on Object catch (e) {
      _onStreamError(assistantInMemoryId, e);
      await _persistAssistant(assistantInMemoryId);
      _finalize(assistantInMemoryId);
    } finally {
      _activeSub = null;
      _activeCancel = null;
      unawaited(_refreshUsageQuietly());
    }
  }

  void _onEvent(String assistantInMemoryId, SseEvent event) {
    switch (event) {
      case SseText(:final content):
        _appendToAssistant(assistantInMemoryId, content);
      case SseCitations(:final chunks):
        _setCitations(assistantInMemoryId, chunks);
      case SseDone(:final conversationId):
        _setConversationId(assistantInMemoryId, conversationId);
      case SseError(:final code, :final message):
        debugPrint('[chat] SSE error: code=$code, message=$message');
        final mapped = mapErrorToMessage(_appExceptionForCode(code));
        _setError(assistantInMemoryId, mapped);
    }
  }

  void _onStreamError(String assistantInMemoryId, Object error) {
    debugPrint(
      '[chat] stream transport error: type=${error.runtimeType} value=$error',
    );
    if (error is DioException) {
      debugPrint(
        '[chat]   dio.type=${error.type} status=${error.response?.statusCode} '
        'inner=${error.error?.runtimeType}',
      );
    }
    _setError(assistantInMemoryId, mapErrorToMessage(error));
  }

  AppException _appExceptionForCode(String code) {
    return switch (code) {
      'quota_exceeded' => const QuotaExceededException(),
      'rate_limited' => const RateLimitException(),
      'device_id_required' => const UnauthorizedException(),
      'internal_error' => const ServerException(),
      _ => const UnknownException(),
    };
  }

  void _appendToAssistant(String inMemoryId, String chunk) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == inMemoryId) m.copyWith(content: m.content + chunk) else m,
      ],
    );
  }

  void _setCitations(String inMemoryId, List<CitationChunk> chunks) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == inMemoryId) m.copyWith(citations: chunks) else m,
      ],
    );
  }

  void _setConversationId(String inMemoryId, String conversationId) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == inMemoryId)
            m.copyWith(conversationId: conversationId)
          else
            m,
      ],
    );
  }

  void _setError(String inMemoryId, String message) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == inMemoryId) m.copyWith(errorMessage: message) else m,
      ],
    );
  }

  void _finalize(String inMemoryId) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == inMemoryId) m.copyWith(isStreaming: false) else m,
      ],
      isComposing: false,
    );
  }

  /// 어시스턴트 메시지를 DB 에 한 번에 영속화 (SSE 종료 시점).
  Future<void> _persistAssistant(String inMemoryId) async {
    final msg = state.messages.where((m) => m.id == inMemoryId).firstOrNull;
    final convId = state.conversationLocalId;
    if (msg == null || msg.dbId == null || convId == null) return;
    final repo = ref.read(conversationRepositoryProvider);
    await repo.updateMessage(
      localId: msg.dbId!,
      content: msg.content,
      citations: msg.citations,
      errorMessage: msg.errorMessage,
    );
    await repo.updateMeta(
      localId: convId,
      conversationId: msg.conversationId,
      lastPreview: _truncate(msg.errorMessage ?? msg.content, 80),
    );
  }

  Future<void> _refreshUsageQuietly() async {
    try {
      await ref.read(userStatusProvider.notifier).refresh();
    } on Object catch (e) {
      debugPrint('[chat] usage refresh failed: $e');
    }
  }

  Future<bool> report({
    required String messageId,
    required ReportReason reason,
    String? comment,
  }) async {
    final msg = state.messages.where((m) => m.id == messageId).firstOrNull;
    if (msg == null || msg.conversationId == null) return false;
    final repo = await ref.read(feedbackRepositoryProvider.future);
    await repo.report(
      conversationId: msg.conversationId!,
      reason: reason,
      comment: comment,
    );
    return true;
  }

  Future<bool> sendRating({
    required String messageId,
    required int rating,
    String? comment,
  }) async {
    final msg = state.messages.where((m) => m.id == messageId).firstOrNull;
    if (msg == null || msg.conversationId == null) return false;
    final repo = await ref.read(feedbackRepositoryProvider.future);
    await repo.sendRating(
      conversationId: msg.conversationId!,
      rating: rating,
      comment: comment,
    );
    return true;
  }
}

String _truncate(String s, int max) {
  final t = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (t.length <= max) return t;
  return '${t.substring(0, max)}…';
}

extension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
