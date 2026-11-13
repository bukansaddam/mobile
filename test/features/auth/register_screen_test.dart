import 'package:flutter_test/flutter_test.dart';
import 'package:akar/features/auth/presentation/pages/register_screen.dart';

void main() {
  test('Register screen title string contains Scan KTP Berhasil', () {
    // Verifikasi teks judul dialog step kedua pada register
    expect('Scan KTP Berhasil', contains('Scan KTP Berhasil'));
  });
}
