import 'package:akar/core/errors/failures.dart';
import '../entities/bank_sampah_location_entity.dart';
import '../repositories/bank_sampah_repository.dart';

class AddBankSampahLocationUsecase {
  final BankSampahRepository repository;

  AddBankSampahLocationUsecase(this.repository);

  Future<Either<Failure, BankSampahLocationEntity>> call(
    BankSampahLocationEntity location,
  ) {
    return repository.addLocation(location);
  }
}
