import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/repositories/bank_sampah_repository.dart';

class GetBankSampahLocationsUsecase {
  final BankSampahRepository repository;

  GetBankSampahLocationsUsecase(this.repository);

  Future<Either<Failure, List<BankSampahLocationEntity>>> call() {
    return repository.getLocations();
  }
}
