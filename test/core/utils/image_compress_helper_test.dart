import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/utils/image_compress_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageCompressHelper', () {
    test('compressToWebp returns original file if file does not exist', () async {
      final nonExistentFile = File('/path/to/non_existent_image.jpg');

      final result = await ImageCompressHelper.compressToWebp(nonExistentFile);

      expect(result.path, equals(nonExistentFile.path));
    });

    test('compressToWebp gracefully returns input file if compression fails or unsupported in unit test environment', () async {
      // Create a temporary mock file
      final tempDir = Directory.systemTemp.createTempSync('compress_test_');
      final tempFile = File('${tempDir.path}/sample.txt');
      tempFile.writeAsStringSync('dummy content');

      final result = await ImageCompressHelper.compressToWebp(tempFile);

      // In unit test without native platform channels, it gracefully falls back to the original file
      expect(result.existsSync(), isTrue);
      expect(result.path, equals(tempFile.path));

      // Cleanup
      tempDir.deleteSync(recursive: true);
    });
  });
}
