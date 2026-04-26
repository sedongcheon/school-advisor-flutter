import 'package:freezed_annotation/freezed_annotation.dart';

part 'sse_event.freezed.dart';

/// 백엔드 `/api/v1/chat` 의 SSE 프레임에 대응하는 도메인 이벤트.
///
/// 백엔드 스키마(`app/schemas/chat.py`) 기준:
/// - `text`     → `{ "content": str }`
/// - `citation` → `{ "chunks": [{id, law, url}] }` (스트림 끝 직전 1회)
/// - `done`     → `{ "conversation_id": uuid, "model": str, "tokens": {...} }`
/// - `error`    → `{ "code": str, "message": str }`
///
/// `event:` 헤더로 분기되므로 freezed 의 자동 JSON discriminator 는 사용하지 않는다.
@freezed
sealed class SseEvent with _$SseEvent {
  const factory SseEvent.text({required String content}) = SseText;

  const factory SseEvent.citations({required List<CitationChunk> chunks}) =
      SseCitations;

  const factory SseEvent.done({
    required String conversationId,
    String? model,
    int? inputTokens,
    int? outputTokens,
  }) = SseDone;

  const factory SseEvent.error({required String code, String? message}) =
      SseError;
}

/// 답변에 사용된 청크 1개 (백엔드 `CitationChunk` 그대로).
@freezed
abstract class CitationChunk with _$CitationChunk {
  const factory CitationChunk({
    required int id,

    /// 사람 읽기용 라벨. 예: "학폭예방법 제17조 제1항".
    required String law,
    String? url,
  }) = _CitationChunk;
}
