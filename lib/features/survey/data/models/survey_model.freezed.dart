// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SurveyConditionalFieldModel {

@JsonKey(name: "id") int get id;@JsonKey(name: "label") String? get label;@JsonKey(name: "type") String? get type;@JsonKey(name: "value") String? get value;@JsonKey(name: "options") List<String> get options;
/// Create a copy of SurveyConditionalFieldModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyConditionalFieldModelCopyWith<SurveyConditionalFieldModel> get copyWith => _$SurveyConditionalFieldModelCopyWithImpl<SurveyConditionalFieldModel>(this as SurveyConditionalFieldModel, _$identity);

  /// Serializes this SurveyConditionalFieldModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurveyConditionalFieldModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyConditionalFieldModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.value, _this.value) || other.value == _this.value)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurveyConditionalFieldModel;
  return Object.hash(runtimeType,_this.id,_this.label,_this.type,_this.value,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as SurveyConditionalFieldModel;
  return 'SurveyConditionalFieldModel(id: ${_this.id}, label: ${_this.label}, type: ${_this.type}, value: ${_this.value}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $SurveyConditionalFieldModelCopyWith<$Res>  {
  factory $SurveyConditionalFieldModelCopyWith(SurveyConditionalFieldModel value, $Res Function(SurveyConditionalFieldModel) _then) = _$SurveyConditionalFieldModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "label") String? label,@JsonKey(name: "type") String? type,@JsonKey(name: "value") String? value,@JsonKey(name: "options") List<String> options
});




}
/// @nodoc
class _$SurveyConditionalFieldModelCopyWithImpl<$Res>
    implements $SurveyConditionalFieldModelCopyWith<$Res> {
  _$SurveyConditionalFieldModelCopyWithImpl(this._self, this._then);

  final SurveyConditionalFieldModel _self;
  final $Res Function(SurveyConditionalFieldModel) _then;

/// Create a copy of SurveyConditionalFieldModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = freezed,Object? type = freezed,Object? value = freezed,Object? options = null,}) {
  return _then(SurveyConditionalFieldModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyConditionalFieldModel].
extension SurveyConditionalFieldModelPatterns on SurveyConditionalFieldModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyConditionalFieldModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyConditionalFieldModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyConditionalFieldModel value)  $default,){
final _that = this;
switch (_that) {
case _SurveyConditionalFieldModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyConditionalFieldModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyConditionalFieldModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "label")  String? label, @JsonKey(name: "type")  String? type, @JsonKey(name: "value")  String? value, @JsonKey(name: "options")  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyConditionalFieldModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "label")  String? label, @JsonKey(name: "type")  String? type, @JsonKey(name: "value")  String? value, @JsonKey(name: "options")  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _SurveyConditionalFieldModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "label")  String? label, @JsonKey(name: "type")  String? type, @JsonKey(name: "value")  String? value, @JsonKey(name: "options")  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _SurveyConditionalFieldModel() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.value,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyConditionalFieldModel extends SurveyConditionalFieldModel {
  const _SurveyConditionalFieldModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "label") this.label, @JsonKey(name: "type") this.type, @JsonKey(name: "value") this.value, @JsonKey(name: "options")  List<String> options = const []}): _options = options,super._();
  factory _SurveyConditionalFieldModel.fromJson(Map<String, dynamic> json) => _$SurveyConditionalFieldModelFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "label") final  String? label;
@override@JsonKey(name: "type") final  String? type;
@override@JsonKey(name: "value") final  String? value;
 final  List<String> _options;
@override@JsonKey(name: "options") List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of SurveyConditionalFieldModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyConditionalFieldModelCopyWith<_SurveyConditionalFieldModel> get copyWith => __$SurveyConditionalFieldModelCopyWithImpl<_SurveyConditionalFieldModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyConditionalFieldModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyConditionalFieldModel&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,label,type,value,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'SurveyConditionalFieldModel(id: $id, label: $label, type: $type, value: $value, options: $options)';
}


}

