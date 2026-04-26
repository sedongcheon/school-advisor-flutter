// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRequest {

 String get query;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'device_id') String? get deviceId;
/// Create a copy of ChatRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRequestCopyWith<ChatRequest> get copyWith => _$ChatRequestCopyWithImpl<ChatRequest>(this as ChatRequest, _$identity);

  /// Serializes this ChatRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRequest&&(identical(other.query, query) || other.query == query)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,sessionId,deviceId);

@override
String toString() {
  return 'ChatRequest(query: $query, sessionId: $sessionId, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $ChatRequestCopyWith<$Res>  {
  factory $ChatRequestCopyWith(ChatRequest value, $Res Function(ChatRequest) _then) = _$ChatRequestCopyWithImpl;
@useResult
$Res call({
 String query,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'device_id') String? deviceId
});




}
/// @nodoc
class _$ChatRequestCopyWithImpl<$Res>
    implements $ChatRequestCopyWith<$Res> {
  _$ChatRequestCopyWithImpl(this._self, this._then);

  final ChatRequest _self;
  final $Res Function(ChatRequest) _then;

/// Create a copy of ChatRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? sessionId = null,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRequest].
extension ChatRequestPatterns on ChatRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRequest value)  $default,){
final _that = this;
switch (_that) {
case _ChatRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'device_id')  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRequest() when $default != null:
return $default(_that.query,_that.sessionId,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'device_id')  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _ChatRequest():
return $default(_that.query,_that.sessionId,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'device_id')  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _ChatRequest() when $default != null:
return $default(_that.query,_that.sessionId,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRequest implements ChatRequest {
  const _ChatRequest({required this.query, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'device_id') this.deviceId});
  factory _ChatRequest.fromJson(Map<String, dynamic> json) => _$ChatRequestFromJson(json);

@override final  String query;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'device_id') final  String? deviceId;

/// Create a copy of ChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRequestCopyWith<_ChatRequest> get copyWith => __$ChatRequestCopyWithImpl<_ChatRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRequest&&(identical(other.query, query) || other.query == query)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,sessionId,deviceId);

@override
String toString() {
  return 'ChatRequest(query: $query, sessionId: $sessionId, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$ChatRequestCopyWith<$Res> implements $ChatRequestCopyWith<$Res> {
  factory _$ChatRequestCopyWith(_ChatRequest value, $Res Function(_ChatRequest) _then) = __$ChatRequestCopyWithImpl;
@override @useResult
$Res call({
 String query,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'device_id') String? deviceId
});




}
/// @nodoc
class __$ChatRequestCopyWithImpl<$Res>
    implements _$ChatRequestCopyWith<$Res> {
  __$ChatRequestCopyWithImpl(this._self, this._then);

  final _ChatRequest _self;
  final $Res Function(_ChatRequest) _then;

/// Create a copy of ChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? sessionId = null,Object? deviceId = freezed,}) {
  return _then(_ChatRequest(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ChatMessage {

 String get id; ChatRole get role; String get content;/// 로컬 DB(`messages`) 의 PK. 영속화된 후에 채워진다.
 int? get dbId;/// 답변에 사용된 인용 청크. user 메시지는 비어 있음.
 List<CitationChunk> get citations;/// 백엔드가 done 이벤트로 내려주는 conversation_id.
/// 신고/피드백 전송 시 키로 사용.
 String? get conversationId;/// 어시스턴트 답변이 스트리밍 중인지.
 bool get isStreaming;/// 스트림 내 `event: error` 로 종료된 메시지의 사용자 노출 문구.
 String? get errorMessage;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.dbId, dbId) || other.dbId == dbId)&&const DeepCollectionEquality().equals(other.citations, citations)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,dbId,const DeepCollectionEquality().hash(citations),conversationId,isStreaming,errorMessage);

@override
String toString() {
  return 'ChatMessage(id: $id, role: $role, content: $content, dbId: $dbId, citations: $citations, conversationId: $conversationId, isStreaming: $isStreaming, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, ChatRole role, String content, int? dbId, List<CitationChunk> citations, String? conversationId, bool isStreaming, String? errorMessage
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? content = null,Object? dbId = freezed,Object? citations = null,Object? conversationId = freezed,Object? isStreaming = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,dbId: freezed == dbId ? _self.dbId : dbId // ignore: cast_nullable_to_non_nullable
as int?,citations: null == citations ? _self.citations : citations // ignore: cast_nullable_to_non_nullable
as List<CitationChunk>,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ChatRole role,  String content,  int? dbId,  List<CitationChunk> citations,  String? conversationId,  bool isStreaming,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.dbId,_that.citations,_that.conversationId,_that.isStreaming,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ChatRole role,  String content,  int? dbId,  List<CitationChunk> citations,  String? conversationId,  bool isStreaming,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.role,_that.content,_that.dbId,_that.citations,_that.conversationId,_that.isStreaming,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ChatRole role,  String content,  int? dbId,  List<CitationChunk> citations,  String? conversationId,  bool isStreaming,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.dbId,_that.citations,_that.conversationId,_that.isStreaming,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.role, required this.content, this.dbId, final  List<CitationChunk> citations = const <CitationChunk>[], this.conversationId, this.isStreaming = false, this.errorMessage}): _citations = citations;
  

@override final  String id;
@override final  ChatRole role;
@override final  String content;
/// 로컬 DB(`messages`) 의 PK. 영속화된 후에 채워진다.
@override final  int? dbId;
/// 답변에 사용된 인용 청크. user 메시지는 비어 있음.
 final  List<CitationChunk> _citations;
/// 답변에 사용된 인용 청크. user 메시지는 비어 있음.
@override@JsonKey() List<CitationChunk> get citations {
  if (_citations is EqualUnmodifiableListView) return _citations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_citations);
}

/// 백엔드가 done 이벤트로 내려주는 conversation_id.
/// 신고/피드백 전송 시 키로 사용.
@override final  String? conversationId;
/// 어시스턴트 답변이 스트리밍 중인지.
@override@JsonKey() final  bool isStreaming;
/// 스트림 내 `event: error` 로 종료된 메시지의 사용자 노출 문구.
@override final  String? errorMessage;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.dbId, dbId) || other.dbId == dbId)&&const DeepCollectionEquality().equals(other._citations, _citations)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,dbId,const DeepCollectionEquality().hash(_citations),conversationId,isStreaming,errorMessage);

@override
String toString() {
  return 'ChatMessage(id: $id, role: $role, content: $content, dbId: $dbId, citations: $citations, conversationId: $conversationId, isStreaming: $isStreaming, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, ChatRole role, String content, int? dbId, List<CitationChunk> citations, String? conversationId, bool isStreaming, String? errorMessage
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? content = null,Object? dbId = freezed,Object? citations = null,Object? conversationId = freezed,Object? isStreaming = null,Object? errorMessage = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,dbId: freezed == dbId ? _self.dbId : dbId // ignore: cast_nullable_to_non_nullable
as int?,citations: null == citations ? _self._citations : citations // ignore: cast_nullable_to_non_nullable
as List<CitationChunk>,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
