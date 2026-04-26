import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/dio_provider.dart';
import '../../../core/sse/sse_client.dart';
import '../../../core/sse/sse_event.dart';
import 'chat_dto.dart';
import 'last_session_dto.dart';

/// 채팅 데이터 레이어. SSE 호출 책임만 진다.
abstract interface class ChatRepository {
  Stream<SseEvent> streamChat(ChatRequest request, {CancelToken? cancelToken});

  /// 마지막 사용자 메시지 메타. 이력이 없으면 `null` 반환.
  Future<LastSessionMeta?> fetchLastSession({CancelToken? cancelToken});
}

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(Dio dio) : _client = SseClient(dio), _dio = dio;

  final SseClient _client;
  final Dio _dio;

  @override
  Stream<SseEvent> streamChat(ChatRequest request, {CancelToken? cancelToken}) {
    return _client.postStream(
      '/api/v1/chat',
      body: request.toJson(),
      cancelToken: cancelToken,
    );
  }

  @override
  Future<LastSessionMeta?> fetchLastSession({CancelToken? cancelToken}) async {
    final res = await _dio.get<dynamic>(
      '/api/v1/chat/last_session',
      cancelToken: cancelToken,
    );
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return LastSessionMeta.fromJson(data);
    }
    return null;
  }
}

/// `dioProvider` 가 준비된 후 만들어진다.
final chatRepositoryProvider = FutureProvider<ChatRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return ChatRepositoryImpl(dio);
});
