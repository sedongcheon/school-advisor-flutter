// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sse_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SseEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SseEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SseEvent()';
}


}

/// @nodoc
class $SseEventCopyWith<$Res>  {
$SseEventCopyWith(SseEvent _, $Res Function(SseEvent) __);
}


/// Adds pattern-matching-related methods to [SseEvent].
extension SseEventPatterns on SseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SseText value)?  text,TResult Function( SseCitations value)?  citations,TResult Function( SseDone value)?  done,TResult Function( SseError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SseText() when text != null:
return text(_that);case SseCitations() when citations != null:
return citations(_that);case SseDone() when done != null:
return done(_that);case SseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SseText value)  text,required TResult Function( SseCitations value)  citations,required TResult Function( SseDone value)  done,required TResult Function( SseError value)  error,}){
final _that = this;
switch (_that) {
case SseText():
return text(_that);case SseCitations():
return citations(_that);case SseDone():
return done(_that);case SseError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SseText value)?  text,TResult? Function( SseCitations value)?  citations,TResult? Function( SseDone value)?  done,TResult? Function( SseError value)?  error,}){
final _that = this;
switch (_that) {
case SseText() when text != null:
return text(_that);case SseCitations() when citations != null:
return citations(_that);case SseDone() when done != null:
return done(_that);case SseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String content)?  text,TResult Function( List<CitationChunk> chunks)?  citations,TResult Function( String conversationId,  String? model,  int? inputTokens,  int? outputTokens)?  done,TResult Function( String code,  String? message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SseText() when text != null:
return text(_that.content);case SseCitations() when citations != null:
return citations(_that.chunks);case SseDone() when done != null:
return done(_that.conversationId,_that.model,_that.inputTokens,_that.outputTokens);case SseError() when error != null:
return error(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String content)  text,required TResult Function( List<CitationChunk> chunks)  citations,required TResult Function( String conversationId,  String? model,  int? inputTokens,  int? outputTokens)  done,required TResult Function( String code,  String? message)  error,}) {final _that = this;
switch (_that) {
case SseText():
return text(_that.content);case SseCitations():
return citations(_that.chunks);case SseDone():
return done(_that.conversationId,_that.model,_that.inputTokens,_that.outputTokens);case SseError():
return error(_that.code,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String content)?  text,TResult? Function( List<CitationChunk> chunks)?  citations,TResult? Function( String conversationId,  String? model,  int? inputTokens,  int? outputTokens)?  done,TResult? Function( String code,  String? message)?  error,}) {final _that = this;
switch (_that) {
case SseText() when text != null:
return text(_that.content);case SseCitations() when citations != null:
return citations(_that.chunks);case SseDone() when done != null:
return done(_that.conversationId,_that.model,_that.inputTokens,_that.outputTokens);case SseError() when error != null:
return error(_that.code,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SseText implements SseEvent {
  const SseText({required this.content});
  

 final  String content;

/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SseTextCopyWith<SseText> get copyWith => _$SseTextCopyWithImpl<SseText>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SseText&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'SseEvent.text(content: $content)';
}


}

/// @nodoc
abstract mixin class $SseTextCopyWith<$Res> implements $SseEventCopyWith<$Res> {
  factory $SseTextCopyWith(SseText value, $Res Function(SseText) _then) = _$SseTextCopyWithImpl;
@useResult
$Res call({
 String content
});




}
/// @nodoc
class _$SseTextCopyWithImpl<$Res>
    implements $SseTextCopyWith<$Res> {
  _$SseTextCopyWithImpl(this._self, this._then);

  final SseText _self;
  final $Res Function(SseText) _then;

/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(SseText(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SseCitations implements SseEvent {
  const SseCitations({required final  List<CitationChunk> chunks}): _chunks = chunks;
  

 final  List<CitationChunk> _chunks;
 List<CitationChunk> get chunks {
  if (_chunks is EqualUnmodifiableListView) return _chunks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chunks);
}


/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SseCitationsCopyWith<SseCitations> get copyWith => _$SseCitationsCopyWithImpl<SseCitations>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SseCitations&&const DeepCollectionEquality().equals(other._chunks, _chunks));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_chunks));

@override
String toString() {
  return 'SseEvent.citations(chunks: $chunks)';
}


}

/// @nodoc
abstract mixin class $SseCitationsCopyWith<$Res> implements $SseEventCopyWith<$Res> {
  factory $SseCitationsCopyWith(SseCitations value, $Res Function(SseCitations) _then) = _$SseCitationsCopyWithImpl;
@useResult
$Res call({
 List<CitationChunk> chunks
});




}
/// @nodoc
class _$SseCitationsCopyWithImpl<$Res>
    implements $SseCitationsCopyWith<$Res> {
  _$SseCitationsCopyWithImpl(this._self, this._then);

  final SseCitations _self;
  final $Res Function(SseCitations) _then;

/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? chunks = null,}) {
  return _then(SseCitations(
chunks: null == chunks ? _self._chunks : chunks // ignore: cast_nullable_to_non_nullable
as List<CitationChunk>,
  ));
}


}

/// @nodoc


class SseDone implements SseEvent {
  const SseDone({required this.conversationId, this.model, this.inputTokens, this.outputTokens});
  

 final  String conversationId;
 final  String? model;
 final  int? inputTokens;
 final  int? outputTokens;

/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SseDoneCopyWith<SseDone> get copyWith => _$SseDoneCopyWithImpl<SseDone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SseDone&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.model, model) || other.model == model)&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens));
}


