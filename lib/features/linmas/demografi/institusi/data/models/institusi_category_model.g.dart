// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institusi_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstitusiCategoryModel _$InstitusiCategoryModelFromJson(
  Map<String, dynamic> json,
) => _InstitusiCategoryModel(
  id: (_readId(json, 'id') as num?)?.toInt(),
  label: _readLabel(json, 'label') as String,
  code: json['code'] as String?,
  isActive: _readIsActive(json, 'is_active') as bool? ?? true,
  domain: json['domain'] as String?,
  color: json['color'] as String?,
);

Map<String, dynamic> _$InstitusiCategoryModelToJson(
  _InstitusiCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'code': instance.code,
  'is_active': instance.isActive,
  'domain': instance.domain,
  'color': instance.color,
};
