import 'dart:io';
import 'dart:ui';

import 'package:akar/features/auth/presentation/pages/ktp_camera_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('bingkai KTP di tengah dan selebar 86% layar portrait', () {
    const size = Size(390, 844);
    final frame = computeKtpFrameRect(size);

    expect(frame.center.dx, closeTo(size.width / 2, 0.01));
    expect(frame.center.dy, closeTo(size.height / 2, 0.01));
    expect(frame.width, closeTo(size.width * 0.86, 0.01));
    expect(frame.width / frame.height, closeTo(ktpAspectRatio, 0.01));
  });

  test('bingkai tetap masuk layar landscape', () {
    const size = Size(844, 390);
    final frame = computeKtpFrameRect(size);

    expect(frame.top, greaterThanOrEqualTo(0));
    expect(frame.bottom, lessThanOrEqualTo(size.height));
    expect(frame.width / frame.height, closeTo(ktpAspectRatio, 0.01));
  });

  test('crop portrait memotong ke area bingkai', () {
    const viewport = Size(390, 844);
    final frame = computeKtpFrameRect(viewport);
    final crop = computeKtpCropRect(
      imageSize: const Size(1080, 1920),
      viewport: viewport,
      frame: frame,
    );

    expect(crop.width, closeTo(824, 1));
    expect(crop.width / crop.height, closeTo(ktpAspectRatio, 0.01));
    expect(crop.center.dx, closeTo(1080 / 2, 0.01));
    expect(crop.center.dy, closeTo(1920 / 2, 0.01));
    expect(crop.width, lessThan(1080));
  });

  test('crop gambar landscape tetap di dalam gambar', () {
    const viewport = Size(390, 844);
    final frame = computeKtpFrameRect(viewport);
    final crop = computeKtpCropRect(
      imageSize: const Size(1920, 1080),
      viewport: viewport,
      frame: frame,
    );

    expect(crop.left, greaterThanOrEqualTo(0));
    expect(crop.top, greaterThanOrEqualTo(0));
    expect(crop.right, lessThanOrEqualTo(1920));
    expect(crop.bottom, lessThanOrEqualTo(1080));
    expect(crop.width / crop.height, closeTo(ktpAspectRatio, 0.01));
  });

  test('cropKtpImage menghasilkan file JPEG berasio KTP', () async {
    final source = File('${Directory.systemTemp.path}/ktp_source_test.jpg');
    final image = img.Image(width: 400, height: 400);
    img.fill(image, color: img.ColorRgb8(120, 120, 120));
    await source.writeAsBytes(img.encodeJpg(image, quality: 90));

    const viewport = Size(390, 844);
    final result = await cropKtpImage(
      source,
      viewport: viewport,
      frame: computeKtpFrameRect(viewport),
    );

    expect(result, isNotNull);
    final decoded = img.decodeImage(await result!.readAsBytes());
    expect(decoded, isNotNull);
    expect(decoded!.width / decoded.height, closeTo(ktpAspectRatio, 0.02));

    await result.delete();
    await source.delete();
  });
}
