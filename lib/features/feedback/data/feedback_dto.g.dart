// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedbackRequestDto _$FeedbackRequestDtoFromJson(Map<String, dynamic> json) =>
    _FeedbackRequestDto(
      conversationId: json['conversation_id'] as String,
      rating: (json['rating'] as num).toInt(),
      issueType: json['issue_type'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$FeedbackRequestDtoToJson(_FeedbackRequestDto instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'rating': instance.rating,
      'issue_type': instance.issueType,
      'comment': instance.comment,
    };
