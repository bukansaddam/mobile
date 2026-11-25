import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';

class GetJagaTanahRegionsUsecase {
  final JagaTanahRepository _repository;

  const GetJagaTanahRegionsUsecase(this._repository);

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getProvinces({
    bool forceRefresh = false,
  }) {
    return _repository.getProvinces(forceRefresh: forceRefresh);
  }

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getRegencies(
    String provinceId, {
    bool forceRefresh = false,
  }) {
    return _repository.getRegencies(provinceId, forceRefresh: forceRefresh);
  }

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getDistricts(
    String regencyId, {
    bool forceRefresh = false,
  }) {
    return _repository.getDistricts(regencyId, forceRefresh: forceRefresh);
  }

  Future<Either<Failure, List<JagaTanahRegionEntity>>> getVillages(
    String districtId, {
    bool forceRefresh = false,
  }) {
    return _repository.getVillages(districtId, forceRefresh: forceRefresh);
  }
}