/// @nodoc
abstract mixin class _$SurveyConditionalFieldModelCopyWith<$Res> implements $SurveyConditionalFieldModelCopyWith<$Res> {
  factory _$SurveyConditionalFieldModelCopyWith(_SurveyConditionalFieldModel value, $Res Function(_SurveyConditionalFieldModel) _then) = __$SurveyConditionalFieldModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "label") String? label,@JsonKey(name: "type") String? type,@JsonKey(name: "value") String? value,@JsonKey(name: "options") List<String> options
});




}
/// @nodoc
class __$SurveyConditionalFieldModelCopyWithImpl<$Res>
    implements _$SurveyConditionalFieldModelCopyWith<$Res> {
  __$SurveyConditionalFieldModelCopyWithImpl(this._self, this._then);

  final _SurveyConditionalFieldModel _self;
  final $Res Function(_SurveyConditionalFieldModel) _then;

/// Create a copy of SurveyConditionalFieldModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = freezed,Object? type = freezed,Object? value = freezed,Object? options = null,}) {
  return _then(_SurveyConditionalFieldModel(
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
mixin _$SurveyQuestionModel {

@JsonKey(name: "id") int get id;@JsonKey(name: "text") String get text;@JsonKey(name: "type") String get type;@JsonKey(name: "options") List<String> get options;@JsonKey(name: "showFieldsWhen") String? get showFieldsWhen;@JsonKey(name: "conditionalFields") List<SurveyConditionalFieldModel> get conditionalFields;
/// Create a copy of SurveyQuestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyQuestionModelCopyWith<SurveyQuestionModel> get copyWith => _$SurveyQuestionModelCopyWithImpl<SurveyQuestionModel>(this as SurveyQuestionModel, _$identity);

  /// Serializes this SurveyQuestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurveyQuestionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyQuestionModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.showFieldsWhen, _this.showFieldsWhen) || other.showFieldsWhen == _this.showFieldsWhen)&&const DeepCollectionEquality().equals(other.conditionalFields, _this.conditionalFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurveyQuestionModel;
  return Object.hash(runtimeType,_this.id,_this.text,_this.type,const DeepCollectionEquality().hash(_this.options),_this.showFieldsWhen,const DeepCollectionEquality().hash(_this.conditionalFields));
}

@override
String toString() {
  final _this = this as SurveyQuestionModel;
  return 'SurveyQuestionModel(id: ${_this.id}, text: ${_this.text}, type: ${_this.type}, options: ${_this.options}, showFieldsWhen: ${_this.showFieldsWhen}, conditionalFields: ${_this.conditionalFields})';
}


}

/// @nodoc
abstract mixin class $SurveyQuestionModelCopyWith<$Res>  {
  factory $SurveyQuestionModelCopyWith(SurveyQuestionModel value, $Res Function(SurveyQuestionModel) _then) = _$SurveyQuestionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "text") String text,@JsonKey(name: "type") String type,@JsonKey(name: "options") List<String> options,@JsonKey(name: "showFieldsWhen") String? showFieldsWhen,@JsonKey(name: "conditionalFields") List<SurveyConditionalFieldModel> conditionalFields
});




}
/// @nodoc
class _$SurveyQuestionModelCopyWithImpl<$Res>
    implements $SurveyQuestionModelCopyWith<$Res> {
  _$SurveyQuestionModelCopyWithImpl(this._self, this._then);

  final SurveyQuestionModel _self;
  final $Res Function(SurveyQuestionModel) _then;

/// Create a copy of SurveyQuestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? type = null,Object? options = null,Object? showFieldsWhen = freezed,Object? conditionalFields = null,}) {
  return _then(SurveyQuestionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,showFieldsWhen: freezed == showFieldsWhen ? _self.showFieldsWhen : showFieldsWhen // ignore: cast_nullable_to_non_nullable
as String?,conditionalFields: null == conditionalFields ? _self.conditionalFields : conditionalFields // ignore: cast_nullable_to_non_nullable
as List<SurveyConditionalFieldModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyQuestionModel].
extension SurveyQuestionModelPatterns on SurveyQuestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyQuestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyQuestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyQuestionModel value)  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyQuestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "text")  String text, @JsonKey(name: "type")  String type, @JsonKey(name: "options")  List<String> options, @JsonKey(name: "showFieldsWhen")  String? showFieldsWhen, @JsonKey(name: "conditionalFields")  List<SurveyConditionalFieldModel> conditionalFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyQuestionModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "text")  String text, @JsonKey(name: "type")  String type, @JsonKey(name: "options")  List<String> options, @JsonKey(name: "showFieldsWhen")  String? showFieldsWhen, @JsonKey(name: "conditionalFields")  List<SurveyConditionalFieldModel> conditionalFields)  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "text")  String text, @JsonKey(name: "type")  String type, @JsonKey(name: "options")  List<String> options, @JsonKey(name: "showFieldsWhen")  String? showFieldsWhen, @JsonKey(name: "conditionalFields")  List<SurveyConditionalFieldModel> conditionalFields)?  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionModel() when $default != null:
return $default(_that.id,_that.text,_that.type,_that.options,_that.showFieldsWhen,_that.conditionalFields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyQuestionModel extends SurveyQuestionModel {
  const _SurveyQuestionModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "text") required this.text, @JsonKey(name: "type") required this.type, @JsonKey(name: "options")  List<String> options = const [], @JsonKey(name: "showFieldsWhen") this.showFieldsWhen, @JsonKey(name: "conditionalFields")  List<SurveyConditionalFieldModel> conditionalFields = const []}): _options = options,_conditionalFields = conditionalFields,super._();
  factory _SurveyQuestionModel.fromJson(Map<String, dynamic> json) => _$SurveyQuestionModelFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "text") final  String text;
@override@JsonKey(name: "type") final  String type;
 final  List<String> _options;
@override@JsonKey(name: "options") List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey(name: "showFieldsWhen") final  String? showFieldsWhen;
 final  List<SurveyConditionalFieldModel> _conditionalFields;
@override@JsonKey(name: "conditionalFields") List<SurveyConditionalFieldModel> get conditionalFields {
  if (_conditionalFields is EqualUnmodifiableListView) return _conditionalFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditionalFields);
}


