import 'package:akar/features/notifications/data/models/app_notification_count_model.dart';
import 'package:akar/features/notifications/data/models/app_notification_model.dart';
import 'package:akar/features/notifications/data/models/app_notification_page_model.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Notification Models Parsing Tests', () {
    test('parses GET /api/notifications payload across all backend kinds', () {
      final json = {
        'success': true,
        'unreadCount': 3,
        'escalationUnreadCount': 1,
        'data': [
          {
            'id': '11111111-1111-1111-1111-111111111111',
            'type': 'activation_assigned',
            'data': {
              'kind': 'activation_assigned',
              'severity': 'normal',
              'title': 'Tugas Aktivasi Baru',
              'body': 'Segera verifikasi 10 warga binaan.',
              'action_url': '/activation/runs/42',
              'status': 'pending',
              'activation_run_id': 42,
              'due_date': '2026-11-28',
              'total_target': 10,
            },
            'readAt': null,
            'createdAt': '2026-11-20T09:00:00Z',
          },
          {
            'id': '22222222-2222-2222-2222-222222222222',
            'type': 'report_status_update',
            'data': {
              'kind': 'report_status_update',
              'severity': 'normal',
              'title': 'Laporan Sedang Diproses',
              'body': 'Laporan Anda ditindaklanjuti.',
              'action_url': '/reports/1256',
              'status': 'in_progress',
              'report_id': 1256,
              'ticket_number': 'REP-261120001',
              'report_source': 'regular',
            },
            'read_at': '2026-11-20T10:00:00Z',
            'created_at': '2026-11-20T08:00:00Z',
          },
          {
            'id': '33333333-3333-3333-3333-333333333333',
            'type': 'emergency_report_status_update',
            'data': {
              'kind': 'emergency_report_status_update',
              'severity': 'critical',
              'title': 'Laporan Darurat Diproses',
              'body': 'Tim reaksi cepat menuju lokasi.',
              'action_url': '/emergency-reports/88',
              'status': 'processing',
              'report_id': 88,
              'ticket_number': 'EMG-261120002',
              'report_source': 'emergency',
            },
            'readAt': null,
            'createdAt': '2026-11-20T09:30:00Z',
          },
          {
            'id': '44444444-4444-4444-4444-444444444444',
            'type': 'jaga_tanah_escalation_l1',
            'data': {
              'kind': 'jaga_tanah_escalation_l1',
              'severity': 'warning',
              'title': 'Eskalasi Jaga Tanah',
              'body': 'Laporan tanah mendekati SLA.',
              'action_url': '/jaga-tanah/reports/89',
              'status': 'verification',
              'report_id': 89,
              'ticket_number': 'JGT-261120001',
              'report_source': 'jaga_tanah',
              'escalation_level': 'L1',
            },
            'readAt': null,
            'createdAt': '2026-11-20T09:45:00Z',
          },
        ],
        'meta': {
          'current_page': 1,
          'last_page': 3,
          'per_page': 20,
          'total': 55,
        },
      };

      final page = AppNotificationPageModel.fromJson(json);

      expect(page.unreadCount, 3);
      expect(page.escalationUnreadCount, 1);
      expect(page.currentPage, 1);
      expect(page.lastPage, 3);
      expect(page.total, 55);
      expect(page.hasMore, isTrue);
      expect(page.items, hasLength(4));

      final activation = page.items[0];
      expect(activation.isActivation, isTrue);
      expect(activation.resolvedActivationId, '42');
      expect(activation.totalTarget, 10);
      expect(activation.isUnread, isTrue);

      final report = page.items[1];
      expect(report.isRegularReport, isTrue);
      expect(report.resolvedReportId, '1256');
      expect(report.ticketNumber, 'REP-261120001');
      expect(report.isRead, isTrue);

      final emergency = page.items[2];
      expect(emergency.isEmergencyReport, isTrue);
      expect(emergency.severity, NotificationSeverity.critical);
      expect(emergency.resolvedReportId, '88');

      final jagaTanah = page.items[3];
      expect(jagaTanah.isJagaTanah, isTrue);
      expect(jagaTanah.isEscalation, isTrue);
      expect(jagaTanah.escalationLevel, 'L1');
      expect(jagaTanah.resolvedReportId, '89');
    });

    test('parses GET /api/notifications/count nested and flat payloads', () {
      final nested = AppNotificationCountModel.fromJson(const {
        'success': true,
        'data': {
          'unreadCount': 7,
          'escalationUnreadCount': 2,
          'totalCount': 19,
        },
      });

      expect(nested.unreadCount, 7);
      expect(nested.escalationUnreadCount, 2);
      expect(nested.totalCount, 19);

      final snakeFlat = AppNotificationCountModel.fromJson(const {
        'unread_count': '4',
        'escalation_unread_count': '1',
        'total_count': '12',
      });

      expect(snakeFlat.unreadCount, 4);
      expect(snakeFlat.escalationUnreadCount, 1);
      expect(snakeFlat.totalCount, 12);
    });

    test('falls back to trailing actionUrl segments when IDs are missing', () {
      final model = AppNotificationModel.fromJson(const {
        'id': 'abc',
        'type': 'jaga_tanah_verified',
        'data': {
          'title': 'Terverifikasi',
          'body': 'Laporan terverifikasi.',
          'action_url': 'https://akaraslinmas.id/jaga-tanah/reports/991',
          'escalation_level': 0,
        },
      });

      expect(model.isJagaTanah, isTrue);
      expect(model.isEscalation, isFalse);
      expect(model.resolvedReportId, '991');
    });
  });
}
