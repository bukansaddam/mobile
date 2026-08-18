class BankSampahConstants {
  BankSampahConstants._();

  /// Harga standar sampah per kg (otomatis Rp 5.000)
  static const double hargaPerKg = 5000.0;

  /// Pilihan jenis sampah sesuai kebutuhan
  static const List<String> jenisSampahList = ['Organik', 'Anorganik'];

  /// Data awal Bank Sampah terdaftar di wilayah
  static const List<Map<String, dynamic>> defaultLocations = [
    {
      'id': 'BS-001',
      'nama': 'Bank Sampah Berkah Mandiri',
      'alamat': 'Jl. Mawar Indah No. 12, RT 02/RW 04',
      'kelurahan': 'Kelurahan Sukamaju',
      'pengelola': 'Pak Joko Widodo',
      'kontak': '081234567801',
      'latOffset': 0.0018,
      'lngOffset': 0.0012,
    },
    {
      'id': 'BS-002',
      'nama': 'Bank Sampah Asri Jaya',
      'alamat': 'Jl. Dahlia Raya No. 45, RT 05/RW 02',
      'kelurahan': 'Kelurahan Sukamaju',
      'pengelola': 'Ibu Siti Rahma',
      'kontak': '081234567802',
      'latOffset': -0.0035,
      'lngOffset': 0.0028,
    },
    {
      'id': 'BS-003',
      'nama': 'Bank Sampah Melati Bersih',
      'alamat': 'Jl. Kenanga Timur No. 8, RT 01/RW 03',
      'kelurahan': 'Kelurahan Cempaka',
      'pengelola': 'Pak Hendra Gunawan',
      'kontak': '081234567803',
      'latOffset': 0.0055,
      'lngOffset': -0.0042,
    },
    {
      'id': 'BS-004',
      'nama': 'Bank Sampah Hijau Lestari',
      'alamat': 'Kompleks RW 06 Balai Warga',
      'kelurahan': 'Kelurahan Harapan Baru',
      'pengelola': 'Ibu Dewi Sartika',
      'kontak': '081234567804',
      'latOffset': -0.0080,
      'lngOffset': -0.0065,
    },
    {
      'id': 'BS-005',
      'nama': 'Bank Sampah Sejahtera RW 08',
      'alamat': 'Jl. Melur Barat No. 19, RT 03/RW 08',
      'kelurahan': 'Kelurahan Harapan Baru',
      'pengelola': 'Pak Rudi Haryanto',
      'kontak': '081234567805',
      'latOffset': 0.0125,
      'lngOffset': 0.0110,
    },
  ];

  /// Data dummy laporan awal untuk demonstrasi
  static const List<Map<String, dynamic>> defaultReports = [
    {
      'id': 'LBS-001',
      'bankSampahId': 'BS-001',
      'bankSampahNama': 'Bank Sampah Berkah Mandiri',
      'jenisSampah': 'Anorganik',
      'beratKg': 15.5,
      'nilaiRupiah': 77500,
      'fotoPath': '',
      'fotoUrl':
          'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=500&auto=format&fit=crop&q=60',
      'catatan': 'Kardus cokelat bersih hasil pilah warga RT 02',
      'petugasNama': 'Agus Santoso',
      'createdAt': '2026-08-14T08:30:00Z',
    },
    {
      'id': 'LBS-002',
      'bankSampahId': 'BS-002',
      'bankSampahNama': 'Bank Sampah Asri Jaya',
      'jenisSampah': 'Anorganik',
      'beratKg': 8.2,
      'nilaiRupiah': 41000,
      'fotoPath': '',
      'fotoUrl':
          'https://images.unsplash.com/photo-1605600659873-d808a13e4d2a?w=500&auto=format&fit=crop&q=60',
      'catatan': 'Botol PET air mineral telah dipadatkan',
      'petugasNama': 'Bambang Irawan',
      'createdAt': '2026-08-13T14:15:00Z',
    },
    {
      'id': 'LBS-003',
      'bankSampahId': 'BS-003',
      'bankSampahNama': 'Bank Sampah Melati Bersih',
      'jenisSampah': 'Organik',
      'beratKg': 12.0,
      'nilaiRupiah': 60000,
      'fotoPath': '',
      'fotoUrl':
          'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=500&auto=format&fit=crop&q=60',
      'catatan': 'Sisa sayuran dan sampah organik dapur terpilah',
      'petugasNama': 'Agus Santoso',
      'createdAt': '2026-08-12T10:00:00Z',
    },
    {
      'id': 'LBS-004',
      'bankSampahId': 'BS-001',
      'bankSampahNama': 'Bank Sampah Berkah Mandiri',
      'jenisSampah': 'Anorganik',
      'beratKg': 4.5,
      'nilaiRupiah': 22500,
      'fotoPath': '',
      'fotoUrl':
          'https://images.unsplash.com/photo-1618477461853-cf6ed80faba5?w=500&auto=format&fit=crop&q=60',
      'catatan': 'Kemasan sachet dan kantong plastik kering',
      'petugasNama': 'Dedi Suhendar',
      'createdAt': '2026-08-11T16:45:00Z',
    },
    {
      'id': 'LBS-005',
      'bankSampahId': 'BS-004',
      'bankSampahNama': 'Bank Sampah Hijau Lestari',
      'jenisSampah': 'Organik',
      'beratKg': 18.0,
      'nilaiRupiah': 90000,
      'fotoPath': '',
      'fotoUrl':
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=500&auto=format&fit=crop&q=60',
      'catatan': 'Dedaunan dan ranting hasil kerja bakti warga',
      'petugasNama': 'Bambang Irawan',
      'createdAt': '2026-08-10T09:20:00Z',
    },
  ];
}
