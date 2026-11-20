/// Helper parsing JSON defensif untuk DTO notifikasi.
Map<String, dynamic> notificationAsMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return const <String, dynamic>{};
}

String notificationAsString(Object? raw, {String fallback = ''}) {
  if (raw == null) return fallback;
  final text = raw.toString().trim();
  return text.isEmpty ? fallback : text;
}

String? notificationAsNullableString(Object? raw) {
  if (raw == null) return null;
  final text = raw.toString().trim();
  return text.isEmpty ? null : text;
}

int notificationAsInt(Object? raw, {int fallback = 0}) {
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw.trim()) ?? fallback;
  return fallback;
}

int? notificationAsNullableInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw.trim());
  return null;
}

DateTime? notificationAsDateTime(Object? raw) {
  if (raw is DateTime) return raw;
  if (raw == null) return null;
  final text = raw.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}
