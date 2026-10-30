import 'dart:io';

import 'package:akar/features/linmas/activation/data/datasources/activation_pending_report_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late ActivationPendingReportLocalDatasource store;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('pending_reports_test');
    store = ActivationPendingReportLocalDatasource(
      rootDirectory: () async => tempDir,
    );
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  File sourceFile(String name) {
    return File('${tempDir.path}/$name')..writeAsBytesSync([1, 2, 3]);
  }

  Future<String> enqueueOne() async {
    final report = await store.enqueue(
      userId: 'user-1',
      participantId: 'act-1',
      activityTitle: 'Sosialisasi',
      attachments: [sourceFile('foto.webp')],
    );
    return report.id;
  }

  test(
    'lampiran disalin ke folder aplikasi dan bertahan saat sumber hilang',
    () async {
      final id = await enqueueOne();
      await sourceFile('foto.webp').delete();

      final pending = await store.getPending();
      expect(pending, hasLength(1));
      expect(pending.single.id, id);
      expect(File(pending.single.attachmentPaths.single).existsSync(), isTrue);
      expect(
        DateTime.now().difference(pending.single.createdAt).inMinutes,
        lessThan(1),
      );
    },
  );

  test('entri dibuang bila lampirannya sudah tidak ada', () async {
    final id = await enqueueOne();
    final pending = await store.getPending();
    await File(pending.single.attachmentPaths.single).delete();

    expect(await store.getPending(), isEmpty);
    expect(
      Directory('${tempDir.path}/pending_activation_reports/$id').existsSync(),
      isFalse,
    );
  });

  test('remove menghapus entri beserta folder lampirannya', () async {
    final id = await enqueueOne();
    await store.remove(id);

    expect(await store.getPending(), isEmpty);
    expect(
      Directory('${tempDir.path}/pending_activation_reports/$id').existsSync(),
      isFalse,
    );
  });

  test('markError menyimpan pesan kegagalan terakhir', () async {
    final id = await enqueueOne();
    await store.markError(id, 'Koneksi timeout');

    expect((await store.getPending()).single.lastError, 'Koneksi timeout');
  });
}
