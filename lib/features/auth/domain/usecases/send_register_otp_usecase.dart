import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/otp_challenge_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';

class SendRegisterOtpUsecase {
  final AuthRepository repository;

  const SendRegisterOtpUsecase(this.repository);

  Future<Either<Failure, OtpChallengeEntity>> call({
    required String phoneNumber,
  }) {
    return repository.sendRegisterOtp(phoneNumber: phoneNumber);
  }
}
