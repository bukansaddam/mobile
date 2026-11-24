import 'package:akar/core/utils/report_point_policy.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportPointPolicy.parsePointsFromMap', () {
    test('parses supported snake_case and camelCase keys defensively', () {
      expect(
        ReportPointPolicy.parsePointsFromMap({'points_awarded': 10}),
        equals(10),
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'pointsAwarded': '15'}),
        equals(15),
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'earned_points': 1.0}),
        equals(1),
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'reward_points': 20}),
        equals(20),
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': 10}),
        equals(10),
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'point': '1'}),
        equals(1),
      );
    });

    test('returns null for missing, invalid, or negative values', () {
      expect(ReportPointPolicy.parsePointsFromMap(const {}), isNull);
      expect(
        ReportPointPolicy.parsePointsFromMap({'points_awarded': -5}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': 'abc'}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': null}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': -0.5}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': '-0.5'}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': double.nan}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': double.infinity}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': 'NaN'}),
        isNull,
      );
      expect(
        ReportPointPolicy.parsePointsFromMap({'points': 'Infinity'}),
        isNull,
      );
    });

    test('prefers first non-null map in parsePointsFromMaps', () {
      final result = ReportPointPolicy.parsePointsFromMaps([
        {'title': 'Tanpa poin'},
        {'points_awarded': 12},
        {'points': 5},
      ]);
      expect(result, equals(12));
    });
  });

  group('ReportPointPolicy.resolve (Jaga Tanah)', () {
    test('marks pre-verification statuses as pending with 10 potential points', () {
      for (final status in const ['submitted', 'verification_assigned', '']) {
        final info = ReportPointPolicy.resolve(
          category: ReportPointCategory.jagaTanah,
          statusCode: status,
        );
        expect(info.state, equals(ReportPointState.pending), reason: status);
        expect(info.isEarned, isFalse);
        expect(info.points, equals(10));
        expect(info.detailChipLabel, equals('Potensi +10 Poin'));
      }
    });

    test('marks verified and downstream statuses as earned with +10 Poin', () {
      for (final status in const [
        'verified',
        'mediation',
        'fifty_fifty',
        'bpn_forwarded',
        'completed',
      ]) {
        final info = ReportPointPolicy.resolve(
          category: ReportPointCategory.jagaTanah,
          statusCode: status,
        );
        expect(info.state, equals(ReportPointState.earned), reason: status);
        expect(info.isEarned, isTrue);
        expect(info.points, equals(10));
        expect(info.badgeLabel, equals('+10 Poin'));
        expect(info.detailChipLabel, equals('+10 Poin'));
      }
    });

    test('marks rejected and cancelled statuses as notEligible with 0 Poin', () {
      for (final status in const ['rejected', 'cancelled', 'canceled']) {
        final info = ReportPointPolicy.resolve(
          category: ReportPointCategory.jagaTanah,
          statusCode: status,
          apiPoints: 10,
        );
        expect(info.state, equals(ReportPointState.notEligible), reason: status);
        expect(info.isEarned, isFalse);
        expect(info.points, equals(0));
        expect(info.detailChipLabel, equals('0 Poin'));
      }
    });
  });

  group('ReportPointPolicy.resolve (Laporan Insidentil)', () {
    test('keeps verification and in_review as pending, never earned', () {
      for (final status in const [
        'new',
        'created',
        'submitted',
        'pending',
        'verification',
        'in_review',
      ]) {
        final info = ReportPointPolicy.resolve(
          category: ReportPointCategory.laporanInsidentil,
          statusCode: status,
          fallbackStatus: ComplaintStatus.verified,
        );
        expect(info.state, equals(ReportPointState.pending), reason: status);
        expect(info.isEarned, isFalse);
        expect(info.points, equals(1));
        expect(info.detailChipLabel, equals('Potensi +1 Poin'));
      }
    });

    test('marks verified, in_progress, and completed as earned with +1 Poin', () {
      for (final status in const [
        'verified',
        'in_progress',
        'processing',
        'resolved',
        'completed',
        'done',
      ]) {
        final info = ReportPointPolicy.resolve(
          category: ReportPointCategory.laporanInsidentil,
          statusCode: status,
        );
        expect(info.state, equals(ReportPointState.earned), reason: status);
        expect(info.isEarned, isTrue);
        expect(info.points, equals(1));
        expect(info.badgeLabel, equals('+1 Poin'));
      }
    });

    test('uses API positive points value over default fallback (Hybrid)', () {
      final info = ReportPointPolicy.resolve(
        category: ReportPointCategory.laporanInsidentil,
        statusCode: 'submitted',
        apiPoints: 5,
      );
      expect(info.state, equals(ReportPointState.earned));
      expect(info.points, equals(5));
      expect(info.badgeLabel, equals('+5 Poin'));
    });

    test('falls back to default earned points when verified and apiPoints is 0', () {
      final info = ReportPointPolicy.resolve(
        category: ReportPointCategory.jagaTanah,
        statusCode: 'verified',
        apiPoints: 0,
      );
      expect(info.state, equals(ReportPointState.earned));
      expect(info.points, equals(10));
    });

    test('recognizes verified timeline event when statusCode is empty', () {
      final info = ReportPointPolicy.resolve(
        category: ReportPointCategory.laporanInsidentil,
        statusCode: '',
        timelineTypes: const ['created', 'verified'],
      );
      expect(info.state, equals(ReportPointState.earned));
      expect(info.points, equals(1));
    });

    test('uses fallbackStatus enum when statusCode is empty', () {
      final earned = ReportPointPolicy.resolve(
        category: ReportPointCategory.jagaTanah,
        statusCode: '',
        fallbackStatus: ComplaintStatus.completed,
      );
      expect(earned.state, equals(ReportPointState.earned));
      expect(earned.points, equals(10));

      final rejected = ReportPointPolicy.resolve(
        category: ReportPointCategory.jagaTanah,
        statusCode: '',
        fallbackStatus: ComplaintStatus.rejected,
      );
      expect(rejected.state, equals(ReportPointState.notEligible));
      expect(rejected.points, equals(0));
    });
  });
}