/// Create a copy of SurveyQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyQuestionModelCopyWith<_SurveyQuestionModel> get copyWith => __$SurveyQuestionModelCopyWithImpl<_SurveyQuestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyQuestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyQuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.showFieldsWhen, showFieldsWhen) || other.showFieldsWhen == showFieldsWhen)&&const DeepCollectionEquality().equals(other.conditionalFields, _conditionalFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,text,type,const DeepCollectionEquality().hash(_options),showFieldsWhen,const DeepCollectionEquality().hash(_conditionalFields));
}

@override
String toString() {
    return 'SurveyQuestionModel(id: $id, text: $text, type: $type, options: $options, showFieldsWhen: $showFieldsWhen, conditionalFields: $conditionalFields)';
}


}

/// @nodoc
abstract mixin class _$SurveyQuestionModelCopyWith<$Res> implements $SurveyQuestionModelCopyWith<$Res> {
  factory _$SurveyQuestionModelCopyWith(_SurveyQuestionModel value, $Res Function(_SurveyQuestionModel) _then) = __$SurveyQuestionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "text") String text,@JsonKey(name: "type") String type,@JsonKey(name: "options") List<String> options,@JsonKey(name: "showFieldsWhen") String? showFieldsWhen,@JsonKey(name: "conditionalFields") List<SurveyConditionalFieldModel> conditionalFields
});




}
/// @nodoc
class __$SurveyQuestionModelCopyWithImpl<$Res>
    implements _$SurveyQuestionModelCopyWith<$Res> {
  __$SurveyQuestionModelCopyWithImpl(this._self, this._then);

  final _SurveyQuestionModel _self;
  final $Res Function(_SurveyQuestionModel) _then;

/// Create a copy of SurveyQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? type = null,Object? options = null,Object? showFieldsWhen = freezed,Object? conditionalFields = null,}) {
  return _then(_SurveyQuestionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,showFieldsWhen: freezed == showFieldsWhen ? _self.showFieldsWhen : showFieldsWhen // ignore: cast_nullable_to_non_nullable
as String?,conditionalFields: null == conditionalFields ? _self._conditionalFields : conditionalFields // ignore: cast_nullable_to_non_nullable
as List<SurveyConditionalFieldModel>,
  ));
}


}


/// @nodoc
mixin _$SurveyItemModel {

@JsonKey(name: "id") int get id;@JsonKey(name: "title") String get title;@JsonKey(name: "description") String? get description;@JsonKey(name: "period") String? get period;@JsonKey(name: "deadline") String? get deadline;@JsonKey(name: "status") String? get status;@JsonKey(name: "requireAllQuestions") bool get requireAllQuestions;@JsonKey(name: "estimatedMinutes") int? get estimatedMinutes;@JsonKey(name: "questionsCount") int? get questionsCount;@JsonKey(name: "respondentsCount") int? get respondentsCount;@JsonKey(name: "createdAt") String? get createdAt;@JsonKey(name: "publishedAt") String? get publishedAt;@JsonKey(name: "questions") List<SurveyQuestionModel> get questions;
/// Create a copy of SurveyItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyItemModelCopyWith<SurveyItemModel> get copyWith => _$SurveyItemModelCopyWithImpl<SurveyItemModel>(this as SurveyItemModel, _$identity);

  /// Serializes this SurveyItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurveyItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.requireAllQuestions, _this.requireAllQuestions) || other.requireAllQuestions == _this.requireAllQuestions)&&(identical(other.estimatedMinutes, _this.estimatedMinutes) || other.estimatedMinutes == _this.estimatedMinutes)&&(identical(other.questionsCount, _this.questionsCount) || other.questionsCount == _this.questionsCount)&&(identical(other.respondentsCount, _this.respondentsCount) || other.respondentsCount == _this.respondentsCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&const DeepCollectionEquality().equals(other.questions, _this.questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurveyItemModel;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,_this.period,_this.deadline,_this.status,_this.requireAllQuestions,_this.estimatedMinutes,_this.questionsCount,_this.respondentsCount,_this.createdAt,_this.publishedAt,const DeepCollectionEquality().hash(_this.questions));
}

@override
String toString() {
  final _this = this as SurveyItemModel;
  return 'SurveyItemModel(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, period: ${_this.period}, deadline: ${_this.deadline}, status: ${_this.status}, requireAllQuestions: ${_this.requireAllQuestions}, estimatedMinutes: ${_this.estimatedMinutes}, questionsCount: ${_this.questionsCount}, respondentsCount: ${_this.respondentsCount}, createdAt: ${_this.createdAt}, publishedAt: ${_this.publishedAt}, questions: ${_this.questions})';
}


}

