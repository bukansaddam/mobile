class DemografiConstants {
  DemografiConstants._();

  // Tokoh Constants
  static const List<String> jenisKelaminOptions = ['Laki-laki', 'Perempuan'];

  static const List<String> profesiOptions = [
    'Pejabat',
    'Pengusaha',
    'Pendidik',
    'Profesional',
    'Buruh',
  ];

  static const List<String> scopeOptions = ['Nasional', 'Lokal'];

  static const List<String> afiliasiOptions = [
    'Politik',
    'Ormas',
    'Agama',
    'Budaya',
    'Pemuda',
    'Pengusaha',
  ];

  static const String defaultJenisKelamin = 'Laki-laki';
  static const String defaultProfesi = 'Pejabat';
  static const String defaultScope = 'Nasional';
  static const String defaultAfiliasi = 'Politik';

  // Daftar Suku di Indonesia
  static const List<String> sukuIndonesiaOptions = [
    'Aceh',
    'Alor',
    'Ambon / Maluku',
    'Ampana',
    'Asmat',
    'Baduy',
    'Bajau',
    'Bali',
    'Banjar',
    'Batak Angkola',
    'Batak Karo',
    'Batak Mandailing',
    'Batak Pakpak',
    'Batak Simalungun',
    'Batak Toba',
    'Bawean',
    'Belitung',
    'Betawi',
    'Bima',
    'Bugis',
    'Bungku',
    'Buru',
    'Buton',
    'Cirebon',
    'Dampelas',
    'Dani',
    'Dayak',
    'Dompu',
    'Ende',
    'Gayo',
    'Gorontalo',
    'Jawa',
    'Kaili',
    'Kampar',
    'Kangean',
    'Kerinci',
    'Kubu',
    'Lampung',
    'Lom',
    'Madura',
    'Makassar',
    'Manggarai',
    'Mentawai',
    'Minangkabau',
    'Minahasa',
    'Muna',
    'Nias',
    'Osing',
    'Palembang',
    'Papua',
    'Rejang',
    'Rote',
    'Saluan',
    'Sasak',
    'Sekak',
    'Sumbawa',
    'Sunda',
    'Tengger',
    'Ternate',
    'Tidore',
    'Tionghoa',
    'Toraja',
    'Tolaki',
    'Suku Lainnya',
  ];

  // Institusi Constants
  static const List<String> institusiKategoriOptions = [
    'Pemerintahan & Birokrasi',
    'Keamanan & Ketertiban',
    'Kesehatan & Medis',
    'Pendidikan & Akademik',
    'Kebencanaan & Mitigasi',
  ];

  static const String defaultInstitusiKategori = 'Pemerintahan & Birokrasi';

  static const List<String> institusiScopeOptions = [
    'Kelurahan',
    'Kecamatan',
    'Kabupaten/Kota',
    'Provinsi',
    'Nasional',
  ];

  static const String defaultInstitusiScope = 'Kelurahan';

  // Organisasi Constants
  static const List<String> organisasiBidangOptions = [
    'Usaha',
    'Keagamaan',
    'Politik',
    'Kebudayaan',
    'Kepemudaan',
    'Lingkungan',
  ];

  static const String defaultOrganisasiBidang = 'Usaha';
}
