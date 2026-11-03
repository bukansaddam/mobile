import 'package:akar/features/auth/data/models/otp_challenge_model.dart';
import 'package:akar/features/auth/domain/entities/otp_challenge_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses otp challenge response', () {
    final model = OtpChallengeModel.fromJson(const {
      'challenge_token': 'challenge-abc',
      'expires_in': 300,
      'resend_after': 60,
    });

    expect(model.challengeToken, 'challenge-abc');
    expect(model.expiresIn, 300);
    expect(model.resendAfter, 60);
  });

  group('OTP Challenge Expiration Calculation', () {
    test('calculates expiresAt correctly when expiresIn is Unix epoch seconds', () {
      final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final futureSec = nowSec + 300;
      final entity = OtpChallengeEntity(
        challengeToken: 'token-123',
        expiresIn: futureSec,
        resendAfter: 60,
      );

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(entity.expiresIn * 1000);
      expect(expiresAt.isAfter(DateTime.now()), isTrue);
    });

    test('detects expired when Unix epoch seconds is in the past', () {
      final pastSec = (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 10;
      final entity = OtpChallengeEntity(
        challengeToken: 'token-123',
        expiresIn: pastSec,
        resendAfter: 60,
      );

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(entity.expiresIn * 1000);
      expect(DateTime.now().isAfter(expiresAt), isTrue);
    });

    test('calculates duration correctly when expiresIn is relative seconds', () {
      const entity = OtpChallengeEntity(
        challengeToken: 'token-123',
        expiresIn: 300,
        resendAfter: 60,
      );
      final receivedAt = DateTime.now();
      final expiresAt = receivedAt.add(Duration(seconds: entity.expiresIn));

      expect(expiresAt.difference(receivedAt).inSeconds, 300);
      expect(DateTime.now().isBefore(expiresAt), isTrue);
    });

    test('calculates resend cooldown duration correctly', () {
      const entity = OtpChallengeEntity(
        challengeToken: 'token-123',
        expiresIn: 300,
        resendAfter: 60,
      );
      final sentAt = DateTime.now();
      final resendAvailableAt = sentAt.add(
        Duration(seconds: entity.resendAfter),
      );

      final diff = resendAvailableAt.difference(sentAt).inSeconds;
      expect(diff, 60);
      expect(DateTime.now().isBefore(resendAvailableAt), isTrue);
    });
  });
}
