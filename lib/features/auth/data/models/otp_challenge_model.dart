class OtpChallengeModel {
  final String challengeToken;
  final int expiresIn;
  final int resendAfter;

  const OtpChallengeModel({
    required this.challengeToken,
    required this.expiresIn,
    required this.resendAfter,
  });

  factory OtpChallengeModel.fromJson(Map<String, dynamic> json) {
    return OtpChallengeModel(
      challengeToken: (json['challenge_token'] ?? '').toString(),
      expiresIn: (json['expires_in'] as num?)?.toInt() ?? 0,
      resendAfter: (json['resend_after'] as num?)?.toInt() ?? 0,
    );
  }
}
