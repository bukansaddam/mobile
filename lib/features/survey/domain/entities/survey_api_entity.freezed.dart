// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey_api_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SurveyConditionalFieldEntity {

 int get id; String? get label; String? get type; String? get value; List<String> get options;
/// Create a copy of SurveyConditionalFieldEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyConditionalFieldEntityCopyWith<SurveyConditionalFieldEntity> get copyWith => _$SurveyConditionalFieldEntityCopyWithImpl<SurveyConditionalFieldEntity>(this as SurveyConditionalFieldEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyConditionalFieldEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.options, options));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,type,value,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'SurveyConditionalFieldEntity(id: $id, label: $label, type: $type, value: $value, options: $options)';
}


}

/// @nodoc
abstract mixin class $SurveyConditionalFieldEntityCopyWith<$Res>  {
  factory $SurveyConditionalFieldEntityCopyWith(SurveyConditionalFieldEntity value, $Res Function(SurveyConditionalFieldEntity) _then) = _$SurveyConditionalFieldEntityCopyWithImpl;
@useResult
$Res call({
 int id, String? label, String? type, String? value, List<String> options
});




}
/// @nodoc
class _$SurveyConditionalFieldEntityCopyWithImpl<$Res>
    implements $SurveyConditionalFieldEntityCopyWith<$Res> {
  _$SurveyConditionalFieldEntityCopyWithImpl(this._self, this._then);

  final SurveyConditionalFieldEntity _self;
  final $Res Function(SurveyConditionalFieldEntity) _then;

/// Create a copy of SurveyConditionalFieldEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = freezed,Object? type = freezed,Object? value = freezed,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyConditionalFieldEntity].
extension SurveyConditionalFieldEntityPatterns on SurveyConditionalFieldEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyConditionalFieldEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyConditionalFieldEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyConditionalFieldEntity value)  $default,){
final _that = this;
switch (_that) {
case _SurveyConditionalFieldEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyConditionalFieldEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyConditionalFieldEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? label,  String? type,  String? value,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyConditionalFieldEntity() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.value,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? label,  String? type,  String? value,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _SurveyConditionalFieldEntity():
return $default(_that.id,_that.label,_that.type,_that.value,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? label,  String? type,  String? value,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _SurveyConditionalFieldEntity() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.value,_that.options);case _:
  return null;

}
}

}

/// @nodoc


class _SurveyConditionalFieldEntity extends SurveyConditionalFieldEntity {
  const _SurveyConditionalFieldEntity({required this.id, this.label, this.type, this.value, final  List<String> options = const []}): _options = options,super._();
  

@override final  int id;
@override final  String? label;
@override final  String? type;
@override final  String? value;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of SurveyConditionalFieldEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyConditionalFieldEntityCopyWith<_SurveyConditionalFieldEntity> get copyWith => __$SurveyConditionalFieldEntityCopyWithImpl<_SurveyConditionalFieldEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyConditionalFieldEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other._options, _options));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,type,value,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'SurveyConditionalFieldEntity(id: $id, label: $label, type: $type, value: $value, options: $options)';
}


}

