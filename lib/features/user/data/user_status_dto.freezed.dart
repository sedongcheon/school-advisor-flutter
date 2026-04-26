// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_status_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStatus {

@JsonKey(name: 'device_id') String get deviceId; String get plan;@JsonKey(name: 'questions_used') int get questionsUsed;@JsonKey(name: 'questions_limit') int get questionsLimit;@JsonKey(name: 'expires_at') String? get expiresAt;@JsonKey(name: 'last_reset_date') String get lastResetDate;
/// Create a copy of UserStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatusCopyWith<UserStatus> get copyWith => _$UserStatusCopyWithImpl<UserStatus>(this as UserStatus, _$identity);

  /// Serializes this UserStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStatus&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.questionsUsed, questionsUsed) || other.questionsUsed == questionsUsed)&&(identical(other.questionsLimit, questionsLimit) || other.questionsLimit == questionsLimit)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.lastResetDate, lastResetDate) || other.lastResetDate == lastResetDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,plan,questionsUsed,questionsLimit,expiresAt,lastResetDate);

@override
String toString() {
  return 'UserStatus(deviceId: $deviceId, plan: $plan, questionsUsed: $questionsUsed, questionsLimit: $questionsLimit, expiresAt: $expiresAt, lastResetDate: $lastResetDate)';
}


}

/// @nodoc
abstract mixin class $UserStatusCopyWith<$Res>  {
  factory $UserStatusCopyWith(UserStatus value, $Res Function(UserStatus) _then) = _$UserStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'device_id') String deviceId, String plan,@JsonKey(name: 'questions_used') int questionsUsed,@JsonKey(name: 'questions_limit') int questionsLimit,@JsonKey(name: 'expires_at') String? expiresAt,@JsonKey(name: 'last_reset_date') String lastResetDate
});




}
/// @nodoc
class _$UserStatusCopyWithImpl<$Res>
    implements $UserStatusCopyWith<$Res> {
  _$UserStatusCopyWithImpl(this._self, this._then);

  final UserStatus _self;
  final $Res Function(UserStatus) _then;

/// Create a copy of UserStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? plan = null,Object? questionsUsed = null,Object? questionsLimit = null,Object? expiresAt = freezed,Object? lastResetDate = null,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String,questionsUsed: null == questionsUsed ? _self.questionsUsed : questionsUsed // ignore: cast_nullable_to_non_nullable
as int,questionsLimit: null == questionsLimit ? _self.questionsLimit : questionsLimit // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,lastResetDate: null == lastResetDate ? _self.lastResetDate : lastResetDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStatus].
extension UserStatusPatterns on UserStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStatus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStatus value)  $default,){
final _that = this;
switch (_that) {
case _UserStatus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStatus value)?  $default,){
final _that = this;
switch (_that) {
case _UserStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'device_id')  String deviceId,  String plan, @JsonKey(name: 'questions_used')  int questionsUsed, @JsonKey(name: 'questions_limit')  int questionsLimit, @JsonKey(name: 'expires_at')  String? expiresAt, @JsonKey(name: 'last_reset_date')  String lastResetDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStatus() when $default != null:
return $default(_that.deviceId,_that.plan,_that.questionsUsed,_that.questionsLimit,_that.expiresAt,_that.lastResetDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'device_id')  String deviceId,  String plan, @JsonKey(name: 'questions_used')  int questionsUsed, @JsonKey(name: 'questions_limit')  int questionsLimit, @JsonKey(name: 'expires_at')  String? expiresAt, @JsonKey(name: 'last_reset_date')  String lastResetDate)  $default,) {final _that = this;
switch (_that) {
case _UserStatus():
return $default(_that.deviceId,_that.plan,_that.questionsUsed,_that.questionsLimit,_that.expiresAt,_that.lastResetDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'device_id')  String deviceId,  String plan, @JsonKey(name: 'questions_used')  int questionsUsed, @JsonKey(name: 'questions_limit')  int questionsLimit, @JsonKey(name: 'expires_at')  String? expiresAt, @JsonKey(name: 'last_reset_date')  String lastResetDate)?  $default,) {final _that = this;
switch (_that) {
case _UserStatus() when $default != null:
return $default(_that.deviceId,_that.plan,_that.questionsUsed,_that.questionsLimit,_that.expiresAt,_that.lastResetDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStatus implements UserStatus {
  const _UserStatus({@JsonKey(name: 'device_id') required this.deviceId, required this.plan, @JsonKey(name: 'questions_used') required this.questionsUsed, @JsonKey(name: 'questions_limit') required this.questionsLimit, @JsonKey(name: 'expires_at') this.expiresAt, @JsonKey(name: 'last_reset_date') required this.lastResetDate});
  factory _UserStatus.fromJson(Map<String, dynamic> json) => _$UserStatusFromJson(json);

@override@JsonKey(name: 'device_id') final  String deviceId;
@override final  String plan;
@override@JsonKey(name: 'questions_used') final  int questionsUsed;
@override@JsonKey(name: 'questions_limit') final  int questionsLimit;
@override@JsonKey(name: 'expires_at') final  String? expiresAt;
@override@JsonKey(name: 'last_reset_date') final  String lastResetDate;

/// Create a copy of UserStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatusCopyWith<_UserStatus> get copyWith => __$UserStatusCopyWithImpl<_UserStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStatus&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.questionsUsed, questionsUsed) || other.questionsUsed == questionsUsed)&&(identical(other.questionsLimit, questionsLimit) || other.questionsLimit == questionsLimit)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.lastResetDate, lastResetDate) || other.lastResetDate == lastResetDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,plan,questionsUsed,questionsLimit,expiresAt,lastResetDate);

@override
String toString() {
  return 'UserStatus(deviceId: $deviceId, plan: $plan, questionsUsed: $questionsUsed, questionsLimit: $questionsLimit, expiresAt: $expiresAt, lastResetDate: $lastResetDate)';
}


}

/// @nodoc
abstract mixin class _$UserStatusCopyWith<$Res> implements $UserStatusCopyWith<$Res> {
  factory _$UserStatusCopyWith(_UserStatus value, $Res Function(_UserStatus) _then) = __$UserStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'device_id') String deviceId, String plan,@JsonKey(name: 'questions_used') int questionsUsed,@JsonKey(name: 'questions_limit') int questionsLimit,@JsonKey(name: 'expires_at') String? expiresAt,@JsonKey(name: 'last_reset_date') String lastResetDate
});




}
/// @nodoc
class __$UserStatusCopyWithImpl<$Res>
    implements _$UserStatusCopyWith<$Res> {
  __$UserStatusCopyWithImpl(this._self, this._then);

  final _UserStatus _self;
  final $Res Function(_UserStatus) _then;

/// Create a copy of UserStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? plan = null,Object? questionsUsed = null,Object? questionsLimit = null,Object? expiresAt = freezed,Object? lastResetDate = null,}) {
  return _then(_UserStatus(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String,questionsUsed: null == questionsUsed ? _self.questionsUsed : questionsUsed // ignore: cast_nullable_to_non_nullable
as int,questionsLimit: null == questionsLimit ? _self.questionsLimit : questionsLimit // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,lastResetDate: null == lastResetDate ? _self.lastResetDate : lastResetDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
