import 'package:equatable/equatable.dart';

class InstitusiCategoryEntity extends Equatable {
  final int? id;
  final String label;
  final String? code;
  final bool isActive;
  final String? domain;
  final String? color;

  const InstitusiCategoryEntity({
    this.id,
    required this.label,
    this.code,
    this.isActive = true,
    this.domain,
    this.color,
  });

  @override
  List<Object?> get props => [id, label, code, isActive, domain, color];
}