/// @nodoc
abstract mixin class _$SurveyConditionalFieldEntityCopyWith<$Res> implements $SurveyConditionalFieldEntityCopyWith<$Res> {
  factory _$SurveyConditionalFieldEntityCopyWith(_SurveyConditionalFieldEntity value, $Res Function(_SurveyConditionalFieldEntity) _then) = __$SurveyConditionalFieldEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String? label, String? type, String? value, List<String> options
});




}
/// @nodoc
class __$SurveyConditionalFieldEntityCopyWithImpl<$Res>
    implements _$SurveyConditionalFieldEntityCopyWith<$Res> {
  __$SurveyConditionalFieldEntityCopyWithImpl(this._self, this._then);

  final _SurveyConditionalFieldEntity _self;
  final $Res Function(_SurveyConditionalFieldEntity) _then;

/// Create a copy of SurveyConditionalFieldEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = freezed,Object? type = freezed,Object? value = freezed,Object? options = null,}) {
  return _then(_SurveyConditionalFieldEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$SurveyQuestionEntity {

 int get id; String get text; String get type; List<String> get options; String? get showFieldsWhen; List<SurveyConditionalFieldEntity> get conditionalFields;
/// Create a copy of SurveyQuestionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyQuestionEntityCopyWith<SurveyQuestionEntity> get copyWith => _$SurveyQuestionEntityCopyWithImpl<SurveyQuestionEntity>(this as SurveyQuestionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyQuestionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.showFieldsWhen, showFieldsWhen) || other.showFieldsWhen == showFieldsWhen)&&const DeepCollectionEquality().equals(other.conditionalFields, conditionalFields));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,type,const DeepCollectionEquality().hash(options),showFieldsWhen,const DeepCollectionEquality().hash(conditionalFields));

@override
String toString() {
  return 'SurveyQuestionEntity(id: $id, text: $text, type: $type, options: $options, showFieldsWhen: $showFieldsWhen, conditionalFields: $conditionalFields)';
}


}

/// @nodoc
abstract mixin class $SurveyQuestionEntityCopyWith<$Res>  {
  factory $SurveyQuestionEntityCopyWith(SurveyQuestionEntity value, $Res Function(SurveyQuestionEntity) _then) = _$SurveyQuestionEntityCopyWithImpl;
@useResult
$Res call({
 int id, String text, String type, List<String> options, String? showFieldsWhen, List<SurveyConditionalFieldEntity> conditionalFields
});




}
/// @nodoc
class _$SurveyQuestionEntityCopyWithImpl<$Res>
    implements $SurveyQuestionEntityCopyWith<$Res> {
  _$SurveyQuestionEntityCopyWithImpl(this._self, this._then);

  final SurveyQuestionEntity _self;
  final $Res Function(SurveyQuestionEntity) _then;

/// Create a copy of SurveyQuestionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? type = null,Object? options = null,Object? showFieldsWhen = freezed,Object? conditionalFields = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,showFieldsWhen: freezed == showFieldsWhen ? _self.showFieldsWhen : showFieldsWhen // ignore: cast_nullable_to_non_nullable
as String?,conditionalFields: null == conditionalFields ? _self.conditionalFields : conditionalFields // ignore: cast_nullable_to_non_nullable
as List<SurveyConditionalFieldEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyQuestionEntity].
extension SurveyQuestionEntityPatterns on SurveyQuestionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyQuestionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyQuestionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyQuestionEntity value)  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyQuestionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String text,  String type,  List<String> options,  String? showFieldsWhen,  List<SurveyConditionalFieldEntity> conditionalFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyQuestionEntity() when $default != null:
return $default(_that.id,_that.text,_that.type,_that.options,_that.showFieldsWhen,_that.conditionalFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String text,  String type,  List<String> options,  String? showFieldsWhen,  List<SurveyConditionalFieldEntity> conditionalFields)  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionEntity():
return $default(_that.id,_that.text,_that.type,_that.options,_that.showFieldsWhen,_that.conditionalFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String text,  String type,  List<String> options,  String? showFieldsWhen,  List<SurveyConditionalFieldEntity> conditionalFields)?  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionEntity() when $default != null:
return $default(_that.id,_that.text,_that.type,_that.options,_that.showFieldsWhen,_that.conditionalFields);case _:
  return null;

}
}

}

/// @nodoc


class _SurveyQuestionEntity extends SurveyQuestionEntity {
  const _SurveyQuestionEntity({required this.id, required this.text, required this.type, final  List<String> options = const [], this.showFieldsWhen, final  List<SurveyConditionalFieldEntity> conditionalFields = const []}): _options = options,_conditionalFields = conditionalFields,super._();
  

@override final  int id;
@override final  String text;
@override final  String type;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  String? showFieldsWhen;
 final  List<SurveyConditionalFieldEntity> _conditionalFields;
@override@JsonKey() List<SurveyConditionalFieldEntity> get conditionalFields {
  if (_conditionalFields is EqualUnmodifiableListView) return _conditionalFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditionalFields);
}


/// Create a copy of SurveyQuestionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyQuestionEntityCopyWith<_SurveyQuestionEntity> get copyWith => __$SurveyQuestionEntityCopyWithImpl<_SurveyQuestionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyQuestionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.showFieldsWhen, showFieldsWhen) || other.showFieldsWhen == showFieldsWhen)&&const DeepCollectionEquality().equals(other._conditionalFields, _conditionalFields));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,type,const DeepCollectionEquality().hash(_options),showFieldsWhen,const DeepCollectionEquality().hash(_conditionalFields));

@override
String toString() {
  return 'SurveyQuestionEntity(id: $id, text: $text, type: $type, options: $options, showFieldsWhen: $showFieldsWhen, conditionalFields: $conditionalFields)';
}


}

