import 'package:akar/features/linmas/activation/data/models/activation_submission_model.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses attachments array with photo and video', () {
    final model = ActivationSubmissionDataModel.fromJson({
      'id': 40279,
      'receiver_nik': '1234567891234567',
      'receiver_name': 'saddam',
      'notes': 'Testing',
      'created_at': '2026-10-29 07:57:17',
      'attachments': [
        {
          'id': 80639,
          'submission_id': 40279,
          'mime_type': 'video/quicktime',
          'file_url': '/api/activations/attachments/80639/file',
        },
        {
          'id': 80640,
          'submission_id': 40279,
          'mime_type': 'image/webp',
          'file_url': '/api/activations/attachments/80640/file',
        },
      ],
    });

    final entity = model.toDomain();

    expect(entity.id, 40279);
    expect(entity.receiverName, 'saddam');
    expect(entity.createdAt, '2026-10-29 07:57:17');
    expect(entity.attachments, hasLength(2));
    expect(entity.attachments.first.mimeType, 'video/quicktime');
    expect(entity.attachments.last.mimeType, 'image/webp');
  });

  test('attachment field is ignored when attachments is present', () {
    final model = ActivationSubmissionDataModel.fromJson({
      'id': 1,
      'attachments': [
        {'id': 10, 'mime_type': 'image/webp'},
      ],
      'attachment': [
        {'id': 10, 'mime_type': 'image/webp'},
      ],
    });

    expect(model.toDomain().attachments, hasLength(1));
  });
}