/// @nodoc
abstract mixin class $SurveyItemModelCopyWith<$Res>  {
  factory $SurveyItemModelCopyWith(SurveyItemModel value, $Res Function(SurveyItemModel) _then) = _$SurveyItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "description") String? description,@JsonKey(name: "period") String? period,@JsonKey(name: "deadline") String? deadline,@JsonKey(name: "status") String? status,@JsonKey(name: "requireAllQuestions") bool requireAllQuestions,@JsonKey(name: "estimatedMinutes") int? estimatedMinutes,@JsonKey(name: "questionsCount") int? questionsCount,@JsonKey(name: "respondentsCount") int? respondentsCount,@JsonKey(name: "createdAt") String? createdAt,@JsonKey(name: "publishedAt") String? publishedAt,@JsonKey(name: "questions") List<SurveyQuestionModel> questions
});




}
/// @nodoc
class _$SurveyItemModelCopyWithImpl<$Res>
    implements $SurveyItemModelCopyWith<$Res> {
  _$SurveyItemModelCopyWithImpl(this._self, this._then);

  final SurveyItemModel _self;
  final $Res Function(SurveyItemModel) _then;

/// Create a copy of SurveyItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? period = freezed,Object? deadline = freezed,Object? status = freezed,Object? requireAllQuestions = null,Object? estimatedMinutes = freezed,Object? questionsCount = freezed,Object? respondentsCount = freezed,Object? createdAt = freezed,Object? publishedAt = freezed,Object? questions = null,}) {
  return _then(SurveyItemModel(
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
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyItemModel].
extension SurveyItemModelPatterns on SurveyItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyItemModel value)  $default,){
final _that = this;
switch (_that) {
case _SurveyItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String? description, @JsonKey(name: "period")  String? period, @JsonKey(name: "deadline")  String? deadline, @JsonKey(name: "status")  String? status, @JsonKey(name: "requireAllQuestions")  bool requireAllQuestions, @JsonKey(name: "estimatedMinutes")  int? estimatedMinutes, @JsonKey(name: "questionsCount")  int? questionsCount, @JsonKey(name: "respondentsCount")  int? respondentsCount, @JsonKey(name: "createdAt")  String? createdAt, @JsonKey(name: "publishedAt")  String? publishedAt, @JsonKey(name: "questions")  List<SurveyQuestionModel> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyItemModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String? description, @JsonKey(name: "period")  String? period, @JsonKey(name: "deadline")  String? deadline, @JsonKey(name: "status")  String? status, @JsonKey(name: "requireAllQuestions")  bool requireAllQuestions, @JsonKey(name: "estimatedMinutes")  int? estimatedMinutes, @JsonKey(name: "questionsCount")  int? questionsCount, @JsonKey(name: "respondentsCount")  int? respondentsCount, @JsonKey(name: "createdAt")  String? createdAt, @JsonKey(name: "publishedAt")  String? publishedAt, @JsonKey(name: "questions")  List<SurveyQuestionModel> questions)  $default,) {final _that = this;
switch (_that) {
case _SurveyItemModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String? description, @JsonKey(name: "period")  String? period, @JsonKey(name: "deadline")  String? deadline, @JsonKey(name: "status")  String? status, @JsonKey(name: "requireAllQuestions")  bool requireAllQuestions, @JsonKey(name: "estimatedMinutes")  int? estimatedMinutes, @JsonKey(name: "questionsCount")  int? questionsCount, @JsonKey(name: "respondentsCount")  int? respondentsCount, @JsonKey(name: "createdAt")  String? createdAt, @JsonKey(name: "publishedAt")  String? publishedAt, @JsonKey(name: "questions")  List<SurveyQuestionModel> questions)?  $default,) {final _that = this;
switch (_that) {
case _SurveyItemModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.period,_that.deadline,_that.status,_that.requireAllQuestions,_that.estimatedMinutes,_that.questionsCount,_that.respondentsCount,_that.createdAt,_that.publishedAt,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyItemModel extends SurveyItemModel {
  const _SurveyItemModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "title") required this.title, @JsonKey(name: "description") this.description, @JsonKey(name: "period") this.period, @JsonKey(name: "deadline") this.deadline, @JsonKey(name: "status") this.status, @JsonKey(name: "requireAllQuestions") this.requireAllQuestions = true, @JsonKey(name: "estimatedMinutes") this.estimatedMinutes, @JsonKey(name: "questionsCount") this.questionsCount, @JsonKey(name: "respondentsCount") this.respondentsCount, @JsonKey(name: "createdAt") this.createdAt, @JsonKey(name: "publishedAt") this.publishedAt, @JsonKey(name: "questions")  List<SurveyQuestionModel> questions = const []}): _questions = questions,super._();
  factory _SurveyItemModel.fromJson(Map<String, dynamic> json) => _$SurveyItemModelFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "title") final  String title;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "period") final  String? period;
@override@JsonKey(name: "deadline") final  String? deadline;
@override@JsonKey(name: "status") final  String? status;
@override@JsonKey(name: "requireAllQuestions") final  bool requireAllQuestions;
@override@JsonKey(name: "estimatedMinutes") final  int? estimatedMinutes;
@override@JsonKey(name: "questionsCount") final  int? questionsCount;
@override@JsonKey(name: "respondentsCount") final  int? respondentsCount;
@override@JsonKey(name: "createdAt") final  String? createdAt;
@override@JsonKey(name: "publishedAt") final  String? publishedAt;
 final  List<SurveyQuestionModel> _questions;
