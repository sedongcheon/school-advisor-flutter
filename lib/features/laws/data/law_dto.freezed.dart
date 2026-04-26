// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'law_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LawArticle {

@JsonKey(name: 'law_name') String get lawName;@JsonKey(name: 'article_no') String get articleNo; String? get title;@JsonKey(name: 'doc_type') String get docType; String get content;@JsonKey(name: 'effective_date') String? get effectiveDate;@JsonKey(name: 'source_url') String? get sourceUrl;
/// Create a copy of LawArticle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LawArticleCopyWith<LawArticle> get copyWith => _$LawArticleCopyWithImpl<LawArticle>(this as LawArticle, _$identity);

  /// Serializes this LawArticle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LawArticle&&(identical(other.lawName, lawName) || other.lawName == lawName)&&(identical(other.articleNo, articleNo) || other.articleNo == articleNo)&&(identical(other.title, title) || other.title == title)&&(identical(other.docType, docType) || other.docType == docType)&&(identical(other.content, content) || other.content == content)&&(identical(other.effectiveDate, effectiveDate) || other.effectiveDate == effectiveDate)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lawName,articleNo,title,docType,content,effectiveDate,sourceUrl);

@override
String toString() {
  return 'LawArticle(lawName: $lawName, articleNo: $articleNo, title: $title, docType: $docType, content: $content, effectiveDate: $effectiveDate, sourceUrl: $sourceUrl)';
}


}

/// @nodoc
abstract mixin class $LawArticleCopyWith<$Res>  {
  factory $LawArticleCopyWith(LawArticle value, $Res Function(LawArticle) _then) = _$LawArticleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'law_name') String lawName,@JsonKey(name: 'article_no') String articleNo, String? title,@JsonKey(name: 'doc_type') String docType, String content,@JsonKey(name: 'effective_date') String? effectiveDate,@JsonKey(name: 'source_url') String? sourceUrl
});




}
/// @nodoc
class _$LawArticleCopyWithImpl<$Res>
    implements $LawArticleCopyWith<$Res> {
  _$LawArticleCopyWithImpl(this._self, this._then);

  final LawArticle _self;
  final $Res Function(LawArticle) _then;

/// Create a copy of LawArticle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lawName = null,Object? articleNo = null,Object? title = freezed,Object? docType = null,Object? content = null,Object? effectiveDate = freezed,Object? sourceUrl = freezed,}) {
  return _then(_self.copyWith(
lawName: null == lawName ? _self.lawName : lawName // ignore: cast_nullable_to_non_nullable
as String,articleNo: null == articleNo ? _self.articleNo : articleNo // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,docType: null == docType ? _self.docType : docType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,effectiveDate: freezed == effectiveDate ? _self.effectiveDate : effectiveDate // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LawArticle].
extension LawArticlePatterns on LawArticle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LawArticle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LawArticle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LawArticle value)  $default,){
final _that = this;
switch (_that) {
case _LawArticle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LawArticle value)?  $default,){
final _that = this;
switch (_that) {
case _LawArticle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'law_name')  String lawName, @JsonKey(name: 'article_no')  String articleNo,  String? title, @JsonKey(name: 'doc_type')  String docType,  String content, @JsonKey(name: 'effective_date')  String? effectiveDate, @JsonKey(name: 'source_url')  String? sourceUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LawArticle() when $default != null:
return $default(_that.lawName,_that.articleNo,_that.title,_that.docType,_that.content,_that.effectiveDate,_that.sourceUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'law_name')  String lawName, @JsonKey(name: 'article_no')  String articleNo,  String? title, @JsonKey(name: 'doc_type')  String docType,  String content, @JsonKey(name: 'effective_date')  String? effectiveDate, @JsonKey(name: 'source_url')  String? sourceUrl)  $default,) {final _that = this;
switch (_that) {
case _LawArticle():
return $default(_that.lawName,_that.articleNo,_that.title,_that.docType,_that.content,_that.effectiveDate,_that.sourceUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'law_name')  String lawName, @JsonKey(name: 'article_no')  String articleNo,  String? title, @JsonKey(name: 'doc_type')  String docType,  String content, @JsonKey(name: 'effective_date')  String? effectiveDate, @JsonKey(name: 'source_url')  String? sourceUrl)?  $default,) {final _that = this;
switch (_that) {
case _LawArticle() when $default != null:
return $default(_that.lawName,_that.articleNo,_that.title,_that.docType,_that.content,_that.effectiveDate,_that.sourceUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LawArticle implements LawArticle {
  const _LawArticle({@JsonKey(name: 'law_name') required this.lawName, @JsonKey(name: 'article_no') required this.articleNo, this.title, @JsonKey(name: 'doc_type') required this.docType, required this.content, @JsonKey(name: 'effective_date') this.effectiveDate, @JsonKey(name: 'source_url') this.sourceUrl});
  factory _LawArticle.fromJson(Map<String, dynamic> json) => _$LawArticleFromJson(json);

@override@JsonKey(name: 'law_name') final  String lawName;
@override@JsonKey(name: 'article_no') final  String articleNo;
@override final  String? title;
@override@JsonKey(name: 'doc_type') final  String docType;
@override final  String content;
@override@JsonKey(name: 'effective_date') final  String? effectiveDate;
@override@JsonKey(name: 'source_url') final  String? sourceUrl;

/// Create a copy of LawArticle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LawArticleCopyWith<_LawArticle> get copyWith => __$LawArticleCopyWithImpl<_LawArticle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LawArticleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LawArticle&&(identical(other.lawName, lawName) || other.lawName == lawName)&&(identical(other.articleNo, articleNo) || other.articleNo == articleNo)&&(identical(other.title, title) || other.title == title)&&(identical(other.docType, docType) || other.docType == docType)&&(identical(other.content, content) || other.content == content)&&(identical(other.effectiveDate, effectiveDate) || other.effectiveDate == effectiveDate)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lawName,articleNo,title,docType,content,effectiveDate,sourceUrl);

@override
String toString() {
  return 'LawArticle(lawName: $lawName, articleNo: $articleNo, title: $title, docType: $docType, content: $content, effectiveDate: $effectiveDate, sourceUrl: $sourceUrl)';
}


}

/// @nodoc
abstract mixin class _$LawArticleCopyWith<$Res> implements $LawArticleCopyWith<$Res> {
  factory _$LawArticleCopyWith(_LawArticle value, $Res Function(_LawArticle) _then) = __$LawArticleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'law_name') String lawName,@JsonKey(name: 'article_no') String articleNo, String? title,@JsonKey(name: 'doc_type') String docType, String content,@JsonKey(name: 'effective_date') String? effectiveDate,@JsonKey(name: 'source_url') String? sourceUrl
});




}
/// @nodoc
class __$LawArticleCopyWithImpl<$Res>
    implements _$LawArticleCopyWith<$Res> {
  __$LawArticleCopyWithImpl(this._self, this._then);

  final _LawArticle _self;
  final $Res Function(_LawArticle) _then;

/// Create a copy of LawArticle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lawName = null,Object? articleNo = null,Object? title = freezed,Object? docType = null,Object? content = null,Object? effectiveDate = freezed,Object? sourceUrl = freezed,}) {
  return _then(_LawArticle(
lawName: null == lawName ? _self.lawName : lawName // ignore: cast_nullable_to_non_nullable
as String,articleNo: null == articleNo ? _self.articleNo : articleNo // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,docType: null == docType ? _self.docType : docType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,effectiveDate: freezed == effectiveDate ? _self.effectiveDate : effectiveDate // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
