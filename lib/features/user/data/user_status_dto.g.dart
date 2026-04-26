// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStatus _$UserStatusFromJson(Map<String, dynamic> json) => _UserStatus(
  deviceId: json['device_id'] as String,
  plan: json['plan'] as String,
  questionsUsed: (json['questions_used'] as num).toInt(),
  questionsLimit: (json['questions_limit'] as num).toInt(),
  expiresAt: json['expires_at'] as String?,
  lastResetDate: json['last_reset_date'] as String,
);

Map<String, dynamic> _$UserStatusToJson(_UserStatus instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'plan': instance.plan,
      'questions_used': instance.questionsUsed,
      'questions_limit': instance.questionsLimit,
      'expires_at': instance.expiresAt,
      'last_reset_date': instance.lastResetDate,
    };
