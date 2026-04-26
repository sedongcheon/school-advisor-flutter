import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/sse/sse_event.dart';

part 'chat_dto.freezed.dart';
part 'chat_dto.g.dart';

/// `POST /api/v1/chat` 요청 바디.
@freezed
abstract class ChatRequest with _$ChatRequest {
  const factory ChatRequest({
    required String query,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'device_id') String? deviceId,
  }) = _ChatRequest;

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);
}

enum ChatRole { user, assistant }

/// 화면에 표시되는 메시지 단위.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required ChatRole role,
    required String content,

    /// 로컬 DB(`messages`) 의 PK. 영속화된 후에 채워진다.
    int? dbId,

    /// 답변에 사용된 인용 청크. user 메시지는 비어 있음.
    @Default(<CitationChunk>[]) List<CitationChunk> citations,

    /// 백엔드가 done 이벤트로 내려주는 conversation_id.
    /// 신고/피드백 전송 시 키로 사용.
    String? conversationId,

    /// 어시스턴트 답변이 스트리밍 중인지.
    @Default(false) bool isStreaming,

    /// 스트림 내 `event: error` 로 종료된 메시지의 사용자 노출 문구.
    String? errorMessage,
  }) = _ChatMessage;
}
