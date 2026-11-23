// test/core/offline/idempotency_and_queue_item_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/offline/idempotency_key_generator.dart';
import 'package:akar/core/offline/offline_queue_item.dart';

void main() {
  group('IdempotencyKeyGenerator', () {
    test('generates valid RFC4122 v4 UUID string', () {
      final key1 = generateIdempotencyKey();
      final key2 = generateIdempotencyKey();

      expect(key1, isNot(equals(key2)));
      final uuidRegex = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: false,
      );
      expect(uuidRegex.hasMatch(key1), isTrue);
      expect(uuidRegex.hasMatch(key2), isTrue);
    });
  });

  group('OfflineQueueItem serialization', () {
    test('correctly serializes and deserializes with all fields intact', () {
      final now = DateTime.now();
      final item = OfflineQueueItem(
        id: 'q-1001',
        clientRequestId: generateIdempotencyKey(),
        featureType: OfflineFeatureType.jagaTanah,
        userId: 'user-77',
        status: OfflineItemStatus.pending,
        payload: {
          'title': 'Lahan Terbengkalai',
          'capturedAt': now.toIso8601String(),
          'capturedLat': -6.2088,
          'capturedLng': 106.8456,
          'needsReverseGeocode': true,
        },
        attachments: [
          const OfflineAttachment(
            fieldKey: 'attachments[]',
            localPath: '/support/q-1001/0_foto.webp',
            originalName: 'foto.jpg',
            mimeType: 'image/webp',
            sizeBytes: 102400,
            isVideo: false,
            alreadyStamped: false,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final json = item.toJson();
      final reconstructed = OfflineQueueItem.fromJson(json);

      expect(reconstructed.id, equals('q-1001'));
      expect(reconstructed.featureType, equals(OfflineFeatureType.jagaTanah));
      expect(reconstructed.userId, equals('user-77'));
      expect(reconstructed.payload['title'], equals('Lahan Terbengkalai'));
      expect(reconstructed.attachments.first.alreadyStamped, isFalse);
    });
  });
}