@override@JsonKey(name: "questions") List<SurveyQuestionModel> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of SurveyItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyItemModelCopyWith<_SurveyItemModel> get copyWith => __$SurveyItemModelCopyWithImpl<_SurveyItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.period, period) || other.period == period)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.requireAllQuestions, requireAllQuestions) || other.requireAllQuestions == requireAllQuestions)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.questionsCount, questionsCount) || other.questionsCount == questionsCount)&&(identical(other.respondentsCount, respondentsCount) || other.respondentsCount == respondentsCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&const DeepCollectionEquality().equals(other.questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,period,deadline,status,requireAllQuestions,estimatedMinutes,questionsCount,respondentsCount,createdAt,publishedAt,const DeepCollectionEquality().hash(_questions));
}

@override
String toString() {
    return 'SurveyItemModel(id: $id, title: $title, description: $description, period: $period, deadline: $deadline, status: $status, requireAllQuestions: $requireAllQuestions, estimatedMinutes: $estimatedMinutes, questionsCount: $questionsCount, respondentsCount: $respondentsCount, createdAt: $createdAt, publishedAt: $publishedAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$SurveyItemModelCopyWith<$Res> implements $SurveyItemModelCopyWith<$Res> {
  factory _$SurveyItemModelCopyWith(_SurveyItemModel value, $Res Function(_SurveyItemModel) _then) = __$SurveyItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "description") String? description,@JsonKey(name: "period") String? period,@JsonKey(name: "deadline") String? deadline,@JsonKey(name: "status") String? status,@JsonKey(name: "requireAllQuestions") bool requireAllQuestions,@JsonKey(name: "estimatedMinutes") int? estimatedMinutes,@JsonKey(name: "questionsCount") int? questionsCount,@JsonKey(name: "respondentsCount") int? respondentsCount,@JsonKey(name: "createdAt") String? createdAt,@JsonKey(name: "publishedAt") String? publishedAt,@JsonKey(name: "questions") List<SurveyQuestionModel> questions
});




}
/// @nodoc
class __$SurveyItemModelCopyWithImpl<$Res>
    implements _$SurveyItemModelCopyWith<$Res> {
  __$SurveyItemModelCopyWithImpl(this._self, this._then);

  final _SurveyItemModel _self;
  final $Res Function(_SurveyItemModel) _then;

/// Create a copy of SurveyItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? period = freezed,Object? deadline = freezed,Object? status = freezed,Object? requireAllQuestions = null,Object? estimatedMinutes = freezed,Object? questionsCount = freezed,Object? respondentsCount = freezed,Object? createdAt = freezed,Object? publishedAt = freezed,Object? questions = null,}) {
  return _then(_SurveyItemModel(
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
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionModel>,
  ));
}


}


/// @nodoc
mixin _$SurveyListResponseModel {

@JsonKey(name: "success") bool get success;@JsonKey(name: "data") List<SurveyItemModel> get data;@JsonKey(name: "message") String? get message;
/// Create a copy of SurveyListResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyListResponseModelCopyWith<SurveyListResponseModel> get copyWith => _$SurveyListResponseModelCopyWithImpl<SurveyListResponseModel>(this as SurveyListResponseModel, _$identity);

  /// Serializes this SurveyListResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurveyListResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyListResponseModel&&(identical(other.success, _this.success) || other.success == _this.success)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurveyListResponseModel;
  return Object.hash(runtimeType,_this.success,const DeepCollectionEquality().hash(_this.data),_this.message);
}

