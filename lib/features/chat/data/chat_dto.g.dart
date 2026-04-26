// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => _ChatRequest(
  query: json['query'] as String,
  sessionId: json['session_id'] as String,
  deviceId: json['device_id'] as String?,
);

Map<String, dynamic> _$ChatRequestToJson(_ChatRequest instance) =>
    <String, dynamic>{
      'query': instance.query,
      'session_id': instance.sessionId,
      'device_id': instance.deviceId,
    };
