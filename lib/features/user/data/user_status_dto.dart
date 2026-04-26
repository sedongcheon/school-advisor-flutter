import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_status_dto.freezed.dart';
part 'user_status_dto.g.dart';

@freezed
abstract class UserStatus with _$UserStatus {
  const factory UserStatus({
    @JsonKey(name: 'device_id') required String deviceId,
    required String plan,
    @JsonKey(name: 'questions_used') required int questionsUsed,
    @JsonKey(name: 'questions_limit') required int questionsLimit,
    @JsonKey(name: 'expires_at') String? expiresAt,
    @JsonKey(name: 'last_reset_date') required String lastResetDate,
  }) = _UserStatus;

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);
}

extension UserStatusX on UserStatus {
  int get questionsRemaining =>
      (questionsLimit - questionsUsed).clamp(0, 1 << 31);
  bool get isExhausted => questionsRemaining == 0;
  bool get isNearLimit => questionsRemaining <= 1 && !isExhausted;
}
