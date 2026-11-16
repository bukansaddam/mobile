import 'package:equatable/equatable.dart';

class ComplaintCategoryOption extends Equatable {
  final int id;
  final String code;
  final String label;

  const ComplaintCategoryOption({
    this.id = 0,
    required this.code,
    required this.label,
  });

  @override
  List<Object?> get props => [id, code, label];
}
