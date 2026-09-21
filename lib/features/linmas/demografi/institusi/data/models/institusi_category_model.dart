import '../../domain/entities/institusi_category_entity.dart';

class InstitusiCategoryModel extends InstitusiCategoryEntity {
  const InstitusiCategoryModel({
    super.id,
    required super.label,
    super.code,
    super.isActive = true,
    super.domain,
    super.color,
  });

  factory InstitusiCategoryModel.fromJson(Map<String, dynamic> json) {
    return InstitusiCategoryModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      label: (json['label'] ?? json['name'] ?? json['title'] ?? '').toString(),
      code: json['code']?.toString(),
      isActive: json['is_active'] is bool ? json['is_active'] as bool : true,
      domain: json['domain']?.toString(),
      color: json['color']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'label': label,
    if (code != null) 'code': code,
    'is_active': isActive,
    if (domain != null) 'domain': domain,
    if (color != null) 'color': color,
  };
}
