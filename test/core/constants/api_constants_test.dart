import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/constants/api_constants.dart';

void main() {
  group('ApiConstants Security & Decryption Tests', () {
    test('baseUrl decodes accurately', () {
      expect(ApiConstants.baseUrl, 'https://akaraslinmas.id');
    });

    test('auth endpoints decode accurately', () {
      expect(ApiConstants.login, '/api/login');
      expect(ApiConstants.register, '/api/register');
    });

    test('news endpoint decodes accurately', () {
      expect(ApiConstants.news, '/api/news');
    });

    test('surveys endpoint decodes accurately', () {
      expect(ApiConstants.surveys, '/api/surveys');
    });

    test('activation runs endpoint decodes accurately', () {
      expect(ApiConstants.activationRuns, '/api/activations/runs');
      expect(
        ApiConstants.participantSubmissions(123),
        '/api/activations/participants/123/submissions',
      );
      expect(
        ApiConstants.runSubmissions(123),
        '/api/activations/runs/123/submissions',
      );
    });

    test('tracking endpoint decodes accurately', () {
      expect(ApiConstants.position, '/api/positions/me');
      expect(ApiConstants.tracking, '/api/positions/me');
    });

    test('google speech constants decode accurately', () {
      expect(ApiConstants.googleCloudScopes, [
        'https://www.googleapis.com/auth/cloud-platform',
      ]);
      expect(
        ApiConstants.googleSpeechRecognizeUrl('demo-project'),
        'https://asia-southeast1-speech.googleapis.com/v2/projects/demo-project/locations/asia-southeast1/recognizers/_:recognize',
      );
    });
  });
}
