// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LastSessionMeta _$LastSessionMetaFromJson(Map<String, dynamic> json) =>
    _LastSessionMeta(
      sessionId: json['session_id'] as String,
      lastMessageAt: json['last_message_at'] as String,
      lastUserQuery: json['last_user_query'] as String,
      daysAgo: (json['days_ago'] as num).toInt(),
    );

Map<String, dynamic> _$LastSessionMetaToJson(_LastSessionMeta instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'last_message_at': instance.lastMessageAt,
      'last_user_query': instance.lastUserQuery,
      'days_ago': instance.daysAgo,
    };
