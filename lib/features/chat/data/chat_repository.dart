import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/dio_provider.dart';
import '../../../core/sse/sse_client.dart';
import '../../../core/sse/sse_event.dart';
import 'chat_dto.dart';

/// 채팅 데이터 레이어. SSE 호출 책임만 진다.
abstract interface class ChatRepository {
  Stream<SseEvent> streamChat(ChatRequest request, {CancelToken? cancelToken});
}

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(Dio dio) : _client = SseClient(dio);

  final SseClient _client;

  @override
  Stream<SseEvent> streamChat(ChatRequest request, {CancelToken? cancelToken}) {
    return _client.postStream(
      '/api/v1/chat',
      body: request.toJson(),
      cancelToken: cancelToken,
    );
  }
}

/// `dioProvider` 가 준비된 후 만들어진다.
final chatRepositoryProvider = FutureProvider<ChatRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return ChatRepositoryImpl(dio);
});
