import 'package:akar/features/auth/data/models/otp_challenge_model.dart';
import 'package:akar/features/auth/domain/entities/otp_challenge_entity.dart';

extension OtpChallengeModelMapper on OtpChallengeModel {
  OtpChallengeEntity toDomain() => OtpChallengeEntity(
    challengeToken: challengeToken,
    expiresIn: expiresIn,
    resendAfter: resendAfter,
  );
}
