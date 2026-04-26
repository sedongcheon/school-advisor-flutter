// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faq_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FaqIndex {

 int get version; List<FaqCategory> get categories;
/// Create a copy of FaqIndex
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaqIndexCopyWith<FaqIndex> get copyWith => _$FaqIndexCopyWithImpl<FaqIndex>(this as FaqIndex, _$identity);

  /// Serializes this FaqIndex to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaqIndex&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'FaqIndex(version: $version, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $FaqIndexCopyWith<$Res>  {
  factory $FaqIndexCopyWith(FaqIndex value, $Res Function(FaqIndex) _then) = _$FaqIndexCopyWithImpl;
@useResult
$Res call({
 int version, List<FaqCategory> categories
});




}
/// @nodoc
class _$FaqIndexCopyWithImpl<$Res>
    implements $FaqIndexCopyWith<$Res> {
  _$FaqIndexCopyWithImpl(this._self, this._then);

  final FaqIndex _self;
  final $Res Function(FaqIndex) _then;

/// Create a copy of FaqIndex
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? categories = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<FaqCategory>,
  ));
}

}


/// Adds pattern-matching-related methods to [FaqIndex].
extension FaqIndexPatterns on FaqIndex {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaqIndex value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaqIndex() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaqIndex value)  $default,){
final _that = this;
switch (_that) {
case _FaqIndex():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaqIndex value)?  $default,){
final _that = this;
switch (_that) {
case _FaqIndex() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<FaqCategory> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaqIndex() when $default != null:
return $default(_that.version,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<FaqCategory> categories)  $default,) {final _that = this;
switch (_that) {
case _FaqIndex():
return $default(_that.version,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<FaqCategory> categories)?  $default,) {final _that = this;
switch (_that) {
case _FaqIndex() when $default != null:
return $default(_that.version,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FaqIndex implements FaqIndex {
  const _FaqIndex({required this.version, required final  List<FaqCategory> categories}): _categories = categories;
  factory _FaqIndex.fromJson(Map<String, dynamic> json) => _$FaqIndexFromJson(json);

@override final  int version;
 final  List<FaqCategory> _categories;
@override List<FaqCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of FaqIndex
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaqIndexCopyWith<_FaqIndex> get copyWith => __$FaqIndexCopyWithImpl<_FaqIndex>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FaqIndexToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaqIndex&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'FaqIndex(version: $version, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$FaqIndexCopyWith<$Res> implements $FaqIndexCopyWith<$Res> {
  factory _$FaqIndexCopyWith(_FaqIndex value, $Res Function(_FaqIndex) _then) = __$FaqIndexCopyWithImpl;
@override @useResult
$Res call({
 int version, List<FaqCategory> categories
});




}
/// @nodoc
class __$FaqIndexCopyWithImpl<$Res>
    implements _$FaqIndexCopyWith<$Res> {
  __$FaqIndexCopyWithImpl(this._self, this._then);

  final _FaqIndex _self;
  final $Res Function(_FaqIndex) _then;

/// Create a copy of FaqIndex
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? categories = null,}) {
  return _then(_FaqIndex(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<FaqCategory>,
  ));
}


}


/// @nodoc
mixin _$FaqCategory {

 String get id; String get label; List<FaqItem> get items;
/// Create a copy of FaqCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaqCategoryCopyWith<FaqCategory> get copyWith => _$FaqCategoryCopyWithImpl<FaqCategory>(this as FaqCategory, _$identity);

  /// Serializes this FaqCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaqCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'FaqCategory(id: $id, label: $label, items: $items)';
}


}

/// @nodoc
abstract mixin class $FaqCategoryCopyWith<$Res>  {
  factory $FaqCategoryCopyWith(FaqCategory value, $Res Function(FaqCategory) _then) = _$FaqCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String label, List<FaqItem> items
});




}
/// @nodoc
class _$FaqCategoryCopyWithImpl<$Res>
    implements $FaqCategoryCopyWith<$Res> {
  _$FaqCategoryCopyWithImpl(this._self, this._then);

  final FaqCategory _self;
  final $Res Function(FaqCategory) _then;

/// Create a copy of FaqCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FaqItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [FaqCategory].
extension FaqCategoryPatterns on FaqCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaqCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaqCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaqCategory value)  $default,){
final _that = this;
switch (_that) {
case _FaqCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaqCategory value)?  $default,){
final _that = this;
switch (_that) {
case _FaqCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  List<FaqItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaqCategory() when $default != null:
return $default(_that.id,_that.label,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  List<FaqItem> items)  $default,) {final _that = this;
switch (_that) {
case _FaqCategory():
return $default(_that.id,_that.label,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  List<FaqItem> items)?  $default,) {final _that = this;
switch (_that) {
case _FaqCategory() when $default != null:
return $default(_that.id,_that.label,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FaqCategory implements FaqCategory {
  const _FaqCategory({required this.id, required this.label, required final  List<FaqItem> items}): _items = items;
  factory _FaqCategory.fromJson(Map<String, dynamic> json) => _$FaqCategoryFromJson(json);

@override final  String id;
@override final  String label;
 final  List<FaqItem> _items;
@override List<FaqItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of FaqCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaqCategoryCopyWith<_FaqCategory> get copyWith => __$FaqCategoryCopyWithImpl<_FaqCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FaqCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaqCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'FaqCategory(id: $id, label: $label, items: $items)';
}


}

/// @nodoc
abstract mixin class _$FaqCategoryCopyWith<$Res> implements $FaqCategoryCopyWith<$Res> {
  factory _$FaqCategoryCopyWith(_FaqCategory value, $Res Function(_FaqCategory) _then) = __$FaqCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, List<FaqItem> items
});




}
/// @nodoc
class __$FaqCategoryCopyWithImpl<$Res>
    implements _$FaqCategoryCopyWith<$Res> {
  __$FaqCategoryCopyWithImpl(this._self, this._then);

  final _FaqCategory _self;
  final $Res Function(_FaqCategory) _then;

/// Create a copy of FaqCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? items = null,}) {
  return _then(_FaqCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FaqItem>,
  ));
}


}