/// @nodoc
abstract mixin class _$SurveyQuestionEntityCopyWith<$Res> implements $SurveyQuestionEntityCopyWith<$Res> {
  factory _$SurveyQuestionEntityCopyWith(_SurveyQuestionEntity value, $Res Function(_SurveyQuestionEntity) _then) = __$SurveyQuestionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String text, String type, List<String> options, String? showFieldsWhen, List<SurveyConditionalFieldEntity> conditionalFields
});




}
/// @nodoc
class __$SurveyQuestionEntityCopyWithImpl<$Res>
    implements _$SurveyQuestionEntityCopyWith<$Res> {
  __$SurveyQuestionEntityCopyWithImpl(this._self, this._then);

  final _SurveyQuestionEntity _self;
  final $Res Function(_SurveyQuestionEntity) _then;

/// Create a copy of SurveyQuestionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? type = null,Object? options = null,Object? showFieldsWhen = freezed,Object? conditionalFields = null,}) {
  return _then(_SurveyQuestionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,showFieldsWhen: freezed == showFieldsWhen ? _self.showFieldsWhen : showFieldsWhen // ignore: cast_nullable_to_non_nullable
as String?,conditionalFields: null == conditionalFields ? _self._conditionalFields : conditionalFields // ignore: cast_nullable_to_non_nullable
as List<SurveyConditionalFieldEntity>,
  ));
}


}

/// @nodoc
mixin _$SurveyItemEntity {

 int get id; String get title; String? get description; String? get period; String? get deadline; String? get status; bool get requireAllQuestions; int? get estimatedMinutes; int? get questionsCount; int? get respondentsCount; DateTime? get createdAt; DateTime? get publishedAt; List<SurveyQuestionEntity> get questions;
/// Create a copy of SurveyItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyItemEntityCopyWith<SurveyItemEntity> get copyWith => _$SurveyItemEntityCopyWithImpl<SurveyItemEntity>(this as SurveyItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.period, period) || other.period == period)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.requireAllQuestions, requireAllQuestions) || other.requireAllQuestions == requireAllQuestions)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.questionsCount, questionsCount) || other.questionsCount == questionsCount)&&(identical(other.respondentsCount, respondentsCount) || other.respondentsCount == respondentsCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&const DeepCollectionEquality().equals(other.questions, questions));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,period,deadline,status,requireAllQuestions,estimatedMinutes,questionsCount,respondentsCount,createdAt,publishedAt,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'SurveyItemEntity(id: $id, title: $title, description: $description, period: $period, deadline: $deadline, status: $status, requireAllQuestions: $requireAllQuestions, estimatedMinutes: $estimatedMinutes, questionsCount: $questionsCount, respondentsCount: $respondentsCount, createdAt: $createdAt, publishedAt: $publishedAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $SurveyItemEntityCopyWith<$Res>  {
  factory $SurveyItemEntityCopyWith(SurveyItemEntity value, $Res Function(SurveyItemEntity) _then) = _$SurveyItemEntityCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? description, String? period, String? deadline, String? status, bool requireAllQuestions, int? estimatedMinutes, int? questionsCount, int? respondentsCount, DateTime? createdAt, DateTime? publishedAt, List<SurveyQuestionEntity> questions
});




}
/// @nodoc
class _$SurveyItemEntityCopyWithImpl<$Res>
    implements $SurveyItemEntityCopyWith<$Res> {
  _$SurveyItemEntityCopyWithImpl(this._self, this._then);

  final SurveyItemEntity _self;
  final $Res Function(SurveyItemEntity) _then;

/// Create a copy of SurveyItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? period = freezed,Object? deadline = freezed,Object? status = freezed,Object? requireAllQuestions = null,Object? estimatedMinutes = freezed,Object? questionsCount = freezed,Object? respondentsCount = freezed,Object? createdAt = freezed,Object? publishedAt = freezed,Object? questions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,requireAllQuestions: null == requireAllQuestions ? _self.requireAllQuestions : requireAllQuestions // ignore: cast_nullable_to_non_nullable
as bool,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,questionsCount: freezed == questionsCount ? _self.questionsCount : questionsCount // ignore: cast_nullable_to_non_nullable
as int?,respondentsCount: freezed == respondentsCount ? _self.respondentsCount : respondentsCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyItemEntity].
extension SurveyItemEntityPatterns on SurveyItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _SurveyItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String? period,  String? deadline,  String? status,  bool requireAllQuestions,  int? estimatedMinutes,  int? questionsCount,  int? respondentsCount,  DateTime? createdAt,  DateTime? publishedAt,  List<SurveyQuestionEntity> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyItemEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.period,_that.deadline,_that.status,_that.requireAllQuestions,_that.estimatedMinutes,_that.questionsCount,_that.respondentsCount,_that.createdAt,_that.publishedAt,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? description,  String? period,  String? deadline,  String? status,  bool requireAllQuestions,  int? estimatedMinutes,  int? questionsCount,  int? respondentsCount,  DateTime? createdAt,  DateTime? publishedAt,  List<SurveyQuestionEntity> questions)  $default,) {final _that = this;
switch (_that) {
case _SurveyItemEntity():
return $default(_that.id,_that.title,_that.description,_that.period,_that.deadline,_that.status,_that.requireAllQuestions,_that.estimatedMinutes,_that.questionsCount,_that.respondentsCount,_that.createdAt,_that.publishedAt,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? description,  String? period,  String? deadline,  String? status,  bool requireAllQuestions,  int? estimatedMinutes,  int? questionsCount,  int? respondentsCount,  DateTime? createdAt,  DateTime? publishedAt,  List<SurveyQuestionEntity> questions)?  $default,) {final _that = this;
switch (_that) {
case _SurveyItemEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.period,_that.deadline,_that.status,_that.requireAllQuestions,_that.estimatedMinutes,_that.questionsCount,_that.respondentsCount,_that.createdAt,_that.publishedAt,_that.questions);case _:
  return null;

}
}

}

