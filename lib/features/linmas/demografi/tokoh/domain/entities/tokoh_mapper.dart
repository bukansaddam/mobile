import '../../data/models/tokoh_model.dart';
import 'tokoh_entity.dart';

extension TokohResponseModelX on TokohResponseModel {
  TokohPaginatedEntity toDomain() {
    return TokohPaginatedEntity(
      success: success,
      total: meta?.total ?? data.length,
      currentPage: meta?.currentPage ?? 1,
      lastPage: meta?.lastPage ?? 1,
      perPage: meta?.perPage ?? 10,
      data: data,
      message: message,
    );
  }
}

extension TokohEntityX on TokohEntity {
  TokohModel toModel() => TokohModel.fromEntity(this);
}
