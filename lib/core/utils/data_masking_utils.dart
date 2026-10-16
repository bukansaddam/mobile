class DataMaskingUtils {
  DataMaskingUtils._();

  /// Masking NIK (Nomor Induk Kependudukan) atau Nomor Kartu Keluarga (KK) 16 digit.
  /// Menampilkan 4 digit awal dan 4 digit akhir, dengan 8 digit tengah disamarkan (contoh: 3201********1234).
  static String maskNikOrKk(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    final clean = value.trim();
    if (clean.length <= 8) return clean;
    final prefix = clean.substring(0, 4);
    final suffix = clean.substring(clean.length - 4);
    final maskedLength = clean.length - 8;
    return '$prefix${'*' * maskedLength}$suffix';
  }

  /// Masking Nomor Telepon (contoh: 0812****7890)
  static String maskPhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) return '-';
    final clean = phone.trim();
    if (clean.length <= 6) return clean;
    final prefix = clean.substring(0, 4);
    final suffix = clean.substring(clean.length - 3);
    final maskedLength = clean.length - 7;
    return '$prefix${'*' * maskedLength}$suffix';
  }

  /// Masking Alamat Email (contoh: jo***@example.com)
  static String maskEmail(String? email) {
    if (email == null || email.trim().isEmpty || !email.contains('@')) {
      return email ?? '-';
    }
    final parts = email.trim().split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) {
      return '${name[0]}*@$domain';
    }
    return '${name.substring(0, 2)}${'*' * (name.length - 2)}@$domain';
  }
}