/// @nodoc


class _SurveyItemEntity extends SurveyItemEntity {
  const _SurveyItemEntity({required this.id, required this.title, this.description, this.period, this.deadline, this.status, this.requireAllQuestions = true, this.estimatedMinutes, this.questionsCount, this.respondentsCount, this.createdAt, this.publishedAt, final  List<SurveyQuestionEntity> questions = const []}): _questions = questions,super._();
  

@override final  int id;
@override final  String title;
@override final  String? description;
@override final  String? period;
@override final  String? deadline;
@override final  String? status;
@override@JsonKey() final  bool requireAllQuestions;
@override final  int? estimatedMinutes;
@override final  int? questionsCount;
@override final  int? respondentsCount;
@override final  DateTime? createdAt;
@override final  DateTime? publishedAt;
 final  List<SurveyQuestionEntity> _questions;
@override@JsonKey() List<SurveyQuestionEntity> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of SurveyItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyItemEntityCopyWith<_SurveyItemEntity> get copyWith => __$SurveyItemEntityCopyWithImpl<_SurveyItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.period, period) || other.period == period)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.requireAllQuestions, requireAllQuestions) || other.requireAllQuestions == requireAllQuestions)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.questionsCount, questionsCount) || other.questionsCount == questionsCount)&&(identical(other.respondentsCount, respondentsCount) || other.respondentsCount == respondentsCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&const DeepCollectionEquality().equals(other._questions, _questions));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,period,deadline,status,requireAllQuestions,estimatedMinutes,questionsCount,respondentsCount,createdAt,publishedAt,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'SurveyItemEntity(id: $id, title: $title, description: $description, period: $period, deadline: $deadline, status: $status, requireAllQuestions: $requireAllQuestions, estimatedMinutes: $estimatedMinutes, questionsCount: $questionsCount, respondentsCount: $respondentsCount, createdAt: $createdAt, publishedAt: $publishedAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$SurveyItemEntityCopyWith<$Res> implements $SurveyItemEntityCopyWith<$Res> {
  factory _$SurveyItemEntityCopyWith(_SurveyItemEntity value, $Res Function(_SurveyItemEntity) _then) = __$SurveyItemEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? description, String? period, String? deadline, String? status, bool requireAllQuestions, int? estimatedMinutes, int? questionsCount, int? respondentsCount, DateTime? createdAt, DateTime? publishedAt, List<SurveyQuestionEntity> questions
});




}
/// @nodoc
class __$SurveyItemEntityCopyWithImpl<$Res>
    implements _$SurveyItemEntityCopyWith<$Res> {
  __$SurveyItemEntityCopyWithImpl(this._self, this._then);

  final _SurveyItemEntity _self;
  final $Res Function(_SurveyItemEntity) _then;

/// Create a copy of SurveyItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? period = freezed,Object? deadline = freezed,Object? status = freezed,Object? requireAllQuestions = null,Object? estimatedMinutes = freezed,Object? questionsCount = freezed,Object? respondentsCount = freezed,Object? createdAt = freezed,Object? publishedAt = freezed,Object? questions = null,}) {
  return _then(_SurveyItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,requireAllQuestions: null == requireAllQuestions ? _self.requireAllQuestions : requireAllQuestions // ignore: cast_nullable_to_non_nullable
as bool,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,questionsCount: freezed == questionsCount ? _self.questionsCount : questionsCount // ignore: cast_nullable_to_non_nullable
as int?,respondentsCount: freezed == respondentsCount ? _self.respondentsCount : respondentsCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionEntity>,
  ));
}


}

