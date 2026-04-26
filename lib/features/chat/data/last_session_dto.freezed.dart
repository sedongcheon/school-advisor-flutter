// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'last_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LastSessionMeta {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'last_message_at') String get lastMessageAt;@JsonKey(name: 'last_user_query') String get lastUserQuery;@JsonKey(name: 'days_ago') int get daysAgo;
/// Create a copy of LastSessionMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastSessionMetaCopyWith<LastSessionMeta> get copyWith => _$LastSessionMetaCopyWithImpl<LastSessionMeta>(this as LastSessionMeta, _$identity);

  /// Serializes this LastSessionMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastSessionMeta&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastUserQuery, lastUserQuery) || other.lastUserQuery == lastUserQuery)&&(identical(other.daysAgo, daysAgo) || other.daysAgo == daysAgo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,lastMessageAt,lastUserQuery,daysAgo);

@override
String toString() {
  return 'LastSessionMeta(sessionId: $sessionId, lastMessageAt: $lastMessageAt, lastUserQuery: $lastUserQuery, daysAgo: $daysAgo)';
}


}

/// @nodoc
abstract mixin class $LastSessionMetaCopyWith<$Res>  {
  factory $LastSessionMetaCopyWith(LastSessionMeta value, $Res Function(LastSessionMeta) _then) = _$LastSessionMetaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'last_message_at') String lastMessageAt,@JsonKey(name: 'last_user_query') String lastUserQuery,@JsonKey(name: 'days_ago') int daysAgo
});




}
/// @nodoc
class _$LastSessionMetaCopyWithImpl<$Res>
    implements $LastSessionMetaCopyWith<$Res> {
  _$LastSessionMetaCopyWithImpl(this._self, this._then);

  final LastSessionMeta _self;
  final $Res Function(LastSessionMeta) _then;

/// Create a copy of LastSessionMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? lastMessageAt = null,Object? lastUserQuery = null,Object? daysAgo = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as String,lastUserQuery: null == lastUserQuery ? _self.lastUserQuery : lastUserQuery // ignore: cast_nullable_to_non_nullable
as String,daysAgo: null == daysAgo ? _self.daysAgo : daysAgo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LastSessionMeta].
extension LastSessionMetaPatterns on LastSessionMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastSessionMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastSessionMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastSessionMeta value)  $default,){
final _that = this;
switch (_that) {
case _LastSessionMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastSessionMeta value)?  $default,){
final _that = this;
switch (_that) {
case _LastSessionMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'last_message_at')  String lastMessageAt, @JsonKey(name: 'last_user_query')  String lastUserQuery, @JsonKey(name: 'days_ago')  int daysAgo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastSessionMeta() when $default != null:
return $default(_that.sessionId,_that.lastMessageAt,_that.lastUserQuery,_that.daysAgo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'last_message_at')  String lastMessageAt, @JsonKey(name: 'last_user_query')  String lastUserQuery, @JsonKey(name: 'days_ago')  int daysAgo)  $default,) {final _that = this;
switch (_that) {
case _LastSessionMeta():
return $default(_that.sessionId,_that.lastMessageAt,_that.lastUserQuery,_that.daysAgo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'last_message_at')  String lastMessageAt, @JsonKey(name: 'last_user_query')  String lastUserQuery, @JsonKey(name: 'days_ago')  int daysAgo)?  $default,) {final _that = this;
switch (_that) {
case _LastSessionMeta() when $default != null:
return $default(_that.sessionId,_that.lastMessageAt,_that.lastUserQuery,_that.daysAgo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LastSessionMeta implements LastSessionMeta {
  const _LastSessionMeta({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'last_message_at') required this.lastMessageAt, @JsonKey(name: 'last_user_query') required this.lastUserQuery, @JsonKey(name: 'days_ago') required this.daysAgo});
  factory _LastSessionMeta.fromJson(Map<String, dynamic> json) => _$LastSessionMetaFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'last_message_at') final  String lastMessageAt;
@override@JsonKey(name: 'last_user_query') final  String lastUserQuery;
@override@JsonKey(name: 'days_ago') final  int daysAgo;

/// Create a copy of LastSessionMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastSessionMetaCopyWith<_LastSessionMeta> get copyWith => __$LastSessionMetaCopyWithImpl<_LastSessionMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LastSessionMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastSessionMeta&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastUserQuery, lastUserQuery) || other.lastUserQuery == lastUserQuery)&&(identical(other.daysAgo, daysAgo) || other.daysAgo == daysAgo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,lastMessageAt,lastUserQuery,daysAgo);

@override
String toString() {
  return 'LastSessionMeta(sessionId: $sessionId, lastMessageAt: $lastMessageAt, lastUserQuery: $lastUserQuery, daysAgo: $daysAgo)';
}


}

/// @nodoc
abstract mixin class _$LastSessionMetaCopyWith<$Res> implements $LastSessionMetaCopyWith<$Res> {
  factory _$LastSessionMetaCopyWith(_LastSessionMeta value, $Res Function(_LastSessionMeta) _then) = __$LastSessionMetaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'last_message_at') String lastMessageAt,@JsonKey(name: 'last_user_query') String lastUserQuery,@JsonKey(name: 'days_ago') int daysAgo
});




}
/// @nodoc
class __$LastSessionMetaCopyWithImpl<$Res>
    implements _$LastSessionMetaCopyWith<$Res> {
  __$LastSessionMetaCopyWithImpl(this._self, this._then);

  final _LastSessionMeta _self;
  final $Res Function(_LastSessionMeta) _then;

/// Create a copy of LastSessionMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? lastMessageAt = null,Object? lastUserQuery = null,Object? daysAgo = null,}) {
  return _then(_LastSessionMeta(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as String,lastUserQuery: null == lastUserQuery ? _self.lastUserQuery : lastUserQuery // ignore: cast_nullable_to_non_nullable
as String,daysAgo: null == daysAgo ? _self.daysAgo : daysAgo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
