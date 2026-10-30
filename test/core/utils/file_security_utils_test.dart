import 'dart:io';

import 'package:akar/core/utils/file_security_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('file_security_test');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  File writeFile(String name, {int size = 8}) {
    final file = File('${tempDir.path}/$name');
    file.writeAsBytesSync(List.filled(size, 0));
    return file;
  }

  test('video mp4 dengan ukuran wajar diterima', () {
    expect(
      () => FileSecurityUtils.validateVideoFile(writeFile('bukti.mp4')),
      returnsNormally,
    );
  });

  test('video dengan ekstensi gambar ditolak', () {
    expect(
      () => FileSecurityUtils.validateVideoFile(writeFile('bukti.png')),
      throwsA(isA<FileSecurityException>()),
    );
  });

  test('video melebihi batas ukuran ditolak', () {
    expect(
      () => FileSecurityUtils.validateVideoFile(
        writeFile('besar.mov', size: 11),
        maxSizeBytes: 10,
      ),
      throwsA(isA<FileSecurityException>()),
    );
  });

  test('isVideoPath membedakan video dan gambar', () {
    expect(FileSecurityUtils.isVideoPath('/tmp/a.MP4'), isTrue);
    expect(FileSecurityUtils.isVideoPath('/tmp/a.webp'), isFalse);
    expect(FileSecurityUtils.isVideoPath('/tmp/a.3gp'), isFalse);
  });
}
