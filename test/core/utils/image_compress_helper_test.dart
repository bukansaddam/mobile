import 'dart:io';

import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageCompressHelper', () {
    test(
      'compressToWebp returns original file if file does not exist',
      () async {
        final nonExistentFile = File('/path/to/non_existent_image.jpg');

        final result = await ImageCompressHelper.compressToWebp(
          nonExistentFile,
        );

        expect(result.path, equals(nonExistentFile.path));
      },
    );

    test(
      'compressToWebp gracefully returns input file if compression fails or unsupported in unit test environment',
      () async {
        final tempDir = Directory.systemTemp.createTempSync('compress_test_');
        addTearDown(() => tempDir.deleteSync(recursive: true));

        final tempFile = File('${tempDir.path}/sample.txt');
        tempFile.writeAsStringSync('dummy content');

        final result = await ImageCompressHelper.compressToWebp(tempFile);

        expect(result.existsSync(), isTrue);
        expect(result.path, equals(tempFile.path));
      },
    );

    test(
      'compressToWebp menyematkan watermark logo general 30% di tengah dengan opasitas 20%',
      () async {
        final tempDir = Directory.systemTemp.createTempSync('watermark_test_');
        addTearDown(() => tempDir.deleteSync(recursive: true));

        final sourceImage = img.Image(width: 200, height: 100);
        img.fill(sourceImage, color: img.ColorRgb8(20, 40, 180));

        final sourceFile = File('${tempDir.path}/photo.png');
        await sourceFile.writeAsBytes(img.encodePng(sourceImage));

        final result = await ImageCompressHelper.compressToWebp(sourceFile);
        if (result.path != sourceFile.path && result.existsSync()) {
          addTearDown(() => result.deleteSync());
        }

        final decoded = img.decodeImage(await result.readAsBytes());
        expect(decoded, isNotNull);
        expect(decoded!.width, 200);
        expect(decoded.height, 100);

        // Di luar area tengah 30% (30x30 pada x:85..115, y:35..65) tetap biru asli.
        final corner = decoded.getPixel(5, 5);
        expect(corner.r, 20);
        expect(corner.g, 40);
        expect(corner.b, 180);

        // Di area tengah (100, 50) tercampur logo dengan transparansi ~20% (perubahan warna ~0..51).
        final center = decoded.getPixel(100, 50);
        final maxDelta = [
          (center.r - 20).abs(),
          (center.g - 40).abs(),
          (center.b - 180).abs(),
        ].reduce((a, b) => a > b ? a : b);
        expect(maxDelta, greaterThan(0));
        expect(maxDelta, lessThanOrEqualTo(55));
      },
    );

    test(
      'compressToWebp dengan watermark: false tidak menempelkan watermark',
      () async {
        final tempDir = Directory.systemTemp.createTempSync(
          'no_watermark_test_',
        );
        addTearDown(() => tempDir.deleteSync(recursive: true));

        final sourceImage = img.Image(width: 120, height: 120);
        img.fill(sourceImage, color: img.ColorRgb8(255, 255, 255));

        final sourceFile = File('${tempDir.path}/avatar.png');
        await sourceFile.writeAsBytes(img.encodePng(sourceImage));

        final result = await ImageCompressHelper.compressToWebp(
          sourceFile,
          watermark: false,
        );

        final decoded = img.decodeImage(await result.readAsBytes());
        expect(decoded, isNotNull);
        final center = decoded!.getPixel(60, 60);
        expect(center.r, 255);
        expect(center.g, 255);
        expect(center.b, 255);
      },
    );
  });
}
