import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/features/ai_chat/data/models/ai_chat_models.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiConstants AI Chat endpoints', () {
    test('decodes AI Chat paths accurately', () {
      expect(ApiConstants.aiChatStatus, equals('/api/ai-chat/status'));
      expect(ApiConstants.aiChatMessages, equals('/api/ai-chat/messages'));
      expect(ApiConstants.aiChatSessions, equals('/api/ai-chat/sessions'));
      expect(
        ApiConstants.aiChatSessionDetail(42),
        equals('/api/ai-chat/sessions/42'),
      );
    });
  });

  group('AiChatStatusModel', () {
    test('parses nested data with enabled=false and disabled_message', () {
      final model = AiChatStatusModel.fromJson({
        'data': {
          'enabled': false,
          'disabled_message': 'Layanan Siska sedang pemeliharaan',
        },
      });
      final entity = model.toDomain();
      expect(entity.enabled, isFalse);
      expect(
        entity.disabledMessage,
        equals('Layanan Siska sedang pemeliharaan'),
      );
    });

    test('parses flat is_enabled=true and string status fallback', () {
      final enabledModel = AiChatStatusModel.fromJson({'is_enabled': true});
      expect(enabledModel.toDomain().enabled, isTrue);

      final disabledModel = AiChatStatusModel.fromJson({
        'status': 'disabled',
        'message': 'Sedang diperbarui',
      });
      expect(disabledModel.toDomain().enabled, isFalse);
      expect(
        disabledModel.toDomain().disabledMessage,
        equals('Sedang diperbarui'),
      );
    });
  });

  group('AiChatSendResultModel', () {
    test('parses nested data with session, messages, and references', () {
      final model = AiChatSendResultModel.fromJson({
        'data': {
          'session': {'id': 12, 'title': 'Tanya Patroli'},
          'user_message': {
            'id': 100,
            'role': 'user',
            'content': 'Halo',
            'created_at': '2026-11-23T10:00:00Z',
          },
          'assistant_message': {
            'id': 101,
            'role': 'assistant',
            'content': 'Hai petugas!',
            'created_at': '2026-11-23T10:00:02Z',
            'references': [
              {'title': 'SOP Patroli', 'source': 'sop.pdf'},
            ],
          },
        },
      });
      final entity = model.toDomain();
      expect(entity.session?.id, equals(12));
      expect(entity.session?.title, equals('Tanya Patroli'));
      expect(entity.userMessage?.id, equals(100));
      expect(entity.userMessage?.role, equals(AiChatMessageRole.user));
      expect(entity.assistantMessage.id, equals(101));
      expect(entity.assistantMessage.role, equals(AiChatMessageRole.assistant));
      expect(entity.assistantMessage.content, equals('Hai petugas!'));
      expect(entity.assistantMessage.references.length, equals(1));
      expect(
        entity.assistantMessage.references.first.title,
        equals('SOP Patroli'),
      );
    });

    test(
      'parses flat reply fallback with session_id and document_name refs',
      () {
        final model = AiChatSendResultModel.fromJson({
          'session_id': 7,
          'title': 'Baru',
          'reply': 'Halo warga',
          'references': [
            {
              'document_name': 'panduan.pdf',
              'url': 'https://example.com/panduan.pdf',
            },
          ],
        });
        final entity = model.toDomain();
        expect(entity.session?.id, equals(7));
        expect(entity.assistantMessage.content, equals('Halo warga'));
        expect(
          entity.assistantMessage.references.first.title,
          equals('panduan.pdf'),
        );
        expect(
          entity.assistantMessage.references.first.url,
          equals('https://example.com/panduan.pdf'),
        );
      },
    );
  });

  group('AiChatSessionDetailModel', () {
    test(
      'parses chronological messages and next_before_id from meta or root',
      () {
        final rootModel = AiChatSessionDetailModel.fromJson({
          'data': {
            'session': {'id': 5, 'title': 'Riwayat Jaga Tanah'},
            'messages': [
              {'id': 10, 'role': 'user', 'content': 'Q1'},
              {'id': 11, 'role': 'assistant', 'content': 'A1'},
            ],
            'next_before_id': 10,
          },
        });
        final rootEntity = rootModel.toDomain();
        expect(rootEntity.session.id, equals(5));
        expect(rootEntity.messages.length, equals(2));
        expect(rootEntity.nextBeforeId, equals(10));

        final metaModel = AiChatSessionDetailModel.fromJson({
          'session': {'id': 6, 'title': 'Sesi Meta'},
          'items': [
            {'id': 55, 'role': 'user', 'message': 'Q55'},
          ],
          'meta': {'next_before_id': 55},
        });
        final metaEntity = metaModel.toDomain();
        expect(metaEntity.session.id, equals(6));
        expect(metaEntity.messages.single.content, equals('Q55'));
        expect(metaEntity.nextBeforeId, equals(55));
      },
    );
  });
}
