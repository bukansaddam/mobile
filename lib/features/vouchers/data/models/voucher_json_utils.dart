/// Helper parsing JSON defensif untuk DTO voucher dan ringkasan poin.
Map<String, dynamic> voucherAsMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return const <String, dynamic>{};
}

String voucherAsString(Object? raw, {String fallback = ''}) {
  if (raw == null) return fallback;
  final text = raw.toString().trim();
  return text.isEmpty ? fallback : text;
}

String? voucherAsNullableString(Object? raw) {
  if (raw == null) return null;
  final text = raw.toString().trim();
  return text.isEmpty ? null : text;
}

int voucherAsInt(Object? raw, {int fallback = 0}) {
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw.trim()) ?? fallback;
  return fallback;
}

bool voucherAsBool(Object? raw, {bool fallback = false}) {
  if (raw is bool) return raw;
  if (raw is num) return raw != 0;
  if (raw is String) {
    final lower = raw.trim().toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return fallback;
}

DateTime? voucherAsDateTime(Object? raw) {
  if (raw is DateTime) return raw;
  if (raw == null) return null;
  final text = raw.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}
