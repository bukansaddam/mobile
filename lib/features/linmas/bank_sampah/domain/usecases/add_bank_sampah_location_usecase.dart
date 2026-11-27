import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/repositories/bank_sampah_repository.dart';

class AddBankSampahLocationUsecase {
  final BankSampahRepository repository;

  AddBankSampahLocationUsecase(this.repository);

  Future<Either<Failure, BankSampahLocationEntity>> call(
    BankSampahLocationEntity location,
  ) {
    return repository.addLocation(location);
  }
}
