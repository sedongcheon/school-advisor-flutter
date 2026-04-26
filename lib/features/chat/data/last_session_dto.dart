import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_session_dto.freezed.dart';
part 'last_session_dto.g.dart';

/// `GET /api/v1/chat/last_session` 응답.
///
/// 백엔드는 본문 없으면 `null` 을 응답한다 (HTTP 200 + `null` literal).
/// `last_user_query` 는 50자 미리보기.
@freezed
abstract class LastSessionMeta with _$LastSessionMeta {
  const factory LastSessionMeta({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'last_message_at') required String lastMessageAt,
    @JsonKey(name: 'last_user_query') required String lastUserQuery,
    @JsonKey(name: 'days_ago') required int daysAgo,
  }) = _LastSessionMeta;

  factory LastSessionMeta.fromJson(Map<String, dynamic> json) =>
      _$LastSessionMetaFromJson(json);
}
