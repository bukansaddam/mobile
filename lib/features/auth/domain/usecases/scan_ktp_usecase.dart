import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/ktp_ocr_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';

class ScanKtpUsecase {
  final AuthRepository repository;

  const ScanKtpUsecase(this.repository);

  Future<Either<Failure, KtpOcrEntity>> call(File file) {
    return repository.scanKtp(file);
  }
}
