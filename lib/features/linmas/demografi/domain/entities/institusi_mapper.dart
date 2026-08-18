import 'package:akar/features/linmas/demografi/data/models/institusi_model.dart';
import 'package:akar/features/linmas/demografi/domain/entities/institusi_entity.dart';

export 'package:akar/features/linmas/demografi/domain/entities/institusi_entity.dart';

extension InstitusiModelMapper on InstitusiModel {
  InstitusiEntity toDomain() {
    return InstitusiEntity(
      id: id,
      nama: nama,
      scope: scope,
      alamat: alamat,
      createdAt: createdAt,
    );
  }
}

extension InstitusiEntityMapper on InstitusiEntity {
  InstitusiModel toModel() {
    return InstitusiModel(
      id: id,
      nama: nama,
      scope: scope,
      alamat: alamat,
      createdAt: createdAt,
    );
  }
}
