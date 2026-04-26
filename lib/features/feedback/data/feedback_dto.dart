import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_dto.freezed.dart';
part 'feedback_dto.g.dart';

/// `POST /api/v1/feedback` 요청 바디.
///
/// 백엔드는 `rating` 1~5 를 필수로 요구한다. 신고만 보낼 때는
/// `rating: 1` + `issue_type` 를 함께 전송 (Sprint 4 에서 별점 UI 분리 예정).
@freezed
abstract class FeedbackRequestDto with _$FeedbackRequestDto {
  const factory FeedbackRequestDto({
    @JsonKey(name: 'conversation_id') required String conversationId,
    required int rating,
    @JsonKey(name: 'issue_type') String? issueType,
    String? comment,
  }) = _FeedbackRequestDto;

  factory FeedbackRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackRequestDtoFromJson(json);
}

/// 신고 사유. 백엔드는 자유 문자열을 받지만 클라이언트 카탈로그를 고정.
enum ReportReason {
  inaccurate('inaccurate', '사실과 다른 답변'),
  harmful('harmful', '유해하거나 부적절한 내용'),
  privacy('privacy', '개인정보 노출 우려'),
  etc('etc', '기타');

  const ReportReason(this.code, this.label);
  final String code;
  final String label;
}
