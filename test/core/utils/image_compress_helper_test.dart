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
      'compressToWebp menyematkan watermark logo general 50% di tengah dengan opasitas 20%',
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
        expect(ImageCompressHelper.defaultWatermarkSizeRatio, 0.50);

        // Di luar area tengah 50% dan kotak kiri-bawah tetap biru asli.
        final outsideCorner = decoded.getPixel(5, 5);
        expect(outsideCorner.r, 20);
        expect(outsideCorner.g, 40);
        expect(outsideCorner.b, 180);
        final outsideEdge = decoded.getPixel(74, 50);
        expect(outsideEdge.r, 20);
        expect(outsideEdge.g, 40);
        expect(outsideEdge.b, 180);

        // Di area tengah (100, 50) tercampur logo dengan transparansi ~20%.
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
      'compressToWebp menyematkan geo-stamp timestamp, koordinat, dan alamat lengkap di kiri bawah',
      () async {
        final tempDir = Directory.systemTemp.createTempSync('geostamp_test_');
        addTearDown(() => tempDir.deleteSync(recursive: true));

        final sourceImage = img.Image(width: 800, height: 600);
        img.fill(sourceImage, color: img.ColorRgb8(240, 240, 240));

        final sourceFile = File('${tempDir.path}/report.png');
        await sourceFile.writeAsBytes(img.encodePng(sourceImage));

        final result = await ImageCompressHelper.compressToWebp(
          sourceFile,
          stampTimestamp: DateTime(2026, 11, 17, 11, 15),
          stampLatitude: -6.229728,
          stampLongitude: 106.854829,
          stampAddress:
              'Jl. Tebet Timur Dalam II E No. 10, Kec. Tebet, Kota Jakarta Selatan, DKI Jakarta 12820',
        );
        if (result.path != sourceFile.path && result.existsSync()) {
          addTearDown(() => result.deleteSync());
        }

        final decoded = img.decodeImage(await result.readAsBytes());
        expect(decoded, isNotNull);

        // Sudut kanan-bawah tetap warna asli (240, 240, 240).
        final bottomRight = decoded!.getPixel(790, 590);
        expect(bottomRight.r, 240);
        expect(bottomRight.g, 240);
        expect(bottomRight.b, 240);

        // Area kotak kiri-bawah memiliki piksel scrim gelap (< 120) dan piksel teks terang (> 200).
        var darkPixels = 0;
        var brightPixels = 0;
        for (var y = 450; y < 580; y += 2) {
          for (var x = 25; x < 420; x += 2) {
            final p = decoded.getPixel(x, y);
            if (p.r < 120 && p.g < 120 && p.b < 130) darkPixels++;
            if (p.r > 200 && p.g > 200 && p.b > 200) brightPixels++;
          }
        }
        expect(darkPixels, greaterThan(100));
        expect(brightPixels, greaterThan(20));
      },
    );

    test(
      'prepareMediaFiles mengabaikan koordinat (0, 0) dan hanya menampilkan timestamp bila alamat kosong',
      () async {
        final tempDir = Directory.systemTemp.createTempSync('prepare_media_');
        addTearDown(() => tempDir.deleteSync(recursive: true));

        final sourceImage = img.Image(width: 800, height: 600);
        img.fill(sourceImage, color: img.ColorRgb8(240, 240, 240));

        final sourceFile = File('${tempDir.path}/item.png');
        await sourceFile.writeAsBytes(img.encodePng(sourceImage));

        final results = await ImageCompressHelper.prepareMediaFiles(
          [sourceFile],
          timestamp: DateTime(2026, 11, 17, 11, 15),
          latitude: 0.0,
          longitude: 0.0,
          address: '',
        );
        expect(results, hasLength(1));
        if (results.first.path != sourceFile.path &&
            results.first.existsSync()) {
          addTearDown(() => results.first.deleteSync());
        }

        final decoded = img.decodeImage(await results.first.readAsBytes());
        expect(decoded, isNotNull);

        // Dengan 1 baris timestamp saja, kotak tidak setinggi area 3+ baris (y=460 masih putih asli 240).
        final aboveSingleLineBox = decoded!.getPixel(40, 460);
        expect(aboveSingleLineBox.r, 240);
        expect(aboveSingleLineBox.g, 240);
        expect(aboveSingleLineBox.b, 240);

        // Baris timestamp berada di bagian paling bawah kiri.
        final insideBox = decoded.getPixel(30, 565);
        expect(insideBox.r, lessThan(120));
      },
    );

    test(
      'compressToWebp dengan watermark: false tidak menempelkan watermark maupun geo-stamp',
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
          stampTimestamp: DateTime(2026, 11, 17, 11, 15),
          stampLatitude: -6.229728,
          stampLongitude: 106.854829,
          stampAddress: 'Jakarta Selatan',
        );

        final decoded = img.decodeImage(await result.readAsBytes());
        expect(decoded, isNotNull);
        final center = decoded!.getPixel(60, 60);
        expect(center.r, 255);
        expect(center.g, 255);
        expect(center.b, 255);
        final bottomLeft = decoded.getPixel(10, 110);
        expect(bottomLeft.r, 255);
        expect(bottomLeft.g, 255);
        expect(bottomLeft.b, 255);
      },
    );
  });
}
