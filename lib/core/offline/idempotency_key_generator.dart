import 'dart:math';

final Random _secureRandom = Random.secure();

/// Menghasilkan RFC4122 v4 UUID string representatif tanpa menambah dependensi external.
String generateIdempotencyKey() {
  final values = List<int>.generate(16, (_) => _secureRandom.nextInt(256));

  // Set bit versi 4 (0100xxxx)
  values[6] = (values[6] & 0x0f) | 0x40;
  // Set bit varian RFC4122 (10xxxxxx)
  values[8] = (values[8] & 0x3f) | 0x80;

  String hex(int val) => val.toRadixString(16).padLeft(2, '0');

  final buf = StringBuffer();
  for (var i = 0; i < 16; i++) {
    buf.write(hex(values[i]));
    if (i == 3 || i == 5 || i == 7 || i == 9) {
      buf.write('-');
    }
  }
  return buf.toString();
}
