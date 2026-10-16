import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/services/google_speech_service.dart';

void main() {
  group('GoogleSpeechAuthData Token Caching & Validation', () {
    test('isValid returns true when token has ample time (> 5 minutes) before expiry', () {
      final now = DateTime.now();
      final authData = GoogleSpeechAuthData(
        token: 'valid_test_token',
        projectId: 'akar-504702',
        expiry: now.add(const Duration(minutes: 50)),
      );

      expect(authData.isValid, isTrue);
      expect(authData.token, equals('valid_test_token'));
      expect(authData.projectId, equals('akar-504702'));
    });

    test('isValid returns false when token expires within 5 minutes safety buffer', () {
      final now = DateTime.now();
      final authData = GoogleSpeechAuthData(
        token: 'near_expiry_token',
        projectId: 'akar-504702',
        expiry: now.add(const Duration(minutes: 4, seconds: 30)),
      );

      expect(authData.isValid, isFalse);
    });

    test('isValid returns false when token is already expired', () {
      final now = DateTime.now();
      final authData = GoogleSpeechAuthData(
        token: 'expired_token',
        projectId: 'akar-504702',
        expiry: now.subtract(const Duration(seconds: 10)),
      );

      expect(authData.isValid, isFalse);
    });
  });
}