/// @nodoc
mixin _$SurveyFieldAnswerEntity {

 int get fieldId; String get value;
/// Create a copy of SurveyFieldAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyFieldAnswerEntityCopyWith<SurveyFieldAnswerEntity> get copyWith => _$SurveyFieldAnswerEntityCopyWithImpl<SurveyFieldAnswerEntity>(this as SurveyFieldAnswerEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyFieldAnswerEntity&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,fieldId,value);

@override
String toString() {
  return 'SurveyFieldAnswerEntity(fieldId: $fieldId, value: $value)';
}


}

/// @nodoc
abstract mixin class $SurveyFieldAnswerEntityCopyWith<$Res>  {
  factory $SurveyFieldAnswerEntityCopyWith(SurveyFieldAnswerEntity value, $Res Function(SurveyFieldAnswerEntity) _then) = _$SurveyFieldAnswerEntityCopyWithImpl;
@useResult
$Res call({
 int fieldId, String value
});




}
/// @nodoc
class _$SurveyFieldAnswerEntityCopyWithImpl<$Res>
    implements $SurveyFieldAnswerEntityCopyWith<$Res> {
  _$SurveyFieldAnswerEntityCopyWithImpl(this._self, this._then);

  final SurveyFieldAnswerEntity _self;
  final $Res Function(SurveyFieldAnswerEntity) _then;

/// Create a copy of SurveyFieldAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldId = null,Object? value = null,}) {
  return _then(_self.copyWith(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyFieldAnswerEntity].
extension SurveyFieldAnswerEntityPatterns on SurveyFieldAnswerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyFieldAnswerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyFieldAnswerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyFieldAnswerEntity value)  $default,){
final _that = this;
switch (_that) {
case _SurveyFieldAnswerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyFieldAnswerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyFieldAnswerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fieldId,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyFieldAnswerEntity() when $default != null:
return $default(_that.fieldId,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fieldId,  String value)  $default,) {final _that = this;
switch (_that) {
case _SurveyFieldAnswerEntity():
return $default(_that.fieldId,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fieldId,  String value)?  $default,) {final _that = this;
switch (_that) {
case _SurveyFieldAnswerEntity() when $default != null:
return $default(_that.fieldId,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _SurveyFieldAnswerEntity extends SurveyFieldAnswerEntity {
  const _SurveyFieldAnswerEntity({required this.fieldId, required this.value}): super._();
  

@override final  int fieldId;
@override final  String value;

/// Create a copy of SurveyFieldAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyFieldAnswerEntityCopyWith<_SurveyFieldAnswerEntity> get copyWith => __$SurveyFieldAnswerEntityCopyWithImpl<_SurveyFieldAnswerEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyFieldAnswerEntity&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,fieldId,value);

@override
String toString() {
  return 'SurveyFieldAnswerEntity(fieldId: $fieldId, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SurveyFieldAnswerEntityCopyWith<$Res> implements $SurveyFieldAnswerEntityCopyWith<$Res> {
  factory _$SurveyFieldAnswerEntityCopyWith(_SurveyFieldAnswerEntity value, $Res Function(_SurveyFieldAnswerEntity) _then) = __$SurveyFieldAnswerEntityCopyWithImpl;
@override @useResult
$Res call({
 int fieldId, String value
});




}
/// @nodoc
class __$SurveyFieldAnswerEntityCopyWithImpl<$Res>
    implements _$SurveyFieldAnswerEntityCopyWith<$Res> {
  __$SurveyFieldAnswerEntityCopyWithImpl(this._self, this._then);

  final _SurveyFieldAnswerEntity _self;
  final $Res Function(_SurveyFieldAnswerEntity) _then;

/// Create a copy of SurveyFieldAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldId = null,Object? value = null,}) {
  return _then(_SurveyFieldAnswerEntity(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SurveyQuestionAnswerEntity {

 int get questionId; String get value; List<SurveyFieldAnswerEntity> get fields;
/// Create a copy of SurveyQuestionAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyQuestionAnswerEntityCopyWith<SurveyQuestionAnswerEntity> get copyWith => _$SurveyQuestionAnswerEntityCopyWithImpl<SurveyQuestionAnswerEntity>(this as SurveyQuestionAnswerEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyQuestionAnswerEntity&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.fields, fields));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,value,const DeepCollectionEquality().hash(fields));

@override
String toString() {
  return 'SurveyQuestionAnswerEntity(questionId: $questionId, value: $value, fields: $fields)';
}


}

/// @nodoc
abstract mixin class $SurveyQuestionAnswerEntityCopyWith<$Res>  {
  factory $SurveyQuestionAnswerEntityCopyWith(SurveyQuestionAnswerEntity value, $Res Function(SurveyQuestionAnswerEntity) _then) = _$SurveyQuestionAnswerEntityCopyWithImpl;
@useResult
$Res call({
 int questionId, String value, List<SurveyFieldAnswerEntity> fields
});




}
/// @nodoc
class _$SurveyQuestionAnswerEntityCopyWithImpl<$Res>
    implements $SurveyQuestionAnswerEntityCopyWith<$Res> {
  _$SurveyQuestionAnswerEntityCopyWithImpl(this._self, this._then);

  final SurveyQuestionAnswerEntity _self;
  final $Res Function(SurveyQuestionAnswerEntity) _then;

/// Create a copy of SurveyQuestionAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? value = null,Object? fields = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<SurveyFieldAnswerEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyQuestionAnswerEntity].
extension SurveyQuestionAnswerEntityPatterns on SurveyQuestionAnswerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyQuestionAnswerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyQuestionAnswerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyQuestionAnswerEntity value)  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionAnswerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyQuestionAnswerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionAnswerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int questionId,  String value,  List<SurveyFieldAnswerEntity> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyQuestionAnswerEntity() when $default != null:
return $default(_that.questionId,_that.value,_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int questionId,  String value,  List<SurveyFieldAnswerEntity> fields)  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionAnswerEntity():
return $default(_that.questionId,_that.value,_that.fields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int questionId,  String value,  List<SurveyFieldAnswerEntity> fields)?  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionAnswerEntity() when $default != null:
return $default(_that.questionId,_that.value,_that.fields);case _:
  return null;

}
}

}

/// @nodoc


class _SurveyQuestionAnswerEntity extends SurveyQuestionAnswerEntity {
  const _SurveyQuestionAnswerEntity({required this.questionId, required this.value, final  List<SurveyFieldAnswerEntity> fields = const []}): _fields = fields,super._();
  

@override final  int questionId;
@override final  String value;
 final  List<SurveyFieldAnswerEntity> _fields;
@override@JsonKey() List<SurveyFieldAnswerEntity> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of SurveyQuestionAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyQuestionAnswerEntityCopyWith<_SurveyQuestionAnswerEntity> get copyWith => __$SurveyQuestionAnswerEntityCopyWithImpl<_SurveyQuestionAnswerEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyQuestionAnswerEntity&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other._fields, _fields));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,value,const DeepCollectionEquality().hash(_fields));

@override
String toString() {
  return 'SurveyQuestionAnswerEntity(questionId: $questionId, value: $value, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$SurveyQuestionAnswerEntityCopyWith<$Res> implements $SurveyQuestionAnswerEntityCopyWith<$Res> {
  factory _$SurveyQuestionAnswerEntityCopyWith(_SurveyQuestionAnswerEntity value, $Res Function(_SurveyQuestionAnswerEntity) _then) = __$SurveyQuestionAnswerEntityCopyWithImpl;
@override @useResult
$Res call({
 int questionId, String value, List<SurveyFieldAnswerEntity> fields
});




}
/// @nodoc
class __$SurveyQuestionAnswerEntityCopyWithImpl<$Res>
    implements _$SurveyQuestionAnswerEntityCopyWith<$Res> {
  __$SurveyQuestionAnswerEntityCopyWithImpl(this._self, this._then);

  final _SurveyQuestionAnswerEntity _self;
  final $Res Function(_SurveyQuestionAnswerEntity) _then;

/// Create a copy of SurveyQuestionAnswerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? value = null,Object? fields = null,}) {
  return _then(_SurveyQuestionAnswerEntity(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<SurveyFieldAnswerEntity>,
  ));
}


}

/// @nodoc
mixin _$SurveySubmitRequestEntity {

 List<SurveyQuestionAnswerEntity> get answers;
/// Create a copy of SurveySubmitRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveySubmitRequestEntityCopyWith<SurveySubmitRequestEntity> get copyWith => _$SurveySubmitRequestEntityCopyWithImpl<SurveySubmitRequestEntity>(this as SurveySubmitRequestEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveySubmitRequestEntity&&const DeepCollectionEquality().equals(other.answers, answers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(answers));

@override
String toString() {
  return 'SurveySubmitRequestEntity(answers: $answers)';
}


}

/// @nodoc
abstract mixin class $SurveySubmitRequestEntityCopyWith<$Res>  {
  factory $SurveySubmitRequestEntityCopyWith(SurveySubmitRequestEntity value, $Res Function(SurveySubmitRequestEntity) _then) = _$SurveySubmitRequestEntityCopyWithImpl;
@useResult
$Res call({
 List<SurveyQuestionAnswerEntity> answers
});




}
/// @nodoc
class _$SurveySubmitRequestEntityCopyWithImpl<$Res>
    implements $SurveySubmitRequestEntityCopyWith<$Res> {
  _$SurveySubmitRequestEntityCopyWithImpl(this._self, this._then);

  final SurveySubmitRequestEntity _self;
  final $Res Function(SurveySubmitRequestEntity) _then;

/// Create a copy of SurveySubmitRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? answers = null,}) {
  return _then(_self.copyWith(
answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionAnswerEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveySubmitRequestEntity].
extension SurveySubmitRequestEntityPatterns on SurveySubmitRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveySubmitRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveySubmitRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveySubmitRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _SurveySubmitRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveySubmitRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SurveySubmitRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SurveyQuestionAnswerEntity> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveySubmitRequestEntity() when $default != null:
return $default(_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SurveyQuestionAnswerEntity> answers)  $default,) {final _that = this;
switch (_that) {
case _SurveySubmitRequestEntity():
return $default(_that.answers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SurveyQuestionAnswerEntity> answers)?  $default,) {final _that = this;
switch (_that) {
case _SurveySubmitRequestEntity() when $default != null:
return $default(_that.answers);case _:
  return null;

}
}

}

/// @nodoc


class _SurveySubmitRequestEntity extends SurveySubmitRequestEntity {
  const _SurveySubmitRequestEntity({final  List<SurveyQuestionAnswerEntity> answers = const []}): _answers = answers,super._();
  

 final  List<SurveyQuestionAnswerEntity> _answers;
@override@JsonKey() List<SurveyQuestionAnswerEntity> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}


/// Create a copy of SurveySubmitRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveySubmitRequestEntityCopyWith<_SurveySubmitRequestEntity> get copyWith => __$SurveySubmitRequestEntityCopyWithImpl<_SurveySubmitRequestEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveySubmitRequestEntity&&const DeepCollectionEquality().equals(other._answers, _answers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_answers));

@override
String toString() {
  return 'SurveySubmitRequestEntity(answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$SurveySubmitRequestEntityCopyWith<$Res> implements $SurveySubmitRequestEntityCopyWith<$Res> {
  factory _$SurveySubmitRequestEntityCopyWith(_SurveySubmitRequestEntity value, $Res Function(_SurveySubmitRequestEntity) _then) = __$SurveySubmitRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 List<SurveyQuestionAnswerEntity> answers
});




}
/// @nodoc
class __$SurveySubmitRequestEntityCopyWithImpl<$Res>
    implements _$SurveySubmitRequestEntityCopyWith<$Res> {
  __$SurveySubmitRequestEntityCopyWithImpl(this._self, this._then);

  final _SurveySubmitRequestEntity _self;
  final $Res Function(_SurveySubmitRequestEntity) _then;

/// Create a copy of SurveySubmitRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? answers = null,}) {
  return _then(_SurveySubmitRequestEntity(
answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionAnswerEntity>,
  ));
}


}

// dart format on
