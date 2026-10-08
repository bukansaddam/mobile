class RondaConstants {
  RondaConstants._();

  // Dropdown Options
  static const List<String> lokasiSampahOptions = [
    'Jalan',
    'Fasum',
    'Pasar',
    'Permukiman',
    'Selokan',
    'SPPG',
  ];

  static const List<String> jenisSampahDominanOptions = [
    'Organik',
    'Anorganik',
  ];

  static const List<String> alasanPengangkutanOptions = [
    'Terlambat dari jadwal',
    'Tidak Diangkut sama sekali',
  ];

  static const List<String> lokasiKejadianUmumOptions = [
    'Jalanan',
    'Fasum',
    'Permukiman',
  ];

  static const List<String> yaTidakOptions = ['Ya', 'Tidak'];

  static const List<String> resikoSelokanOptions = [
    'Banjir',
    'Sarang Nyamuk',
    'Bau Tidak Sedap',
  ];

  static const List<String> resikoJalanRusakOptions = [
    'Kecelakaan',
    'Macet',
    'Berlubang',
  ];

  static const List<String> resikoLampuMatiOptions = [
    'Kecelakaan',
    'Macet',
    'Kriminal',
  ];

  // Wizard Steps
  static const int totalSteps = 4;
  static const List<String> stepTitles = [
    'Sampah',
    'Keamanan',
    'Lingkungan',
    'Tambahan',
  ];
}
