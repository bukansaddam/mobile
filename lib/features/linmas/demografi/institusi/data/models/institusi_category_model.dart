import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/institusi_category_entity.dart';

part 'institusi_category_model.freezed.dart';
part 'institusi_category_model.g.dart';

Object? _readId(Map json, String key) {
  final val = json['id'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val);
  return null;
}

Object? _readLabel(Map json, String key) =>
    (json['label'] ?? json['name'] ?? json['title'] ?? '').toString();

Object? _readIsActive(Map json, String key) {
  final val = json['is_active'] ?? json['isActive'];
  if (val is bool) return val;
  if (val is int) return val == 1;
  if (val is String) return val.toLowerCase() == 'true' || val == '1';
  return true;
}

@freezed
abstract class InstitusiCategoryModel with _$InstitusiCategoryModel {
  const InstitusiCategoryModel._();

  const factory InstitusiCategoryModel({
    @JsonKey(name: 'id', readValue: _readId) int? id,
    @JsonKey(name: 'label', readValue: _readLabel) required String label,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'is_active', readValue: _readIsActive)
    @Default(true)
    bool isActive,
    @JsonKey(name: 'domain') String? domain,
    @JsonKey(name: 'color') String? color,
  }) = _InstitusiCategoryModel;

  factory InstitusiCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$InstitusiCategoryModelFromJson(json);

  factory InstitusiCategoryModel.fromEntity(InstitusiCategoryEntity entity) =>
      InstitusiCategoryModel(
        id: entity.id,
        label: entity.label,
        code: entity.code,
        isActive: entity.isActive,
        domain: entity.domain,
        color: entity.color,
      );

  InstitusiCategoryEntity toDomain() => InstitusiCategoryEntity(
    id: id,
    label: label,
    code: code,
    isActive: isActive,
    domain: domain,
    color: color,
  );
}
