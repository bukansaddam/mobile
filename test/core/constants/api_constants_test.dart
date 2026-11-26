import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/constants/api_constants.dart';

void main() {
  group('ApiConstants Security & Decryption Tests', () {
    test('baseUrl decodes accurately', () {
      expect(ApiConstants.baseUrl, 'https://akaraslinmas.id');
    });

    test('auth endpoints decode accurately', () {
      expect(ApiConstants.loginMember, '/api/login/member');
      expect(ApiConstants.loginOfficer, '/api/login/officer');
      expect(ApiConstants.refreshToken, '/api/auth/refresh');
      expect(ApiConstants.register, '/api/register');
      expect(ApiConstants.registerPublic, '/api/register/public');
      expect(ApiConstants.registerOtpSend, '/api/register/public/otp/send');
      expect(ApiConstants.me, '/api/auth/me');
    });

    test('ocr endpoint decodes accurately', () {
      expect(ApiConstants.ocrScan, '/api/ocr/scan');
    });

    test('news endpoint decodes accurately', () {
      expect(ApiConstants.news, '/api/news');
    });

    test('surveys endpoint decodes accurately', () {
      expect(ApiConstants.surveys, '/api/surveys');
      expect(ApiConstants.initialQuiz, '/api/initial-quiz');
    });

    test('reports endpoint decodes accurately', () {
      expect(ApiConstants.reports, '/api/reports');
      expect(ApiConstants.incidentReports, '/api/incident-reports');
      expect(ApiConstants.incidentReportsMe, '/api/incident-reports/me');
      expect(ApiConstants.jagaTanahReports, '/api/jaga-tanah-reports');
      expect(ApiConstants.jagaTanahReportsMe, '/api/jaga-tanah-reports/me');
      expect(
        ApiConstants.jagaTanahReportDetail(89),
        '/api/jaga-tanah-reports/89',
      );
      expect(ApiConstants.reportsMe, '/api/reports/me');
      expect(ApiConstants.reportDetail(1256), '/api/reports/1256');
    });

    test('activation runs endpoint decodes accurately', () {
      expect(ApiConstants.activationRuns, '/api/activations/runs');
      expect(
        ApiConstants.participantSubmissions(123),
        '/api/activations/participants/123/submissions',
      );
    });

    test('tracking endpoint decodes accurately', () {
      expect(ApiConstants.position, '/api/positions/me');
      expect(ApiConstants.tracking, '/api/positions/me');
    });

    test('organizations endpoint decodes accurately', () {
      expect(ApiConstants.figureOrganizations, '/api/figure/organizations');
    });

    test('institutions endpoint decodes accurately', () {
      expect(ApiConstants.figureInstitutions, '/api/figure/institutions');
    });

    test('categories endpoint decodes accurately', () {
      expect(ApiConstants.categories, '/api/categories');
    });

    test('baseline regions endpoints decode accurately', () {
      expect(ApiConstants.baselineRegions, '/api/baseline/regions');
      expect(
        ApiConstants.baselineRegionVillages,
        '/api/baseline/regions/villages',
      );
    });

    test('emergency endpoint decodes accurately', () {
      expect(ApiConstants.emergencyStatus, '/api/emergency/status');
      expect(ApiConstants.emergencyStatusMe, '/api/emergency/status');
      expect(ApiConstants.villageMembersNearby, '/api/village-members/nearby');
    });

    test('speech proxy endpoint decodes accurately', () {
      expect(ApiConstants.speechTranscribe, '/api/speech/transcribe');
    });

    test('notification endpoints decode accurately', () {
      expect(ApiConstants.notifications, '/api/notifications');
      expect(ApiConstants.notificationsCount, '/api/notifications/count');
      expect(ApiConstants.notificationsReadAll, '/api/notifications/read-all');
      expect(
        ApiConstants.notificationRead('abc-123'),
        '/api/notifications/abc-123/read',
      );
    });

    test('voucher endpoints decode accurately', () {
      expect(ApiConstants.vouchersMe, '/api/vouchers/me');
      expect(ApiConstants.vouchersRedeem, '/api/vouchers/redeem');
    });
  });
}
