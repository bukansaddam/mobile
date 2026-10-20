import 'dart:convert';
import 'dart:typed_data';

/// Utilitas penyamaran token URL endpoint (Compile-time string masking).
///
/// CATATAN KEAMANAN (AKAR-SEC-003 / OWASP MASVS-CRYPTO-1):
/// Penyamaran string endpoint via XOR ini bertujuan untuk mencegah ekstraksi string
/// langsung melalui perintah `strings` pada binary APK. Penyamaran ini tergolong
/// *defense-in-depth* dan BUKAN pengganti proteksi autentikasi/otorisasi hakiki.
/// Keamanan hakiki endpoint API wajib ditegakkan di level server melalui:
/// 1. Otorisasi berbasis peran (RBAC) pada setiap endpoint backend.
/// 2. Validasi JWT Token yang ditandatangani secara kriptografis (RS256/ES256).
/// 3. SSL/TLS Certificate Pinning pada saluran transmisi jaringan.
class EndpointSecurity {
  EndpointSecurity._();

  static const String _defaultKey = '5A3F7E2C8D146B9247B1682F93C4157E';
  static const String _envKey = String.fromEnvironment(
    'ENDPOINT_KEY',
    defaultValue: _defaultKey,
  );

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
    final keyList = _k.isNotEmpty ? _k : _parseHex(_defaultKey);
    final int len = tokens.length;
    final Uint8List buffer = Uint8List(len);
    final int kLen = keyList.length;

    for (int i = 0; i < len; i++) {
      final int keyByte = keyList[i % kLen];
      final int salt = (i * 17) & 0xFF;
      buffer[i] = tokens[i] ^ keyByte ^ salt;
    }

    return utf8.decode(buffer);
  }

  /// Mengenkripsi string plaintext menjadi token byte ter-obfuscate.
  /// Berguna untuk men-generate token saat menambahkan endpoint baru.
  static List<int> encode(String raw) {
    final keyList = _k.isNotEmpty ? _k : _parseHex(_defaultKey);
    final List<int> bytes = utf8.encode(raw);
    final int len = bytes.length;
    final List<int> result = <int>[];
    final int kLen = keyList.length;

    for (int i = 0; i < len; i++) {
      final int keyByte = keyList[i % kLen];
      final int salt = (i * 17) & 0xFF;
      result.add(bytes[i] ^ keyByte ^ salt);
    }

    return result;
  }
}
