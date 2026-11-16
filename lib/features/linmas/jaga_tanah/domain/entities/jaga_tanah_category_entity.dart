import 'package:equatable/equatable.dart';

class JagaTanahCategoryEntity extends Equatable {
  final int id;
  final String code;
  final String label;
  final int? parentId;
  final String colorHex;
  final int sortOrder;
  final List<JagaTanahCategoryEntity> children;

  const JagaTanahCategoryEntity({
    required this.id,
    required this.code,
    required this.label,
    this.parentId,
    this.colorHex = '',
    this.sortOrder = 0,
    this.children = const [],
  });

  bool get hasSubCategories => children.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    code,
    label,
    parentId,
    colorHex,
    sortOrder,
    children,
  ];
}
