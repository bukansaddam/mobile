import 'dart:convert';
import 'dart:typed_data';

class EndpointSecurity {
  EndpointSecurity._();

  static const String _envKey = String.fromEnvironment('ENDPOINT_KEY');

  static List<int>? _cachedKey;

  static List<int> get _k {
    if (_cachedKey != null) return _cachedKey!;
    List<int> parsed = [];
    if (_envKey.isNotEmpty) {
      parsed = _parseHex(_envKey);
    }
    _cachedKey = parsed;
    return parsed;
  }

  static List<int> _parseHex(String hex) {
    final String clean = hex.trim().replaceAll('0x', '').replaceAll(' ', '');
    final List<int> bytes = <int>[];
    for (int i = 0; i < clean.length - 1; i += 2) {
      final int? b = int.tryParse(clean.substring(i, i + 2), radix: 16);
      if (b != null) bytes.add(b);
    }
    return bytes;
  }

  /// Mendekode token byte menjadi string asli
  static String decode(List<int> tokens) {
    if (_k.isEmpty) {
      throw StateError(
        'ENDPOINT_KEY is not defined. Ensure --dart-define-from-file=.env is provided.',
      );
    }
    final int len = tokens.length;
    final Uint8List buffer = Uint8List(len);
    final int kLen = _k.length;

    for (int i = 0; i < len; i++) {
      final int keyByte = _k[i % kLen];
      final int salt = (i * 17) & 0xFF;
      buffer[i] = tokens[i] ^ keyByte ^ salt;
    }

    return utf8.decode(buffer);
  }

  /// Mengenkripsi string plaintext menjadi token byte ter-obfuscate.
  /// Berguna untuk men-generate token saat menambahkan endpoint baru.
  static List<int> encode(String raw) {
    final List<int> bytes = utf8.encode(raw);
    final int len = bytes.length;
    final List<int> result = <int>[];
    final int kLen = _k.length;

    for (int i = 0; i < len; i++) {
      final int keyByte = _k[i % kLen];
      final int salt = (i * 17) & 0xFF;
      result.add(bytes[i] ^ keyByte ^ salt);
    }

    return result;
  }
}
