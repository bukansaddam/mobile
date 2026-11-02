class OtpChallengeEntity {
  final String challengeToken;
  final int expiresIn;
  final int resendAfter;

  const OtpChallengeEntity({
    required this.challengeToken,
    required this.expiresIn,
    required this.resendAfter,
  });
}
