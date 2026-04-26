// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'law_index_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LawIndex {

 int get version; List<LawGroup> get groups;
/// Create a copy of LawIndex
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LawIndexCopyWith<LawIndex> get copyWith => _$LawIndexCopyWithImpl<LawIndex>(this as LawIndex, _$identity);

  /// Serializes this LawIndex to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LawIndex&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'LawIndex(version: $version, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $LawIndexCopyWith<$Res>  {
  factory $LawIndexCopyWith(LawIndex value, $Res Function(LawIndex) _then) = _$LawIndexCopyWithImpl;
@useResult
$Res call({
 int version, List<LawGroup> groups
});




}
/// @nodoc
class _$LawIndexCopyWithImpl<$Res>
    implements $LawIndexCopyWith<$Res> {
  _$LawIndexCopyWithImpl(this._self, this._then);

  final LawIndex _self;
  final $Res Function(LawIndex) _then;

/// Create a copy of LawIndex
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? groups = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<LawGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [LawIndex].
extension LawIndexPatterns on LawIndex {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LawIndex value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LawIndex() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LawIndex value)  $default,){
final _that = this;
switch (_that) {
case _LawIndex():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LawIndex value)?  $default,){
final _that = this;
switch (_that) {
case _LawIndex() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<LawGroup> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LawIndex() when $default != null:
return $default(_that.version,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<LawGroup> groups)  $default,) {final _that = this;
switch (_that) {
case _LawIndex():
return $default(_that.version,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<LawGroup> groups)?  $default,) {final _that = this;
switch (_that) {
case _LawIndex() when $default != null:
return $default(_that.version,_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LawIndex implements LawIndex {
  const _LawIndex({required this.version, required final  List<LawGroup> groups}): _groups = groups;
  factory _LawIndex.fromJson(Map<String, dynamic> json) => _$LawIndexFromJson(json);

@override final  int version;
 final  List<LawGroup> _groups;
@override List<LawGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of LawIndex
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LawIndexCopyWith<_LawIndex> get copyWith => __$LawIndexCopyWithImpl<_LawIndex>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LawIndexToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LawIndex&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._groups, _groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_groups));

@override
String toString() {
  return 'LawIndex(version: $version, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$LawIndexCopyWith<$Res> implements $LawIndexCopyWith<$Res> {
  factory _$LawIndexCopyWith(_LawIndex value, $Res Function(_LawIndex) _then) = __$LawIndexCopyWithImpl;
@override @useResult
$Res call({
 int version, List<LawGroup> groups
});




}
/// @nodoc
class __$LawIndexCopyWithImpl<$Res>
    implements _$LawIndexCopyWith<$Res> {
  __$LawIndexCopyWithImpl(this._self, this._then);

  final _LawIndex _self;
  final $Res Function(_LawIndex) _then;

/// Create a copy of LawIndex
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? groups = null,}) {
  return _then(_LawIndex(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<LawGroup>,
  ));
}


}


/// @nodoc
mixin _$LawGroup {

@JsonKey(name: 'law_name') String get lawName;@JsonKey(name: 'short_name') String get shortName;@JsonKey(name: 'doc_type') String get docType; List<LawArticleEntry> get articles;
/// Create a copy of LawGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LawGroupCopyWith<LawGroup> get copyWith => _$LawGroupCopyWithImpl<LawGroup>(this as LawGroup, _$identity);

  /// Serializes this LawGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LawGroup&&(identical(other.lawName, lawName) || other.lawName == lawName)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.docType, docType) || other.docType == docType)&&const DeepCollectionEquality().equals(other.articles, articles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lawName,shortName,docType,const DeepCollectionEquality().hash(articles));

@override
String toString() {
  return 'LawGroup(lawName: $lawName, shortName: $shortName, docType: $docType, articles: $articles)';
}


}

/// @nodoc
abstract mixin class $LawGroupCopyWith<$Res>  {
  factory $LawGroupCopyWith(LawGroup value, $Res Function(LawGroup) _then) = _$LawGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'law_name') String lawName,@JsonKey(name: 'short_name') String shortName,@JsonKey(name: 'doc_type') String docType, List<LawArticleEntry> articles
});




}
/// @nodoc
class _$LawGroupCopyWithImpl<$Res>
    implements $LawGroupCopyWith<$Res> {
  _$LawGroupCopyWithImpl(this._self, this._then);

  final LawGroup _self;
  final $Res Function(LawGroup) _then;

/// Create a copy of LawGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lawName = null,Object? shortName = null,Object? docType = null,Object? articles = null,}) {
  return _then(_self.copyWith(
lawName: null == lawName ? _self.lawName : lawName // ignore: cast_nullable_to_non_nullable
as String,shortName: null == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String,docType: null == docType ? _self.docType : docType // ignore: cast_nullable_to_non_nullable
as String,articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<LawArticleEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [LawGroup].
extension LawGroupPatterns on LawGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LawGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LawGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LawGroup value)  $default,){
final _that = this;
switch (_that) {
case _LawGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LawGroup value)?  $default,){
final _that = this;
switch (_that) {
case _LawGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'law_name')  String lawName, @JsonKey(name: 'short_name')  String shortName, @JsonKey(name: 'doc_type')  String docType,  List<LawArticleEntry> articles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LawGroup() when $default != null:
return $default(_that.lawName,_that.shortName,_that.docType,_that.articles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'law_name')  String lawName, @JsonKey(name: 'short_name')  String shortName, @JsonKey(name: 'doc_type')  String docType,  List<LawArticleEntry> articles)  $default,) {final _that = this;
switch (_that) {
case _LawGroup():
return $default(_that.lawName,_that.shortName,_that.docType,_that.articles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'law_name')  String lawName, @JsonKey(name: 'short_name')  String shortName, @JsonKey(name: 'doc_type')  String docType,  List<LawArticleEntry> articles)?  $default,) {final _that = this;
switch (_that) {
case _LawGroup() when $default != null:
return $default(_that.lawName,_that.shortName,_that.docType,_that.articles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LawGroup implements LawGroup {
  const _LawGroup({@JsonKey(name: 'law_name') required this.lawName, @JsonKey(name: 'short_name') required this.shortName, @JsonKey(name: 'doc_type') required this.docType, required final  List<LawArticleEntry> articles}): _articles = articles;
  factory _LawGroup.fromJson(Map<String, dynamic> json) => _$LawGroupFromJson(json);

@override@JsonKey(name: 'law_name') final  String lawName;
@override@JsonKey(name: 'short_name') final  String shortName;
@override@JsonKey(name: 'doc_type') final  String docType;
 final  List<LawArticleEntry> _articles;
@override List<LawArticleEntry> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}


/// Create a copy of LawGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LawGroupCopyWith<_LawGroup> get copyWith => __$LawGroupCopyWithImpl<_LawGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LawGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LawGroup&&(identical(other.lawName, lawName) || other.lawName == lawName)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.docType, docType) || other.docType == docType)&&const DeepCollectionEquality().equals(other._articles, _articles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lawName,shortName,docType,const DeepCollectionEquality().hash(_articles));

@override
String toString() {
  return 'LawGroup(lawName: $lawName, shortName: $shortName, docType: $docType, articles: $articles)';
}


}

/// @nodoc
abstract mixin class _$LawGroupCopyWith<$Res> implements $LawGroupCopyWith<$Res> {
  factory _$LawGroupCopyWith(_LawGroup value, $Res Function(_LawGroup) _then) = __$LawGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'law_name') String lawName,@JsonKey(name: 'short_name') String shortName,@JsonKey(name: 'doc_type') String docType, List<LawArticleEntry> articles
});




}
/// @nodoc
class __$LawGroupCopyWithImpl<$Res>
    implements _$LawGroupCopyWith<$Res> {
  __$LawGroupCopyWithImpl(this._self, this._then);

  final _LawGroup _self;
  final $Res Function(_LawGroup) _then;

/// Create a copy of LawGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lawName = null,Object? shortName = null,Object? docType = null,Object? articles = null,}) {
  return _then(_LawGroup(
lawName: null == lawName ? _self.lawName : lawName // ignore: cast_nullable_to_non_nullable
as String,shortName: null == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String,docType: null == docType ? _self.docType : docType // ignore: cast_nullable_to_non_nullable
as String,articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<LawArticleEntry>,
  ));
}


}