@override
int get hashCode => Object.hash(runtimeType,conversationId,model,inputTokens,outputTokens);

@override
String toString() {
  return 'SseEvent.done(conversationId: $conversationId, model: $model, inputTokens: $inputTokens, outputTokens: $outputTokens)';
}


}

/// @nodoc
abstract mixin class $SseDoneCopyWith<$Res> implements $SseEventCopyWith<$Res> {
  factory $SseDoneCopyWith(SseDone value, $Res Function(SseDone) _then) = _$SseDoneCopyWithImpl;
@useResult
$Res call({
 String conversationId, String? model, int? inputTokens, int? outputTokens
});




}
/// @nodoc
class _$SseDoneCopyWithImpl<$Res>
    implements $SseDoneCopyWith<$Res> {
  _$SseDoneCopyWithImpl(this._self, this._then);

  final SseDone _self;
  final $Res Function(SseDone) _then;

/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? model = freezed,Object? inputTokens = freezed,Object? outputTokens = freezed,}) {
  return _then(SseDone(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,inputTokens: freezed == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int?,outputTokens: freezed == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class SseError implements SseEvent {
  const SseError({required this.code, this.message});
  

 final  String code;
 final  String? message;

/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SseErrorCopyWith<SseError> get copyWith => _$SseErrorCopyWithImpl<SseError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SseError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'SseEvent.error(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $SseErrorCopyWith<$Res> implements $SseEventCopyWith<$Res> {
  factory $SseErrorCopyWith(SseError value, $Res Function(SseError) _then) = _$SseErrorCopyWithImpl;
@useResult
$Res call({
 String code, String? message
});




}
/// @nodoc
class _$SseErrorCopyWithImpl<$Res>
    implements $SseErrorCopyWith<$Res> {
  _$SseErrorCopyWithImpl(this._self, this._then);

  final SseError _self;
  final $Res Function(SseError) _then;

/// Create a copy of SseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = freezed,}) {
  return _then(SseError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CitationChunk {

 int get id;/// 사람 읽기용 라벨. 예: "학폭예방법 제17조 제1항".
 String get law; String? get url;
/// Create a copy of CitationChunk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitationChunkCopyWith<CitationChunk> get copyWith => _$CitationChunkCopyWithImpl<CitationChunk>(this as CitationChunk, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitationChunk&&(identical(other.id, id) || other.id == id)&&(identical(other.law, law) || other.law == law)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,law,url);

@override
String toString() {
  return 'CitationChunk(id: $id, law: $law, url: $url)';
}


}

/// @nodoc
abstract mixin class $CitationChunkCopyWith<$Res>  {
  factory $CitationChunkCopyWith(CitationChunk value, $Res Function(CitationChunk) _then) = _$CitationChunkCopyWithImpl;
@useResult
$Res call({
 int id, String law, String? url
});




}
/// @nodoc
class _$CitationChunkCopyWithImpl<$Res>
    implements $CitationChunkCopyWith<$Res> {
  _$CitationChunkCopyWithImpl(this._self, this._then);

  final CitationChunk _self;
  final $Res Function(CitationChunk) _then;

/// Create a copy of CitationChunk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? law = null,Object? url = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,law: null == law ? _self.law : law // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CitationChunk].
extension CitationChunkPatterns on CitationChunk {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CitationChunk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CitationChunk() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CitationChunk value)  $default,){
final _that = this;
switch (_that) {
case _CitationChunk():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CitationChunk value)?  $default,){
final _that = this;
switch (_that) {
case _CitationChunk() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String law,  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CitationChunk() when $default != null:
return $default(_that.id,_that.law,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String law,  String? url)  $default,) {final _that = this;
switch (_that) {
case _CitationChunk():
return $default(_that.id,_that.law,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String law,  String? url)?  $default,) {final _that = this;
switch (_that) {
case _CitationChunk() when $default != null:
return $default(_that.id,_that.law,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _CitationChunk implements CitationChunk {
  const _CitationChunk({required this.id, required this.law, this.url});
  

@override final  int id;
/// 사람 읽기용 라벨. 예: "학폭예방법 제17조 제1항".
@override final  String law;
@override final  String? url;

/// Create a copy of CitationChunk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CitationChunkCopyWith<_CitationChunk> get copyWith => __$CitationChunkCopyWithImpl<_CitationChunk>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CitationChunk&&(identical(other.id, id) || other.id == id)&&(identical(other.law, law) || other.law == law)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,law,url);

@override
String toString() {
  return 'CitationChunk(id: $id, law: $law, url: $url)';
}


}

/// @nodoc
abstract mixin class _$CitationChunkCopyWith<$Res> implements $CitationChunkCopyWith<$Res> {
  factory _$CitationChunkCopyWith(_CitationChunk value, $Res Function(_CitationChunk) _then) = __$CitationChunkCopyWithImpl;
@override @useResult
$Res call({
 int id, String law, String? url
});




}
/// @nodoc
class __$CitationChunkCopyWithImpl<$Res>
    implements _$CitationChunkCopyWith<$Res> {
  __$CitationChunkCopyWithImpl(this._self, this._then);

  final _CitationChunk _self;
  final $Res Function(_CitationChunk) _then;

/// Create a copy of CitationChunk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? law = null,Object? url = freezed,}) {
  return _then(_CitationChunk(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,law: null == law ? _self.law : law // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