@override
String toString() {
  final _this = this as SurveyListResponseModel;
  return 'SurveyListResponseModel(success: ${_this.success}, data: ${_this.data}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $SurveyListResponseModelCopyWith<$Res>  {
  factory $SurveyListResponseModelCopyWith(SurveyListResponseModel value, $Res Function(SurveyListResponseModel) _then) = _$SurveyListResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "data") List<SurveyItemModel> data,@JsonKey(name: "message") String? message
});




}
/// @nodoc
class _$SurveyListResponseModelCopyWithImpl<$Res>
    implements $SurveyListResponseModelCopyWith<$Res> {
  _$SurveyListResponseModelCopyWithImpl(this._self, this._then);

  final SurveyListResponseModel _self;
  final $Res Function(SurveyListResponseModel) _then;

/// Create a copy of SurveyListResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(SurveyListResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<SurveyItemModel>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyListResponseModel].
extension SurveyListResponseModelPatterns on SurveyListResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyListResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyListResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyListResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _SurveyListResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyListResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyListResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  List<SurveyItemModel> data, @JsonKey(name: "message")  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyListResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  List<SurveyItemModel> data, @JsonKey(name: "message")  String? message)  $default,) {final _that = this;
switch (_that) {
case _SurveyListResponseModel():
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  List<SurveyItemModel> data, @JsonKey(name: "message")  String? message)?  $default,) {final _that = this;
switch (_that) {
case _SurveyListResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyListResponseModel extends SurveyListResponseModel {
  const _SurveyListResponseModel({@JsonKey(name: "success") this.success = false, @JsonKey(name: "data")  List<SurveyItemModel> data = const [], @JsonKey(name: "message") this.message}): _data = data,super._();
  factory _SurveyListResponseModel.fromJson(Map<String, dynamic> json) => _$SurveyListResponseModelFromJson(json);

@override@JsonKey(name: "success") final  bool success;
 final  List<SurveyItemModel> _data;
@override@JsonKey(name: "data") List<SurveyItemModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: "message") final  String? message;

/// Create a copy of SurveyListResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyListResponseModelCopyWith<_SurveyListResponseModel> get copyWith => __$SurveyListResponseModelCopyWithImpl<_SurveyListResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyListResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyListResponseModel&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),message);
}

@override
String toString() {
    return 'SurveyListResponseModel(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SurveyListResponseModelCopyWith<$Res> implements $SurveyListResponseModelCopyWith<$Res> {
  factory _$SurveyListResponseModelCopyWith(_SurveyListResponseModel value, $Res Function(_SurveyListResponseModel) _then) = __$SurveyListResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "data") List<SurveyItemModel> data,@JsonKey(name: "message") String? message
});




}
/// @nodoc
class __$SurveyListResponseModelCopyWithImpl<$Res>
    implements _$SurveyListResponseModelCopyWith<$Res> {
  __$SurveyListResponseModelCopyWithImpl(this._self, this._then);

  final _SurveyListResponseModel _self;
  final $Res Function(_SurveyListResponseModel) _then;

/// Create a copy of SurveyListResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(_SurveyListResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<SurveyItemModel>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SurveyFieldAnswerModel {

@JsonKey(name: "fieldId") int get fieldId;@JsonKey(name: "value") String get value;
/// Create a copy of SurveyFieldAnswerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyFieldAnswerModelCopyWith<SurveyFieldAnswerModel> get copyWith => _$SurveyFieldAnswerModelCopyWithImpl<SurveyFieldAnswerModel>(this as SurveyFieldAnswerModel, _$identity);

  /// Serializes this SurveyFieldAnswerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurveyFieldAnswerModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyFieldAnswerModel&&(identical(other.fieldId, _this.fieldId) || other.fieldId == _this.fieldId)&&(identical(other.value, _this.value) || other.value == _this.value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurveyFieldAnswerModel;
  return Object.hash(runtimeType,_this.fieldId,_this.value);
}

