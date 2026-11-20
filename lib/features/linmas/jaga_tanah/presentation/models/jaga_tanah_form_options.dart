/// Daftar opsi dropdown standar lapangan untuk form pelaporan Jaga Tanahku.
class JagaTanahFormOptions {
  JagaTanahFormOptions._();

  // Bagian A: Lokasi dan Data Spasial
  static const List<String> aksesLokasi = [
    'Jalan nasional / provinsi',
    'Jalan kabupaten / kota',
    'Jalan lingkungan',
    'Jalan tanah / setapak',
    'Tidak ada akses jalan',
  ];

  // Bagian B: Kondisi Penggunaan dan Pemanfaatan
  static const List<String> kondisiUtama = [
    'Dimanfaatkan penuh',
    'Sebagian dimanfaatkan',
    'Tidak dimanfaatkan / terlantar',
    'Alih fungsi / penyalahgunaan',
    'Dalam pembangunan',
  ];

  static const List<String> penutupLahan = [
    'Semak belukar',
    'Tanaman perkebunan / pertanian',
    'Bangunan permanen',
    'Bangunan semi permanen',
    'Lahan terbuka / kosong',
    'Hutan / pepohonan',
    'Genangan / rawa',
  ];

  static const List<String> penggunaanTerlihat = [
    'Perkebunan',
    'Pertanian / sawah',
    'Permukiman / hunian',
    'Komersial / usaha',
    'Industri / gudang',
    'Fasilitas umum / sosial',
    'Tambang / galian',
    'Tidak ada penggunaan',
  ];

  static const List<String> tingkatPenggunaan = [
    'Tinggi (> 75% dari luas)',
    'Sedang (25% - 75% dari luas)',
    'Rendah (< 25% dari luas)',
    'Tidak digunakan (0%)',
  ];

  static const List<String> pemeliharaanFasilitas = [
    'Terpelihara baik (ada aktivitas rutin)',
    'Cukup terpelihara',
    'Kurang terpelihara',
    'Tidak terpelihara (tidak ada aktivitas)',
  ];

  static const List<String> sumberInformasiKondisi = [
    'Pengamatan langsung oleh Linmas',
    'Laporan masyarakat sekitar',
    'Informasi perangkat desa / kelurahan',
    'Koordinasi instansi terkait',
  ];

  // Bagian C: Informasi Hak dan Penguasaan
  static const List<String> sumberInformasiPenguasaan = [
    'Papan di lokasi',
    'Keterangan warga sekitar',
    'Keterangan perangkat desa / kelurahan',
    'Penjaga / pengelola lokasi',
    'Tidak diketahui',
  ];

  static const List<String> tandaPenguasaan = [
    'Ada pagar dan papan',
    'Ada papan, tanpa pagar',
    'Ada pagar / patok, tanpa papan',
    'Ada bangunan / pos jaga',
    'Tidak ada tanda penguasaan',
  ];

  static const List<String> informasiKonflik = [
    'Tidak ada informasi',
    'Ada indikasi konflik / sengketa',
    'Sedang dalam proses mediasi',
    'Sengketa terbuka di lapangan',
  ];
}
