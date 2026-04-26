// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedbackRequestDto {

@JsonKey(name: 'conversation_id') String get conversationId; int get rating;@JsonKey(name: 'issue_type') String? get issueType; String? get comment;
/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackRequestDtoCopyWith<FeedbackRequestDto> get copyWith => _$FeedbackRequestDtoCopyWithImpl<FeedbackRequestDto>(this as FeedbackRequestDto, _$identity);

  /// Serializes this FeedbackRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackRequestDto&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.issueType, issueType) || other.issueType == issueType)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,rating,issueType,comment);

@override
String toString() {
  return 'FeedbackRequestDto(conversationId: $conversationId, rating: $rating, issueType: $issueType, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $FeedbackRequestDtoCopyWith<$Res>  {
  factory $FeedbackRequestDtoCopyWith(FeedbackRequestDto value, $Res Function(FeedbackRequestDto) _then) = _$FeedbackRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId, int rating,@JsonKey(name: 'issue_type') String? issueType, String? comment
});




}
/// @nodoc
class _$FeedbackRequestDtoCopyWithImpl<$Res>
    implements $FeedbackRequestDtoCopyWith<$Res> {
  _$FeedbackRequestDtoCopyWithImpl(this._self, this._then);

  final FeedbackRequestDto _self;
  final $Res Function(FeedbackRequestDto) _then;

/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? rating = null,Object? issueType = freezed,Object? comment = freezed,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,issueType: freezed == issueType ? _self.issueType : issueType // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackRequestDto].
extension FeedbackRequestDtoPatterns on FeedbackRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId,  int rating, @JsonKey(name: 'issue_type')  String? issueType,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
return $default(_that.conversationId,_that.rating,_that.issueType,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId,  int rating, @JsonKey(name: 'issue_type')  String? issueType,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _FeedbackRequestDto():
return $default(_that.conversationId,_that.rating,_that.issueType,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conversation_id')  String conversationId,  int rating, @JsonKey(name: 'issue_type')  String? issueType,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
return $default(_that.conversationId,_that.rating,_that.issueType,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedbackRequestDto implements FeedbackRequestDto {
  const _FeedbackRequestDto({@JsonKey(name: 'conversation_id') required this.conversationId, required this.rating, @JsonKey(name: 'issue_type') this.issueType, this.comment});
  factory _FeedbackRequestDto.fromJson(Map<String, dynamic> json) => _$FeedbackRequestDtoFromJson(json);

@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override final  int rating;
@override@JsonKey(name: 'issue_type') final  String? issueType;
@override final  String? comment;

/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackRequestDtoCopyWith<_FeedbackRequestDto> get copyWith => __$FeedbackRequestDtoCopyWithImpl<_FeedbackRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedbackRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackRequestDto&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.issueType, issueType) || other.issueType == issueType)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,rating,issueType,comment);

@override
String toString() {
  return 'FeedbackRequestDto(conversationId: $conversationId, rating: $rating, issueType: $issueType, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$FeedbackRequestDtoCopyWith<$Res> implements $FeedbackRequestDtoCopyWith<$Res> {
  factory _$FeedbackRequestDtoCopyWith(_FeedbackRequestDto value, $Res Function(_FeedbackRequestDto) _then) = __$FeedbackRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId, int rating,@JsonKey(name: 'issue_type') String? issueType, String? comment
});




}
/// @nodoc
class __$FeedbackRequestDtoCopyWithImpl<$Res>
    implements _$FeedbackRequestDtoCopyWith<$Res> {
  __$FeedbackRequestDtoCopyWithImpl(this._self, this._then);

  final _FeedbackRequestDto _self;
  final $Res Function(_FeedbackRequestDto) _then;

/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? rating = null,Object? issueType = freezed,Object? comment = freezed,}) {
  return _then(_FeedbackRequestDto(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,issueType: freezed == issueType ? _self.issueType : issueType // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