@override
String toString() {
  final _this = this as SurveyFieldAnswerModel;
  return 'SurveyFieldAnswerModel(fieldId: ${_this.fieldId}, value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $SurveyFieldAnswerModelCopyWith<$Res>  {
  factory $SurveyFieldAnswerModelCopyWith(SurveyFieldAnswerModel value, $Res Function(SurveyFieldAnswerModel) _then) = _$SurveyFieldAnswerModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "fieldId") int fieldId,@JsonKey(name: "value") String value
});




}
/// @nodoc
class _$SurveyFieldAnswerModelCopyWithImpl<$Res>
    implements $SurveyFieldAnswerModelCopyWith<$Res> {
  _$SurveyFieldAnswerModelCopyWithImpl(this._self, this._then);

  final SurveyFieldAnswerModel _self;
  final $Res Function(SurveyFieldAnswerModel) _then;

/// Create a copy of SurveyFieldAnswerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldId = null,Object? value = null,}) {
  return _then(SurveyFieldAnswerModel(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyFieldAnswerModel].
extension SurveyFieldAnswerModelPatterns on SurveyFieldAnswerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyFieldAnswerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyFieldAnswerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyFieldAnswerModel value)  $default,){
final _that = this;
switch (_that) {
case _SurveyFieldAnswerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyFieldAnswerModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyFieldAnswerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "fieldId")  int fieldId, @JsonKey(name: "value")  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyFieldAnswerModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "fieldId")  int fieldId, @JsonKey(name: "value")  String value)  $default,) {final _that = this;
switch (_that) {
case _SurveyFieldAnswerModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "fieldId")  int fieldId, @JsonKey(name: "value")  String value)?  $default,) {final _that = this;
switch (_that) {
case _SurveyFieldAnswerModel() when $default != null:
return $default(_that.fieldId,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyFieldAnswerModel extends SurveyFieldAnswerModel {
  const _SurveyFieldAnswerModel({@JsonKey(name: "fieldId") required this.fieldId, @JsonKey(name: "value") required this.value}): super._();
  factory _SurveyFieldAnswerModel.fromJson(Map<String, dynamic> json) => _$SurveyFieldAnswerModelFromJson(json);

@override@JsonKey(name: "fieldId") final  int fieldId;
@override@JsonKey(name: "value") final  String value;

/// Create a copy of SurveyFieldAnswerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyFieldAnswerModelCopyWith<_SurveyFieldAnswerModel> get copyWith => __$SurveyFieldAnswerModelCopyWithImpl<_SurveyFieldAnswerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyFieldAnswerModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyFieldAnswerModel&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fieldId,value);
}

@override
String toString() {
    return 'SurveyFieldAnswerModel(fieldId: $fieldId, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SurveyFieldAnswerModelCopyWith<$Res> implements $SurveyFieldAnswerModelCopyWith<$Res> {
  factory _$SurveyFieldAnswerModelCopyWith(_SurveyFieldAnswerModel value, $Res Function(_SurveyFieldAnswerModel) _then) = __$SurveyFieldAnswerModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "fieldId") int fieldId,@JsonKey(name: "value") String value
});




}
/// @nodoc
class __$SurveyFieldAnswerModelCopyWithImpl<$Res>
    implements _$SurveyFieldAnswerModelCopyWith<$Res> {
  __$SurveyFieldAnswerModelCopyWithImpl(this._self, this._then);

  final _SurveyFieldAnswerModel _self;
  final $Res Function(_SurveyFieldAnswerModel) _then;

/// Create a copy of SurveyFieldAnswerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldId = null,Object? value = null,}) {
  return _then(_SurveyFieldAnswerModel(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SurveyQuestionAnswerModel {

@JsonKey(name: "questionId") int get questionId;@JsonKey(name: "value") String get value;@JsonKey(name: "fields") List<SurveyFieldAnswerModel> get fields;
/// Create a copy of SurveyQuestionAnswerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyQuestionAnswerModelCopyWith<SurveyQuestionAnswerModel> get copyWith => _$SurveyQuestionAnswerModelCopyWithImpl<SurveyQuestionAnswerModel>(this as SurveyQuestionAnswerModel, _$identity);

  /// Serializes this SurveyQuestionAnswerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurveyQuestionAnswerModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyQuestionAnswerModel&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.value, _this.value) || other.value == _this.value)&&const DeepCollectionEquality().equals(other.fields, _this.fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurveyQuestionAnswerModel;
  return Object.hash(runtimeType,_this.questionId,_this.value,const DeepCollectionEquality().hash(_this.fields));
}

@override
String toString() {
  final _this = this as SurveyQuestionAnswerModel;
  return 'SurveyQuestionAnswerModel(questionId: ${_this.questionId}, value: ${_this.value}, fields: ${_this.fields})';
}


}

/// @nodoc
abstract mixin class $SurveyQuestionAnswerModelCopyWith<$Res>  {
  factory $SurveyQuestionAnswerModelCopyWith(SurveyQuestionAnswerModel value, $Res Function(SurveyQuestionAnswerModel) _then) = _$SurveyQuestionAnswerModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "questionId") int questionId,@JsonKey(name: "value") String value,@JsonKey(name: "fields") List<SurveyFieldAnswerModel> fields
});




}
/// @nodoc
class _$SurveyQuestionAnswerModelCopyWithImpl<$Res>
    implements $SurveyQuestionAnswerModelCopyWith<$Res> {
  _$SurveyQuestionAnswerModelCopyWithImpl(this._self, this._then);

  final SurveyQuestionAnswerModel _self;
  final $Res Function(SurveyQuestionAnswerModel) _then;

/// Create a copy of SurveyQuestionAnswerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? value = null,Object? fields = null,}) {
  return _then(SurveyQuestionAnswerModel(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<SurveyFieldAnswerModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyQuestionAnswerModel].
extension SurveyQuestionAnswerModelPatterns on SurveyQuestionAnswerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyQuestionAnswerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyQuestionAnswerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyQuestionAnswerModel value)  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionAnswerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyQuestionAnswerModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionAnswerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "questionId")  int questionId, @JsonKey(name: "value")  String value, @JsonKey(name: "fields")  List<SurveyFieldAnswerModel> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyQuestionAnswerModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "questionId")  int questionId, @JsonKey(name: "value")  String value, @JsonKey(name: "fields")  List<SurveyFieldAnswerModel> fields)  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionAnswerModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "questionId")  int questionId, @JsonKey(name: "value")  String value, @JsonKey(name: "fields")  List<SurveyFieldAnswerModel> fields)?  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionAnswerModel() when $default != null:
return $default(_that.questionId,_that.value,_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyQuestionAnswerModel extends SurveyQuestionAnswerModel {
  const _SurveyQuestionAnswerModel({@JsonKey(name: "questionId") required this.questionId, @JsonKey(name: "value") required this.value, @JsonKey(name: "fields")  List<SurveyFieldAnswerModel> fields = const []}): _fields = fields,super._();
  factory _SurveyQuestionAnswerModel.fromJson(Map<String, dynamic> json) => _$SurveyQuestionAnswerModelFromJson(json);

@override@JsonKey(name: "questionId") final  int questionId;
@override@JsonKey(name: "value") final  String value;
 final  List<SurveyFieldAnswerModel> _fields;
@override@JsonKey(name: "fields") List<SurveyFieldAnswerModel> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of SurveyQuestionAnswerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyQuestionAnswerModelCopyWith<_SurveyQuestionAnswerModel> get copyWith => __$SurveyQuestionAnswerModelCopyWithImpl<_SurveyQuestionAnswerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyQuestionAnswerModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyQuestionAnswerModel&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,value,const DeepCollectionEquality().hash(_fields));
}