/// @nodoc
mixin _$LawArticleEntry {

@JsonKey(name: 'article_no') String get articleNo; String get title;
/// Create a copy of LawArticleEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LawArticleEntryCopyWith<LawArticleEntry> get copyWith => _$LawArticleEntryCopyWithImpl<LawArticleEntry>(this as LawArticleEntry, _$identity);

  /// Serializes this LawArticleEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LawArticleEntry&&(identical(other.articleNo, articleNo) || other.articleNo == articleNo)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleNo,title);

@override
String toString() {
  return 'LawArticleEntry(articleNo: $articleNo, title: $title)';
}


}

/// @nodoc
abstract mixin class $LawArticleEntryCopyWith<$Res>  {
  factory $LawArticleEntryCopyWith(LawArticleEntry value, $Res Function(LawArticleEntry) _then) = _$LawArticleEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'article_no') String articleNo, String title
});




}
/// @nodoc
class _$LawArticleEntryCopyWithImpl<$Res>
    implements $LawArticleEntryCopyWith<$Res> {
  _$LawArticleEntryCopyWithImpl(this._self, this._then);

  final LawArticleEntry _self;
  final $Res Function(LawArticleEntry) _then;

/// Create a copy of LawArticleEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleNo = null,Object? title = null,}) {
  return _then(_self.copyWith(
articleNo: null == articleNo ? _self.articleNo : articleNo // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LawArticleEntry].
extension LawArticleEntryPatterns on LawArticleEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LawArticleEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LawArticleEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LawArticleEntry value)  $default,){
final _that = this;
switch (_that) {
case _LawArticleEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LawArticleEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LawArticleEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'article_no')  String articleNo,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LawArticleEntry() when $default != null:
return $default(_that.articleNo,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'article_no')  String articleNo,  String title)  $default,) {final _that = this;
switch (_that) {
case _LawArticleEntry():
return $default(_that.articleNo,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'article_no')  String articleNo,  String title)?  $default,) {final _that = this;
switch (_that) {
case _LawArticleEntry() when $default != null:
return $default(_that.articleNo,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LawArticleEntry implements LawArticleEntry {
  const _LawArticleEntry({@JsonKey(name: 'article_no') required this.articleNo, required this.title});
  factory _LawArticleEntry.fromJson(Map<String, dynamic> json) => _$LawArticleEntryFromJson(json);

@override@JsonKey(name: 'article_no') final  String articleNo;
@override final  String title;

/// Create a copy of LawArticleEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LawArticleEntryCopyWith<_LawArticleEntry> get copyWith => __$LawArticleEntryCopyWithImpl<_LawArticleEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LawArticleEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LawArticleEntry&&(identical(other.articleNo, articleNo) || other.articleNo == articleNo)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleNo,title);

@override
String toString() {
  return 'LawArticleEntry(articleNo: $articleNo, title: $title)';
}


}

/// @nodoc
abstract mixin class _$LawArticleEntryCopyWith<$Res> implements $LawArticleEntryCopyWith<$Res> {
  factory _$LawArticleEntryCopyWith(_LawArticleEntry value, $Res Function(_LawArticleEntry) _then) = __$LawArticleEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'article_no') String articleNo, String title
});




}
/// @nodoc
class __$LawArticleEntryCopyWithImpl<$Res>
    implements _$LawArticleEntryCopyWith<$Res> {
  __$LawArticleEntryCopyWithImpl(this._self, this._then);

  final _LawArticleEntry _self;
  final $Res Function(_LawArticleEntry) _then;

/// Create a copy of LawArticleEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleNo = null,Object? title = null,}) {
  return _then(_LawArticleEntry(
articleNo: null == articleNo ? _self.articleNo : articleNo // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