/// @nodoc
mixin _$FaqItem {

 String get question;/// 마크다운으로 작성된 사전 답변.
 String get answer;
/// Create a copy of FaqItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaqItemCopyWith<FaqItem> get copyWith => _$FaqItemCopyWithImpl<FaqItem>(this as FaqItem, _$identity);

  /// Serializes this FaqItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaqItem&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,answer);

@override
String toString() {
  return 'FaqItem(question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class $FaqItemCopyWith<$Res>  {
  factory $FaqItemCopyWith(FaqItem value, $Res Function(FaqItem) _then) = _$FaqItemCopyWithImpl;
@useResult
$Res call({
 String question, String answer
});




}
/// @nodoc
class _$FaqItemCopyWithImpl<$Res>
    implements $FaqItemCopyWith<$Res> {
  _$FaqItemCopyWithImpl(this._self, this._then);

  final FaqItem _self;
  final $Res Function(FaqItem) _then;

/// Create a copy of FaqItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? answer = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FaqItem].
extension FaqItemPatterns on FaqItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaqItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaqItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaqItem value)  $default,){
final _that = this;
switch (_that) {
case _FaqItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaqItem value)?  $default,){
final _that = this;
switch (_that) {
case _FaqItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  String answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaqItem() when $default != null:
return $default(_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  String answer)  $default,) {final _that = this;
switch (_that) {
case _FaqItem():
return $default(_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  String answer)?  $default,) {final _that = this;
switch (_that) {
case _FaqItem() when $default != null:
return $default(_that.question,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FaqItem implements FaqItem {
  const _FaqItem({required this.question, required this.answer});
  factory _FaqItem.fromJson(Map<String, dynamic> json) => _$FaqItemFromJson(json);

@override final  String question;
/// 마크다운으로 작성된 사전 답변.
@override final  String answer;

/// Create a copy of FaqItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaqItemCopyWith<_FaqItem> get copyWith => __$FaqItemCopyWithImpl<_FaqItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FaqItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaqItem&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,answer);

@override
String toString() {
  return 'FaqItem(question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$FaqItemCopyWith<$Res> implements $FaqItemCopyWith<$Res> {
  factory _$FaqItemCopyWith(_FaqItem value, $Res Function(_FaqItem) _then) = __$FaqItemCopyWithImpl;
@override @useResult
$Res call({
 String question, String answer
});




}
/// @nodoc
class __$FaqItemCopyWithImpl<$Res>
    implements _$FaqItemCopyWith<$Res> {
  __$FaqItemCopyWithImpl(this._self, this._then);

  final _FaqItem _self;
  final $Res Function(_FaqItem) _then;

/// Create a copy of FaqItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? answer = null,}) {
  return _then(_FaqItem(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