@override
String toString() {
    return 'SurveyQuestionAnswerModel(questionId: $questionId, value: $value, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$SurveyQuestionAnswerModelCopyWith<$Res> implements $SurveyQuestionAnswerModelCopyWith<$Res> {
  factory _$SurveyQuestionAnswerModelCopyWith(_SurveyQuestionAnswerModel value, $Res Function(_SurveyQuestionAnswerModel) _then) = __$SurveyQuestionAnswerModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "questionId") int questionId,@JsonKey(name: "value") String value,@JsonKey(name: "fields") List<SurveyFieldAnswerModel> fields
});




}
/// @nodoc
class __$SurveyQuestionAnswerModelCopyWithImpl<$Res>
    implements _$SurveyQuestionAnswerModelCopyWith<$Res> {
  __$SurveyQuestionAnswerModelCopyWithImpl(this._self, this._then);

  final _SurveyQuestionAnswerModel _self;
  final $Res Function(_SurveyQuestionAnswerModel) _then;

/// Create a copy of SurveyQuestionAnswerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? value = null,Object? fields = null,}) {
  return _then(_SurveyQuestionAnswerModel(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<SurveyFieldAnswerModel>,
  ));
}


}


/// @nodoc
mixin _$SurveySubmitRequestModel {

@JsonKey(name: "answers") List<SurveyQuestionAnswerModel> get answers;
/// Create a copy of SurveySubmitRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveySubmitRequestModelCopyWith<SurveySubmitRequestModel> get copyWith => _$SurveySubmitRequestModelCopyWithImpl<SurveySubmitRequestModel>(this as SurveySubmitRequestModel, _$identity);

  /// Serializes this SurveySubmitRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SurveySubmitRequestModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveySubmitRequestModel&&const DeepCollectionEquality().equals(other.answers, _this.answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SurveySubmitRequestModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.answers));
}

@override
String toString() {
  final _this = this as SurveySubmitRequestModel;
  return 'SurveySubmitRequestModel(answers: ${_this.answers})';
}


}

/// @nodoc
abstract mixin class $SurveySubmitRequestModelCopyWith<$Res>  {
  factory $SurveySubmitRequestModelCopyWith(SurveySubmitRequestModel value, $Res Function(SurveySubmitRequestModel) _then) = _$SurveySubmitRequestModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "answers") List<SurveyQuestionAnswerModel> answers
});




}
/// @nodoc
class _$SurveySubmitRequestModelCopyWithImpl<$Res>
    implements $SurveySubmitRequestModelCopyWith<$Res> {
  _$SurveySubmitRequestModelCopyWithImpl(this._self, this._then);

  final SurveySubmitRequestModel _self;
  final $Res Function(SurveySubmitRequestModel) _then;

/// Create a copy of SurveySubmitRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? answers = null,}) {
  return _then(SurveySubmitRequestModel(
answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionAnswerModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveySubmitRequestModel].
extension SurveySubmitRequestModelPatterns on SurveySubmitRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveySubmitRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveySubmitRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveySubmitRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _SurveySubmitRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveySubmitRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurveySubmitRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "answers")  List<SurveyQuestionAnswerModel> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveySubmitRequestModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "answers")  List<SurveyQuestionAnswerModel> answers)  $default,) {final _that = this;
switch (_that) {
case _SurveySubmitRequestModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "answers")  List<SurveyQuestionAnswerModel> answers)?  $default,) {final _that = this;
switch (_that) {
case _SurveySubmitRequestModel() when $default != null:
return $default(_that.answers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveySubmitRequestModel extends SurveySubmitRequestModel {
  const _SurveySubmitRequestModel({@JsonKey(name: "answers")  List<SurveyQuestionAnswerModel> answers = const []}): _answers = answers,super._();
  factory _SurveySubmitRequestModel.fromJson(Map<String, dynamic> json) => _$SurveySubmitRequestModelFromJson(json);

 final  List<SurveyQuestionAnswerModel> _answers;
@override@JsonKey(name: "answers") List<SurveyQuestionAnswerModel> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}


/// Create a copy of SurveySubmitRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveySubmitRequestModelCopyWith<_SurveySubmitRequestModel> get copyWith => __$SurveySubmitRequestModelCopyWithImpl<_SurveySubmitRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveySubmitRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveySubmitRequestModel&&const DeepCollectionEquality().equals(other.answers, _answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_answers));
}

@override
String toString() {
    return 'SurveySubmitRequestModel(answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$SurveySubmitRequestModelCopyWith<$Res> implements $SurveySubmitRequestModelCopyWith<$Res> {
  factory _$SurveySubmitRequestModelCopyWith(_SurveySubmitRequestModel value, $Res Function(_SurveySubmitRequestModel) _then) = __$SurveySubmitRequestModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "answers") List<SurveyQuestionAnswerModel> answers
});




}
/// @nodoc
class __$SurveySubmitRequestModelCopyWithImpl<$Res>
    implements _$SurveySubmitRequestModelCopyWith<$Res> {
  __$SurveySubmitRequestModelCopyWithImpl(this._self, this._then);

  final _SurveySubmitRequestModel _self;
  final $Res Function(_SurveySubmitRequestModel) _then;

/// Create a copy of SurveySubmitRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? answers = null,}) {
  return _then(_SurveySubmitRequestModel(
answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionAnswerModel>,
  ));
}


}

// dart format on
