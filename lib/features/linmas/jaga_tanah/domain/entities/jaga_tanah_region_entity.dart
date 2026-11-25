import 'package:equatable/equatable.dart';

enum JagaTanahRegionLevel { province, regency, district, village }

class JagaTanahRegionEntity extends Equatable {
  final String id;
  final String name;
  final String? code;

  const JagaTanahRegionEntity({
    required this.id,
    required this.name,
    this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}
