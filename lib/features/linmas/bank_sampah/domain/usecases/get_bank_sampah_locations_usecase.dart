import 'package:akar/core/errors/failures.dart';
import '../entities/bank_sampah_location_entity.dart';
import '../repositories/bank_sampah_repository.dart';

class GetBankSampahLocationsUsecase {
  final BankSampahRepository repository;

  GetBankSampahLocationsUsecase(this.repository);

  Future<Either<Failure, List<BankSampahLocationEntity>>> call() {
    return repository.getLocations();
  }
}
