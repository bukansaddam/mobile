/// Ringkasan nilai form Jaga Tanah yang telah lolos validasi sebelum dikirim ke backend.
class JagaTanahFormDraft {
  final int categoryId;
  final String categoryLabel;
  final int? subCategoryId;
  final String? subCategoryLabel;
  final String title;
  final String description;
  final String province;
  final String regency;
  final String district;
  final String village;
  final String landmarkAddress;
  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final List<String> photoPaths;
  final String aksesLokasi;
  final String kondisiUtama;
  final String penutupLahan;
  final String penggunaanTerlihat;
  final String tingkatPenggunaan;
  final String pemeliharaanFasilitas;
  final String sumberInformasiKondisi;
  final String sumberInformasiPenguasaan;
  final String tandaPenguasaan;
  final String informasiKonflik;

  const JagaTanahFormDraft({
    required this.categoryId,
    required this.categoryLabel,
    this.subCategoryId,
    this.subCategoryLabel,
    required this.title,
    this.description = '',
    required this.province,
    required this.regency,
    required this.district,
    required this.village,
    required this.landmarkAddress,
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
    required this.photoPaths,
    required this.aksesLokasi,
    required this.kondisiUtama,
    required this.penutupLahan,
    required this.penggunaanTerlihat,
    required this.tingkatPenggunaan,
    required this.pemeliharaanFasilitas,
    required this.sumberInformasiKondisi,
    required this.sumberInformasiPenguasaan,
    required this.tandaPenguasaan,
    required this.informasiKonflik,
  });
}
