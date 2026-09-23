import 'package:freezed_annotation/freezed_annotation.dart';

part 'institusi_category_entity.freezed.dart';

@freezed
abstract class InstitusiCategoryEntity with _$InstitusiCategoryEntity {
  const factory InstitusiCategoryEntity({
    int? id,
    required String label,
    String? code,
    @Default(true) bool isActive,
    String? domain,
    String? color,
  }) = _InstitusiCategoryEntity;
}
