// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ronda_laporan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RondaLaporanModel {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'patrol_time') String? get patrolTime;@JsonKey(name: 'waktu_kejadian') String? get waktuKejadian;// Lingkungan
@JsonKey(name: 'sampah_menumpuk') int get sampahMenumpuk;@JsonKey(name: 'selokan_mampet') int get selokanMampet;@JsonKey(name: 'fasilitas_rusak') int get fasilitasRusak;@JsonKey(name: 'kegiatan_mengganggu') int get kegiatanMengganggu;@JsonKey(name: 'potensi_bahaya') int get potensiBahaya;@JsonKey(name: 'jalan_berlubang') int get jalanBerlubang;@JsonKey(name: 'lampu_mati') int get lampuMati;// Keamanan
@JsonKey(name: 'laporan_keamanan') int get laporanKeamanan;@JsonKey(name: 'warga_bertengkar') int get wargaBertengkar;@JsonKey(name: 'tempat_kurang_aman') int get tempatKurangAman;@JsonKey(name: 'kerumunan_tidak_tertib') int get kerumunanTidakTertib;@JsonKey(name: 'perlu_bantuan_petugas') int get perluBantuanPetugas;@JsonKey(name: 'gangguan_kamtibmas') int get gangguanKamtibmas;@JsonKey(name: 'aktivitas_mencurigakan') int get aktivitasMencurigakan;@JsonKey(name: 'kehilangan_lingkungan') int get kehilanganLingkungan;// Sosial
@JsonKey(name: 'warga_butuh_bantuan') int get wargaButuhBantuan;@JsonKey(name: 'kelompok_berselisih') int get kelompokBerselisih;@JsonKey(name: 'keluhan_warga') int get keluhanWarga;@JsonKey(name: 'kejadian_mengganggu_warga') int get kejadianMenggangguWarga;@JsonKey(name: 'perlu_terusan_rt_rw') int get perluTerusanRTRW;@JsonKey(name: 'permasalahan_sosial') int get permasalahanSosial;@JsonKey(name: 'kasus_perzinahan') int get kasusPerzinahan;@JsonKey(name: 'orang_terlantar') int get orangTerlantar;// Detail Sampah
@JsonKey(name: 'ada_sampah_menumpuk') bool get adaSampahMenumpuk;@JsonKey(name: 'waktu_sampah_menumpuk') String? get waktuSampahMenumpuk;@JsonKey(name: 'lokasi_sampah_menumpuk') String? get lokasiSampahMenumpuk;@JsonKey(name: 'jenis_sampah_dominan') String? get jenisSampahDominan;@JsonKey(name: 'pengangkutan_sesuai_jadwal') bool get pengangkutanSesuaiJadwal;@JsonKey(name: 'alasan_pengangkutan') String? get alasanPengangkutan;@JsonKey(name: 'ada_pembakaran_sampah') bool get adaPembakaranSampah;@JsonKey(name: 'waktu_pembakaran') String? get waktuPembakaran;@JsonKey(name: 'lokasi_pembakaran') String? get lokasiPembakaran;@JsonKey(name: 'pembakaran_diberi_tindakan') String? get pembakaranDiberiTindakan;// Detail Keamanan
@JsonKey(name: 'ada_pencurian') bool get adaPencurian;@JsonKey(name: 'waktu_pencurian') String? get waktuPencurian;@JsonKey(name: 'lokasi_pencurian') String? get lokasiPencurian;@JsonKey(name: 'pelaku_pencurian_diketahui') String? get pelakuPencurianDiketahui;@JsonKey(name: 'pencurian_dilaporkan_aparat') String? get pencurianDilaporkanAparat;@JsonKey(name: 'ada_tawuran') bool get adaTawuran;@JsonKey(name: 'waktu_tawuran') String? get waktuTawuran;@JsonKey(name: 'lokasi_tawuran') String? get lokasiTawuran;@JsonKey(name: 'pelaku_tawuran_diketahui') String? get pelakuTawuranDiketahui;@JsonKey(name: 'tawuran_dilaporkan_aparat') String? get tawuranDilaporkanAparat;@JsonKey(name: 'ada_narkoba') bool get adaNarkoba;@JsonKey(name: 'narkoba_dilaporkan_aparat') String? get narkobaDilaporkanAparat;// Detail Lingkungan
@JsonKey(name: 'ada_selokan_tersumbat') bool get adaSelokanTersumbat;@JsonKey(name: 'waktu_selokan_tersumbat') String? get waktuSelokanTersumbat;@JsonKey(name: 'lokasi_selokan_tersumbat') String? get lokasiSelokanTersumbat;@JsonKey(name: 'resiko_selokan_tersumbat') String? get resikoSelokanTersumbat;@JsonKey(name: 'ada_jalan_rusak') bool get adaJalanRusak;@JsonKey(name: 'lokasi_jalan_rusak_gps') String? get lokasiJalanRusakGps;@JsonKey(name: 'latitude_jalan_rusak') double? get latitudeJalanRusak;@JsonKey(name: 'longitude_jalan_rusak') double? get longitudeJalanRusak;@JsonKey(name: 'resiko_jalan_rusak') String? get resikoJalanRusak;@JsonKey(name: 'ada_lampu_mati') bool get adaLampuMati;@JsonKey(name: 'lokasi_lampu_mati_gps') String? get lokasiLampuMatiGps;@JsonKey(name: 'latitude_lampu_mati') double? get latitudeLampuMati;@JsonKey(name: 'longitude_lampu_mati') double? get longitudeLampuMati;@JsonKey(name: 'resiko_lampu_mati') String? get resikoLampuMati;@JsonKey(name: 'keterangan') String get keterangan;@JsonKey(name: 'timestamp') DateTime? get timestamp;
/// Create a copy of RondaLaporanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RondaLaporanModelCopyWith<RondaLaporanModel> get copyWith => _$RondaLaporanModelCopyWithImpl<RondaLaporanModel>(this as RondaLaporanModel, _$identity);

  /// Serializes this RondaLaporanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RondaLaporanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.patrolTime, patrolTime) || other.patrolTime == patrolTime)&&(identical(other.waktuKejadian, waktuKejadian) || other.waktuKejadian == waktuKejadian)&&(identical(other.sampahMenumpuk, sampahMenumpuk) || other.sampahMenumpuk == sampahMenumpuk)&&(identical(other.selokanMampet, selokanMampet) || other.selokanMampet == selokanMampet)&&(identical(other.fasilitasRusak, fasilitasRusak) || other.fasilitasRusak == fasilitasRusak)&&(identical(other.kegiatanMengganggu, kegiatanMengganggu) || other.kegiatanMengganggu == kegiatanMengganggu)&&(identical(other.potensiBahaya, potensiBahaya) || other.potensiBahaya == potensiBahaya)&&(identical(other.jalanBerlubang, jalanBerlubang) || other.jalanBerlubang == jalanBerlubang)&&(identical(other.lampuMati, lampuMati) || other.lampuMati == lampuMati)&&(identical(other.laporanKeamanan, laporanKeamanan) || other.laporanKeamanan == laporanKeamanan)&&(identical(other.wargaBertengkar, wargaBertengkar) || other.wargaBertengkar == wargaBertengkar)&&(identical(other.tempatKurangAman, tempatKurangAman) || other.tempatKurangAman == tempatKurangAman)&&(identical(other.kerumunanTidakTertib, kerumunanTidakTertib) || other.kerumunanTidakTertib == kerumunanTidakTertib)&&(identical(other.perluBantuanPetugas, perluBantuanPetugas) || other.perluBantuanPetugas == perluBantuanPetugas)&&(identical(other.gangguanKamtibmas, gangguanKamtibmas) || other.gangguanKamtibmas == gangguanKamtibmas)&&(identical(other.aktivitasMencurigakan, aktivitasMencurigakan) || other.aktivitasMencurigakan == aktivitasMencurigakan)&&(identical(other.kehilanganLingkungan, kehilanganLingkungan) || other.kehilanganLingkungan == kehilanganLingkungan)&&(identical(other.wargaButuhBantuan, wargaButuhBantuan) || other.wargaButuhBantuan == wargaButuhBantuan)&&(identical(other.kelompokBerselisih, kelompokBerselisih) || other.kelompokBerselisih == kelompokBerselisih)&&(identical(other.keluhanWarga, keluhanWarga) || other.keluhanWarga == keluhanWarga)&&(identical(other.kejadianMenggangguWarga, kejadianMenggangguWarga) || other.kejadianMenggangguWarga == kejadianMenggangguWarga)&&(identical(other.perluTerusanRTRW, perluTerusanRTRW) || other.perluTerusanRTRW == perluTerusanRTRW)&&(identical(other.permasalahanSosial, permasalahanSosial) || other.permasalahanSosial == permasalahanSosial)&&(identical(other.kasusPerzinahan, kasusPerzinahan) || other.kasusPerzinahan == kasusPerzinahan)&&(identical(other.orangTerlantar, orangTerlantar) || other.orangTerlantar == orangTerlantar)&&(identical(other.adaSampahMenumpuk, adaSampahMenumpuk) || other.adaSampahMenumpuk == adaSampahMenumpuk)&&(identical(other.waktuSampahMenumpuk, waktuSampahMenumpuk) || other.waktuSampahMenumpuk == waktuSampahMenumpuk)&&(identical(other.lokasiSampahMenumpuk, lokasiSampahMenumpuk) || other.lokasiSampahMenumpuk == lokasiSampahMenumpuk)&&(identical(other.jenisSampahDominan, jenisSampahDominan) || other.jenisSampahDominan == jenisSampahDominan)&&(identical(other.pengangkutanSesuaiJadwal, pengangkutanSesuaiJadwal) || other.pengangkutanSesuaiJadwal == pengangkutanSesuaiJadwal)&&(identical(other.alasanPengangkutan, alasanPengangkutan) || other.alasanPengangkutan == alasanPengangkutan)&&(identical(other.adaPembakaranSampah, adaPembakaranSampah) || other.adaPembakaranSampah == adaPembakaranSampah)&&(identical(other.waktuPembakaran, waktuPembakaran) || other.waktuPembakaran == waktuPembakaran)&&(identical(other.lokasiPembakaran, lokasiPembakaran) || other.lokasiPembakaran == lokasiPembakaran)&&(identical(other.pembakaranDiberiTindakan, pembakaranDiberiTindakan) || other.pembakaranDiberiTindakan == pembakaranDiberiTindakan)&&(identical(other.adaPencurian, adaPencurian) || other.adaPencurian == adaPencurian)&&(identical(other.waktuPencurian, waktuPencurian) || other.waktuPencurian == waktuPencurian)&&(identical(other.lokasiPencurian, lokasiPencurian) || other.lokasiPencurian == lokasiPencurian)&&(identical(other.pelakuPencurianDiketahui, pelakuPencurianDiketahui) || other.pelakuPencurianDiketahui == pelakuPencurianDiketahui)&&(identical(other.pencurianDilaporkanAparat, pencurianDilaporkanAparat) || other.pencurianDilaporkanAparat == pencurianDilaporkanAparat)&&(identical(other.adaTawuran, adaTawuran) || other.adaTawuran == adaTawuran)&&(identical(other.waktuTawuran, waktuTawuran) || other.waktuTawuran == waktuTawuran)&&(identical(other.lokasiTawuran, lokasiTawuran) || other.lokasiTawuran == lokasiTawuran)&&(identical(other.pelakuTawuranDiketahui, pelakuTawuranDiketahui) || other.pelakuTawuranDiketahui == pelakuTawuranDiketahui)&&(identical(other.tawuranDilaporkanAparat, tawuranDilaporkanAparat) || other.tawuranDilaporkanAparat == tawuranDilaporkanAparat)&&(identical(other.adaNarkoba, adaNarkoba) || other.adaNarkoba == adaNarkoba)&&(identical(other.narkobaDilaporkanAparat, narkobaDilaporkanAparat) || other.narkobaDilaporkanAparat == narkobaDilaporkanAparat)&&(identical(other.adaSelokanTersumbat, adaSelokanTersumbat) || other.adaSelokanTersumbat == adaSelokanTersumbat)&&(identical(other.waktuSelokanTersumbat, waktuSelokanTersumbat) || other.waktuSelokanTersumbat == waktuSelokanTersumbat)&&(identical(other.lokasiSelokanTersumbat, lokasiSelokanTersumbat) || other.lokasiSelokanTersumbat == lokasiSelokanTersumbat)&&(identical(other.resikoSelokanTersumbat, resikoSelokanTersumbat) || other.resikoSelokanTersumbat == resikoSelokanTersumbat)&&(identical(other.adaJalanRusak, adaJalanRusak) || other.adaJalanRusak == adaJalanRusak)&&(identical(other.lokasiJalanRusakGps, lokasiJalanRusakGps) || other.lokasiJalanRusakGps == lokasiJalanRusakGps)&&(identical(other.latitudeJalanRusak, latitudeJalanRusak) || other.latitudeJalanRusak == latitudeJalanRusak)&&(identical(other.longitudeJalanRusak, longitudeJalanRusak) || other.longitudeJalanRusak == longitudeJalanRusak)&&(identical(other.resikoJalanRusak, resikoJalanRusak) || other.resikoJalanRusak == resikoJalanRusak)&&(identical(other.adaLampuMati, adaLampuMati) || other.adaLampuMati == adaLampuMati)&&(identical(other.lokasiLampuMatiGps, lokasiLampuMatiGps) || other.lokasiLampuMatiGps == lokasiLampuMatiGps)&&(identical(other.latitudeLampuMati, latitudeLampuMati) || other.latitudeLampuMati == latitudeLampuMati)&&(identical(other.longitudeLampuMati, longitudeLampuMati) || other.longitudeLampuMati == longitudeLampuMati)&&(identical(other.resikoLampuMati, resikoLampuMati) || other.resikoLampuMati == resikoLampuMati)&&(identical(other.keterangan, keterangan) || other.keterangan == keterangan)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,patrolTime,waktuKejadian,sampahMenumpuk,selokanMampet,fasilitasRusak,kegiatanMengganggu,potensiBahaya,jalanBerlubang,lampuMati,laporanKeamanan,wargaBertengkar,tempatKurangAman,kerumunanTidakTertib,perluBantuanPetugas,gangguanKamtibmas,aktivitasMencurigakan,kehilanganLingkungan,wargaButuhBantuan,kelompokBerselisih,keluhanWarga,kejadianMenggangguWarga,perluTerusanRTRW,permasalahanSosial,kasusPerzinahan,orangTerlantar,adaSampahMenumpuk,waktuSampahMenumpuk,lokasiSampahMenumpuk,jenisSampahDominan,pengangkutanSesuaiJadwal,alasanPengangkutan,adaPembakaranSampah,waktuPembakaran,lokasiPembakaran,pembakaranDiberiTindakan,adaPencurian,waktuPencurian,lokasiPencurian,pelakuPencurianDiketahui,pencurianDilaporkanAparat,adaTawuran,waktuTawuran,lokasiTawuran,pelakuTawuranDiketahui,tawuranDilaporkanAparat,adaNarkoba,narkobaDilaporkanAparat,adaSelokanTersumbat,waktuSelokanTersumbat,lokasiSelokanTersumbat,resikoSelokanTersumbat,adaJalanRusak,lokasiJalanRusakGps,latitudeJalanRusak,longitudeJalanRusak,resikoJalanRusak,adaLampuMati,lokasiLampuMatiGps,latitudeLampuMati,longitudeLampuMati,resikoLampuMati,keterangan,timestamp]);

@override
String toString() {
  return 'RondaLaporanModel(id: $id, patrolTime: $patrolTime, waktuKejadian: $waktuKejadian, sampahMenumpuk: $sampahMenumpuk, selokanMampet: $selokanMampet, fasilitasRusak: $fasilitasRusak, kegiatanMengganggu: $kegiatanMengganggu, potensiBahaya: $potensiBahaya, jalanBerlubang: $jalanBerlubang, lampuMati: $lampuMati, laporanKeamanan: $laporanKeamanan, wargaBertengkar: $wargaBertengkar, tempatKurangAman: $tempatKurangAman, kerumunanTidakTertib: $kerumunanTidakTertib, perluBantuanPetugas: $perluBantuanPetugas, gangguanKamtibmas: $gangguanKamtibmas, aktivitasMencurigakan: $aktivitasMencurigakan, kehilanganLingkungan: $kehilanganLingkungan, wargaButuhBantuan: $wargaButuhBantuan, kelompokBerselisih: $kelompokBerselisih, keluhanWarga: $keluhanWarga, kejadianMenggangguWarga: $kejadianMenggangguWarga, perluTerusanRTRW: $perluTerusanRTRW, permasalahanSosial: $permasalahanSosial, kasusPerzinahan: $kasusPerzinahan, orangTerlantar: $orangTerlantar, adaSampahMenumpuk: $adaSampahMenumpuk, waktuSampahMenumpuk: $waktuSampahMenumpuk, lokasiSampahMenumpuk: $lokasiSampahMenumpuk, jenisSampahDominan: $jenisSampahDominan, pengangkutanSesuaiJadwal: $pengangkutanSesuaiJadwal, alasanPengangkutan: $alasanPengangkutan, adaPembakaranSampah: $adaPembakaranSampah, waktuPembakaran: $waktuPembakaran, lokasiPembakaran: $lokasiPembakaran, pembakaranDiberiTindakan: $pembakaranDiberiTindakan, adaPencurian: $adaPencurian, waktuPencurian: $waktuPencurian, lokasiPencurian: $lokasiPencurian, pelakuPencurianDiketahui: $pelakuPencurianDiketahui, pencurianDilaporkanAparat: $pencurianDilaporkanAparat, adaTawuran: $adaTawuran, waktuTawuran: $waktuTawuran, lokasiTawuran: $lokasiTawuran, pelakuTawuranDiketahui: $pelakuTawuranDiketahui, tawuranDilaporkanAparat: $tawuranDilaporkanAparat, adaNarkoba: $adaNarkoba, narkobaDilaporkanAparat: $narkobaDilaporkanAparat, adaSelokanTersumbat: $adaSelokanTersumbat, waktuSelokanTersumbat: $waktuSelokanTersumbat, lokasiSelokanTersumbat: $lokasiSelokanTersumbat, resikoSelokanTersumbat: $resikoSelokanTersumbat, adaJalanRusak: $adaJalanRusak, lokasiJalanRusakGps: $lokasiJalanRusakGps, latitudeJalanRusak: $latitudeJalanRusak, longitudeJalanRusak: $longitudeJalanRusak, resikoJalanRusak: $resikoJalanRusak, adaLampuMati: $adaLampuMati, lokasiLampuMatiGps: $lokasiLampuMatiGps, latitudeLampuMati: $latitudeLampuMati, longitudeLampuMati: $longitudeLampuMati, resikoLampuMati: $resikoLampuMati, keterangan: $keterangan, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $RondaLaporanModelCopyWith<$Res>  {
  factory $RondaLaporanModelCopyWith(RondaLaporanModel value, $Res Function(RondaLaporanModel) _then) = _$RondaLaporanModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'patrol_time') String? patrolTime,@JsonKey(name: 'waktu_kejadian') String? waktuKejadian,@JsonKey(name: 'sampah_menumpuk') int sampahMenumpuk,@JsonKey(name: 'selokan_mampet') int selokanMampet,@JsonKey(name: 'fasilitas_rusak') int fasilitasRusak,@JsonKey(name: 'kegiatan_mengganggu') int kegiatanMengganggu,@JsonKey(name: 'potensi_bahaya') int potensiBahaya,@JsonKey(name: 'jalan_berlubang') int jalanBerlubang,@JsonKey(name: 'lampu_mati') int lampuMati,@JsonKey(name: 'laporan_keamanan') int laporanKeamanan,@JsonKey(name: 'warga_bertengkar') int wargaBertengkar,@JsonKey(name: 'tempat_kurang_aman') int tempatKurangAman,@JsonKey(name: 'kerumunan_tidak_tertib') int kerumunanTidakTertib,@JsonKey(name: 'perlu_bantuan_petugas') int perluBantuanPetugas,@JsonKey(name: 'gangguan_kamtibmas') int gangguanKamtibmas,@JsonKey(name: 'aktivitas_mencurigakan') int aktivitasMencurigakan,@JsonKey(name: 'kehilangan_lingkungan') int kehilanganLingkungan,@JsonKey(name: 'warga_butuh_bantuan') int wargaButuhBantuan,@JsonKey(name: 'kelompok_berselisih') int kelompokBerselisih,@JsonKey(name: 'keluhan_warga') int keluhanWarga,@JsonKey(name: 'kejadian_mengganggu_warga') int kejadianMenggangguWarga,@JsonKey(name: 'perlu_terusan_rt_rw') int perluTerusanRTRW,@JsonKey(name: 'permasalahan_sosial') int permasalahanSosial,@JsonKey(name: 'kasus_perzinahan') int kasusPerzinahan,@JsonKey(name: 'orang_terlantar') int orangTerlantar,@JsonKey(name: 'ada_sampah_menumpuk') bool adaSampahMenumpuk,@JsonKey(name: 'waktu_sampah_menumpuk') String? waktuSampahMenumpuk,@JsonKey(name: 'lokasi_sampah_menumpuk') String? lokasiSampahMenumpuk,@JsonKey(name: 'jenis_sampah_dominan') String? jenisSampahDominan,@JsonKey(name: 'pengangkutan_sesuai_jadwal') bool pengangkutanSesuaiJadwal,@JsonKey(name: 'alasan_pengangkutan') String? alasanPengangkutan,@JsonKey(name: 'ada_pembakaran_sampah') bool adaPembakaranSampah,@JsonKey(name: 'waktu_pembakaran') String? waktuPembakaran,@JsonKey(name: 'lokasi_pembakaran') String? lokasiPembakaran,@JsonKey(name: 'pembakaran_diberi_tindakan') String? pembakaranDiberiTindakan,@JsonKey(name: 'ada_pencurian') bool adaPencurian,@JsonKey(name: 'waktu_pencurian') String? waktuPencurian,@JsonKey(name: 'lokasi_pencurian') String? lokasiPencurian,@JsonKey(name: 'pelaku_pencurian_diketahui') String? pelakuPencurianDiketahui,@JsonKey(name: 'pencurian_dilaporkan_aparat') String? pencurianDilaporkanAparat,@JsonKey(name: 'ada_tawuran') bool adaTawuran,@JsonKey(name: 'waktu_tawuran') String? waktuTawuran,@JsonKey(name: 'lokasi_tawuran') String? lokasiTawuran,@JsonKey(name: 'pelaku_tawuran_diketahui') String? pelakuTawuranDiketahui,@JsonKey(name: 'tawuran_dilaporkan_aparat') String? tawuranDilaporkanAparat,@JsonKey(name: 'ada_narkoba') bool adaNarkoba,@JsonKey(name: 'narkoba_dilaporkan_aparat') String? narkobaDilaporkanAparat,@JsonKey(name: 'ada_selokan_tersumbat') bool adaSelokanTersumbat,@JsonKey(name: 'waktu_selokan_tersumbat') String? waktuSelokanTersumbat,@JsonKey(name: 'lokasi_selokan_tersumbat') String? lokasiSelokanTersumbat,@JsonKey(name: 'resiko_selokan_tersumbat') String? resikoSelokanTersumbat,@JsonKey(name: 'ada_jalan_rusak') bool adaJalanRusak,@JsonKey(name: 'lokasi_jalan_rusak_gps') String? lokasiJalanRusakGps,@JsonKey(name: 'latitude_jalan_rusak') double? latitudeJalanRusak,@JsonKey(name: 'longitude_jalan_rusak') double? longitudeJalanRusak,@JsonKey(name: 'resiko_jalan_rusak') String? resikoJalanRusak,@JsonKey(name: 'ada_lampu_mati') bool adaLampuMati,@JsonKey(name: 'lokasi_lampu_mati_gps') String? lokasiLampuMatiGps,@JsonKey(name: 'latitude_lampu_mati') double? latitudeLampuMati,@JsonKey(name: 'longitude_lampu_mati') double? longitudeLampuMati,@JsonKey(name: 'resiko_lampu_mati') String? resikoLampuMati,@JsonKey(name: 'keterangan') String keterangan,@JsonKey(name: 'timestamp') DateTime? timestamp
});




}
/// @nodoc
class _$RondaLaporanModelCopyWithImpl<$Res>
    implements $RondaLaporanModelCopyWith<$Res> {
  _$RondaLaporanModelCopyWithImpl(this._self, this._then);

  final RondaLaporanModel _self;
  final $Res Function(RondaLaporanModel) _then;

/// Create a copy of RondaLaporanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? patrolTime = freezed,Object? waktuKejadian = freezed,Object? sampahMenumpuk = null,Object? selokanMampet = null,Object? fasilitasRusak = null,Object? kegiatanMengganggu = null,Object? potensiBahaya = null,Object? jalanBerlubang = null,Object? lampuMati = null,Object? laporanKeamanan = null,Object? wargaBertengkar = null,Object? tempatKurangAman = null,Object? kerumunanTidakTertib = null,Object? perluBantuanPetugas = null,Object? gangguanKamtibmas = null,Object? aktivitasMencurigakan = null,Object? kehilanganLingkungan = null,Object? wargaButuhBantuan = null,Object? kelompokBerselisih = null,Object? keluhanWarga = null,Object? kejadianMenggangguWarga = null,Object? perluTerusanRTRW = null,Object? permasalahanSosial = null,Object? kasusPerzinahan = null,Object? orangTerlantar = null,Object? adaSampahMenumpuk = null,Object? waktuSampahMenumpuk = freezed,Object? lokasiSampahMenumpuk = freezed,Object? jenisSampahDominan = freezed,Object? pengangkutanSesuaiJadwal = null,Object? alasanPengangkutan = freezed,Object? adaPembakaranSampah = null,Object? waktuPembakaran = freezed,Object? lokasiPembakaran = freezed,Object? pembakaranDiberiTindakan = freezed,Object? adaPencurian = null,Object? waktuPencurian = freezed,Object? lokasiPencurian = freezed,Object? pelakuPencurianDiketahui = freezed,Object? pencurianDilaporkanAparat = freezed,Object? adaTawuran = null,Object? waktuTawuran = freezed,Object? lokasiTawuran = freezed,Object? pelakuTawuranDiketahui = freezed,Object? tawuranDilaporkanAparat = freezed,Object? adaNarkoba = null,Object? narkobaDilaporkanAparat = freezed,Object? adaSelokanTersumbat = null,Object? waktuSelokanTersumbat = freezed,Object? lokasiSelokanTersumbat = freezed,Object? resikoSelokanTersumbat = freezed,Object? adaJalanRusak = null,Object? lokasiJalanRusakGps = freezed,Object? latitudeJalanRusak = freezed,Object? longitudeJalanRusak = freezed,Object? resikoJalanRusak = freezed,Object? adaLampuMati = null,Object? lokasiLampuMatiGps = freezed,Object? latitudeLampuMati = freezed,Object? longitudeLampuMati = freezed,Object? resikoLampuMati = freezed,Object? keterangan = null,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,patrolTime: freezed == patrolTime ? _self.patrolTime : patrolTime // ignore: cast_nullable_to_non_nullable
as String?,waktuKejadian: freezed == waktuKejadian ? _self.waktuKejadian : waktuKejadian // ignore: cast_nullable_to_non_nullable
as String?,sampahMenumpuk: null == sampahMenumpuk ? _self.sampahMenumpuk : sampahMenumpuk // ignore: cast_nullable_to_non_nullable
as int,selokanMampet: null == selokanMampet ? _self.selokanMampet : selokanMampet // ignore: cast_nullable_to_non_nullable
as int,fasilitasRusak: null == fasilitasRusak ? _self.fasilitasRusak : fasilitasRusak // ignore: cast_nullable_to_non_nullable
as int,kegiatanMengganggu: null == kegiatanMengganggu ? _self.kegiatanMengganggu : kegiatanMengganggu // ignore: cast_nullable_to_non_nullable
as int,potensiBahaya: null == potensiBahaya ? _self.potensiBahaya : potensiBahaya // ignore: cast_nullable_to_non_nullable
as int,jalanBerlubang: null == jalanBerlubang ? _self.jalanBerlubang : jalanBerlubang // ignore: cast_nullable_to_non_nullable
as int,lampuMati: null == lampuMati ? _self.lampuMati : lampuMati // ignore: cast_nullable_to_non_nullable
as int,laporanKeamanan: null == laporanKeamanan ? _self.laporanKeamanan : laporanKeamanan // ignore: cast_nullable_to_non_nullable
as int,wargaBertengkar: null == wargaBertengkar ? _self.wargaBertengkar : wargaBertengkar // ignore: cast_nullable_to_non_nullable
as int,tempatKurangAman: null == tempatKurangAman ? _self.tempatKurangAman : tempatKurangAman // ignore: cast_nullable_to_non_nullable
as int,kerumunanTidakTertib: null == kerumunanTidakTertib ? _self.kerumunanTidakTertib : kerumunanTidakTertib // ignore: cast_nullable_to_non_nullable
as int,perluBantuanPetugas: null == perluBantuanPetugas ? _self.perluBantuanPetugas : perluBantuanPetugas // ignore: cast_nullable_to_non_nullable
as int,gangguanKamtibmas: null == gangguanKamtibmas ? _self.gangguanKamtibmas : gangguanKamtibmas // ignore: cast_nullable_to_non_nullable
as int,aktivitasMencurigakan: null == aktivitasMencurigakan ? _self.aktivitasMencurigakan : aktivitasMencurigakan // ignore: cast_nullable_to_non_nullable
as int,kehilanganLingkungan: null == kehilanganLingkungan ? _self.kehilanganLingkungan : kehilanganLingkungan // ignore: cast_nullable_to_non_nullable
as int,wargaButuhBantuan: null == wargaButuhBantuan ? _self.wargaButuhBantuan : wargaButuhBantuan // ignore: cast_nullable_to_non_nullable
as int,kelompokBerselisih: null == kelompokBerselisih ? _self.kelompokBerselisih : kelompokBerselisih // ignore: cast_nullable_to_non_nullable
as int,keluhanWarga: null == keluhanWarga ? _self.keluhanWarga : keluhanWarga // ignore: cast_nullable_to_non_nullable
as int,kejadianMenggangguWarga: null == kejadianMenggangguWarga ? _self.kejadianMenggangguWarga : kejadianMenggangguWarga // ignore: cast_nullable_to_non_nullable
as int,perluTerusanRTRW: null == perluTerusanRTRW ? _self.perluTerusanRTRW : perluTerusanRTRW // ignore: cast_nullable_to_non_nullable
as int,permasalahanSosial: null == permasalahanSosial ? _self.permasalahanSosial : permasalahanSosial // ignore: cast_nullable_to_non_nullable
as int,kasusPerzinahan: null == kasusPerzinahan ? _self.kasusPerzinahan : kasusPerzinahan // ignore: cast_nullable_to_non_nullable
as int,orangTerlantar: null == orangTerlantar ? _self.orangTerlantar : orangTerlantar // ignore: cast_nullable_to_non_nullable
as int,adaSampahMenumpuk: null == adaSampahMenumpuk ? _self.adaSampahMenumpuk : adaSampahMenumpuk // ignore: cast_nullable_to_non_nullable
as bool,waktuSampahMenumpuk: freezed == waktuSampahMenumpuk ? _self.waktuSampahMenumpuk : waktuSampahMenumpuk // ignore: cast_nullable_to_non_nullable
as String?,lokasiSampahMenumpuk: freezed == lokasiSampahMenumpuk ? _self.lokasiSampahMenumpuk : lokasiSampahMenumpuk // ignore: cast_nullable_to_non_nullable
as String?,jenisSampahDominan: freezed == jenisSampahDominan ? _self.jenisSampahDominan : jenisSampahDominan // ignore: cast_nullable_to_non_nullable
as String?,pengangkutanSesuaiJadwal: null == pengangkutanSesuaiJadwal ? _self.pengangkutanSesuaiJadwal : pengangkutanSesuaiJadwal // ignore: cast_nullable_to_non_nullable
as bool,alasanPengangkutan: freezed == alasanPengangkutan ? _self.alasanPengangkutan : alasanPengangkutan // ignore: cast_nullable_to_non_nullable
as String?,adaPembakaranSampah: null == adaPembakaranSampah ? _self.adaPembakaranSampah : adaPembakaranSampah // ignore: cast_nullable_to_non_nullable
as bool,waktuPembakaran: freezed == waktuPembakaran ? _self.waktuPembakaran : waktuPembakaran // ignore: cast_nullable_to_non_nullable
as String?,lokasiPembakaran: freezed == lokasiPembakaran ? _self.lokasiPembakaran : lokasiPembakaran // ignore: cast_nullable_to_non_nullable
as String?,pembakaranDiberiTindakan: freezed == pembakaranDiberiTindakan ? _self.pembakaranDiberiTindakan : pembakaranDiberiTindakan // ignore: cast_nullable_to_non_nullable
as String?,adaPencurian: null == adaPencurian ? _self.adaPencurian : adaPencurian // ignore: cast_nullable_to_non_nullable
as bool,waktuPencurian: freezed == waktuPencurian ? _self.waktuPencurian : waktuPencurian // ignore: cast_nullable_to_non_nullable
as String?,lokasiPencurian: freezed == lokasiPencurian ? _self.lokasiPencurian : lokasiPencurian // ignore: cast_nullable_to_non_nullable
as String?,pelakuPencurianDiketahui: freezed == pelakuPencurianDiketahui ? _self.pelakuPencurianDiketahui : pelakuPencurianDiketahui // ignore: cast_nullable_to_non_nullable
as String?,pencurianDilaporkanAparat: freezed == pencurianDilaporkanAparat ? _self.pencurianDilaporkanAparat : pencurianDilaporkanAparat // ignore: cast_nullable_to_non_nullable
as String?,adaTawuran: null == adaTawuran ? _self.adaTawuran : adaTawuran // ignore: cast_nullable_to_non_nullable
as bool,waktuTawuran: freezed == waktuTawuran ? _self.waktuTawuran : waktuTawuran // ignore: cast_nullable_to_non_nullable
as String?,lokasiTawuran: freezed == lokasiTawuran ? _self.lokasiTawuran : lokasiTawuran // ignore: cast_nullable_to_non_nullable
as String?,pelakuTawuranDiketahui: freezed == pelakuTawuranDiketahui ? _self.pelakuTawuranDiketahui : pelakuTawuranDiketahui // ignore: cast_nullable_to_non_nullable
as String?,tawuranDilaporkanAparat: freezed == tawuranDilaporkanAparat ? _self.tawuranDilaporkanAparat : tawuranDilaporkanAparat // ignore: cast_nullable_to_non_nullable
as String?,adaNarkoba: null == adaNarkoba ? _self.adaNarkoba : adaNarkoba // ignore: cast_nullable_to_non_nullable
as bool,narkobaDilaporkanAparat: freezed == narkobaDilaporkanAparat ? _self.narkobaDilaporkanAparat : narkobaDilaporkanAparat // ignore: cast_nullable_to_non_nullable
as String?,adaSelokanTersumbat: null == adaSelokanTersumbat ? _self.adaSelokanTersumbat : adaSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as bool,waktuSelokanTersumbat: freezed == waktuSelokanTersumbat ? _self.waktuSelokanTersumbat : waktuSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as String?,lokasiSelokanTersumbat: freezed == lokasiSelokanTersumbat ? _self.lokasiSelokanTersumbat : lokasiSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as String?,resikoSelokanTersumbat: freezed == resikoSelokanTersumbat ? _self.resikoSelokanTersumbat : resikoSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as String?,adaJalanRusak: null == adaJalanRusak ? _self.adaJalanRusak : adaJalanRusak // ignore: cast_nullable_to_non_nullable
as bool,lokasiJalanRusakGps: freezed == lokasiJalanRusakGps ? _self.lokasiJalanRusakGps : lokasiJalanRusakGps // ignore: cast_nullable_to_non_nullable
as String?,latitudeJalanRusak: freezed == latitudeJalanRusak ? _self.latitudeJalanRusak : latitudeJalanRusak // ignore: cast_nullable_to_non_nullable
as double?,longitudeJalanRusak: freezed == longitudeJalanRusak ? _self.longitudeJalanRusak : longitudeJalanRusak // ignore: cast_nullable_to_non_nullable
as double?,resikoJalanRusak: freezed == resikoJalanRusak ? _self.resikoJalanRusak : resikoJalanRusak // ignore: cast_nullable_to_non_nullable
as String?,adaLampuMati: null == adaLampuMati ? _self.adaLampuMati : adaLampuMati // ignore: cast_nullable_to_non_nullable
as bool,lokasiLampuMatiGps: freezed == lokasiLampuMatiGps ? _self.lokasiLampuMatiGps : lokasiLampuMatiGps // ignore: cast_nullable_to_non_nullable
as String?,latitudeLampuMati: freezed == latitudeLampuMati ? _self.latitudeLampuMati : latitudeLampuMati // ignore: cast_nullable_to_non_nullable
as double?,longitudeLampuMati: freezed == longitudeLampuMati ? _self.longitudeLampuMati : longitudeLampuMati // ignore: cast_nullable_to_non_nullable
as double?,resikoLampuMati: freezed == resikoLampuMati ? _self.resikoLampuMati : resikoLampuMati // ignore: cast_nullable_to_non_nullable
as String?,keterangan: null == keterangan ? _self.keterangan : keterangan // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RondaLaporanModel].
extension RondaLaporanModelPatterns on RondaLaporanModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RondaLaporanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RondaLaporanModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RondaLaporanModel value)  $default,){
final _that = this;
switch (_that) {
case _RondaLaporanModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RondaLaporanModel value)?  $default,){
final _that = this;
switch (_that) {
case _RondaLaporanModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'patrol_time')  String? patrolTime, @JsonKey(name: 'waktu_kejadian')  String? waktuKejadian, @JsonKey(name: 'sampah_menumpuk')  int sampahMenumpuk, @JsonKey(name: 'selokan_mampet')  int selokanMampet, @JsonKey(name: 'fasilitas_rusak')  int fasilitasRusak, @JsonKey(name: 'kegiatan_mengganggu')  int kegiatanMengganggu, @JsonKey(name: 'potensi_bahaya')  int potensiBahaya, @JsonKey(name: 'jalan_berlubang')  int jalanBerlubang, @JsonKey(name: 'lampu_mati')  int lampuMati, @JsonKey(name: 'laporan_keamanan')  int laporanKeamanan, @JsonKey(name: 'warga_bertengkar')  int wargaBertengkar, @JsonKey(name: 'tempat_kurang_aman')  int tempatKurangAman, @JsonKey(name: 'kerumunan_tidak_tertib')  int kerumunanTidakTertib, @JsonKey(name: 'perlu_bantuan_petugas')  int perluBantuanPetugas, @JsonKey(name: 'gangguan_kamtibmas')  int gangguanKamtibmas, @JsonKey(name: 'aktivitas_mencurigakan')  int aktivitasMencurigakan, @JsonKey(name: 'kehilangan_lingkungan')  int kehilanganLingkungan, @JsonKey(name: 'warga_butuh_bantuan')  int wargaButuhBantuan, @JsonKey(name: 'kelompok_berselisih')  int kelompokBerselisih, @JsonKey(name: 'keluhan_warga')  int keluhanWarga, @JsonKey(name: 'kejadian_mengganggu_warga')  int kejadianMenggangguWarga, @JsonKey(name: 'perlu_terusan_rt_rw')  int perluTerusanRTRW, @JsonKey(name: 'permasalahan_sosial')  int permasalahanSosial, @JsonKey(name: 'kasus_perzinahan')  int kasusPerzinahan, @JsonKey(name: 'orang_terlantar')  int orangTerlantar, @JsonKey(name: 'ada_sampah_menumpuk')  bool adaSampahMenumpuk, @JsonKey(name: 'waktu_sampah_menumpuk')  String? waktuSampahMenumpuk, @JsonKey(name: 'lokasi_sampah_menumpuk')  String? lokasiSampahMenumpuk, @JsonKey(name: 'jenis_sampah_dominan')  String? jenisSampahDominan, @JsonKey(name: 'pengangkutan_sesuai_jadwal')  bool pengangkutanSesuaiJadwal, @JsonKey(name: 'alasan_pengangkutan')  String? alasanPengangkutan, @JsonKey(name: 'ada_pembakaran_sampah')  bool adaPembakaranSampah, @JsonKey(name: 'waktu_pembakaran')  String? waktuPembakaran, @JsonKey(name: 'lokasi_pembakaran')  String? lokasiPembakaran, @JsonKey(name: 'pembakaran_diberi_tindakan')  String? pembakaranDiberiTindakan, @JsonKey(name: 'ada_pencurian')  bool adaPencurian, @JsonKey(name: 'waktu_pencurian')  String? waktuPencurian, @JsonKey(name: 'lokasi_pencurian')  String? lokasiPencurian, @JsonKey(name: 'pelaku_pencurian_diketahui')  String? pelakuPencurianDiketahui, @JsonKey(name: 'pencurian_dilaporkan_aparat')  String? pencurianDilaporkanAparat, @JsonKey(name: 'ada_tawuran')  bool adaTawuran, @JsonKey(name: 'waktu_tawuran')  String? waktuTawuran, @JsonKey(name: 'lokasi_tawuran')  String? lokasiTawuran, @JsonKey(name: 'pelaku_tawuran_diketahui')  String? pelakuTawuranDiketahui, @JsonKey(name: 'tawuran_dilaporkan_aparat')  String? tawuranDilaporkanAparat, @JsonKey(name: 'ada_narkoba')  bool adaNarkoba, @JsonKey(name: 'narkoba_dilaporkan_aparat')  String? narkobaDilaporkanAparat, @JsonKey(name: 'ada_selokan_tersumbat')  bool adaSelokanTersumbat, @JsonKey(name: 'waktu_selokan_tersumbat')  String? waktuSelokanTersumbat, @JsonKey(name: 'lokasi_selokan_tersumbat')  String? lokasiSelokanTersumbat, @JsonKey(name: 'resiko_selokan_tersumbat')  String? resikoSelokanTersumbat, @JsonKey(name: 'ada_jalan_rusak')  bool adaJalanRusak, @JsonKey(name: 'lokasi_jalan_rusak_gps')  String? lokasiJalanRusakGps, @JsonKey(name: 'latitude_jalan_rusak')  double? latitudeJalanRusak, @JsonKey(name: 'longitude_jalan_rusak')  double? longitudeJalanRusak, @JsonKey(name: 'resiko_jalan_rusak')  String? resikoJalanRusak, @JsonKey(name: 'ada_lampu_mati')  bool adaLampuMati, @JsonKey(name: 'lokasi_lampu_mati_gps')  String? lokasiLampuMatiGps, @JsonKey(name: 'latitude_lampu_mati')  double? latitudeLampuMati, @JsonKey(name: 'longitude_lampu_mati')  double? longitudeLampuMati, @JsonKey(name: 'resiko_lampu_mati')  String? resikoLampuMati, @JsonKey(name: 'keterangan')  String keterangan, @JsonKey(name: 'timestamp')  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RondaLaporanModel() when $default != null:
return $default(_that.id,_that.patrolTime,_that.waktuKejadian,_that.sampahMenumpuk,_that.selokanMampet,_that.fasilitasRusak,_that.kegiatanMengganggu,_that.potensiBahaya,_that.jalanBerlubang,_that.lampuMati,_that.laporanKeamanan,_that.wargaBertengkar,_that.tempatKurangAman,_that.kerumunanTidakTertib,_that.perluBantuanPetugas,_that.gangguanKamtibmas,_that.aktivitasMencurigakan,_that.kehilanganLingkungan,_that.wargaButuhBantuan,_that.kelompokBerselisih,_that.keluhanWarga,_that.kejadianMenggangguWarga,_that.perluTerusanRTRW,_that.permasalahanSosial,_that.kasusPerzinahan,_that.orangTerlantar,_that.adaSampahMenumpuk,_that.waktuSampahMenumpuk,_that.lokasiSampahMenumpuk,_that.jenisSampahDominan,_that.pengangkutanSesuaiJadwal,_that.alasanPengangkutan,_that.adaPembakaranSampah,_that.waktuPembakaran,_that.lokasiPembakaran,_that.pembakaranDiberiTindakan,_that.adaPencurian,_that.waktuPencurian,_that.lokasiPencurian,_that.pelakuPencurianDiketahui,_that.pencurianDilaporkanAparat,_that.adaTawuran,_that.waktuTawuran,_that.lokasiTawuran,_that.pelakuTawuranDiketahui,_that.tawuranDilaporkanAparat,_that.adaNarkoba,_that.narkobaDilaporkanAparat,_that.adaSelokanTersumbat,_that.waktuSelokanTersumbat,_that.lokasiSelokanTersumbat,_that.resikoSelokanTersumbat,_that.adaJalanRusak,_that.lokasiJalanRusakGps,_that.latitudeJalanRusak,_that.longitudeJalanRusak,_that.resikoJalanRusak,_that.adaLampuMati,_that.lokasiLampuMatiGps,_that.latitudeLampuMati,_that.longitudeLampuMati,_that.resikoLampuMati,_that.keterangan,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'patrol_time')  String? patrolTime, @JsonKey(name: 'waktu_kejadian')  String? waktuKejadian, @JsonKey(name: 'sampah_menumpuk')  int sampahMenumpuk, @JsonKey(name: 'selokan_mampet')  int selokanMampet, @JsonKey(name: 'fasilitas_rusak')  int fasilitasRusak, @JsonKey(name: 'kegiatan_mengganggu')  int kegiatanMengganggu, @JsonKey(name: 'potensi_bahaya')  int potensiBahaya, @JsonKey(name: 'jalan_berlubang')  int jalanBerlubang, @JsonKey(name: 'lampu_mati')  int lampuMati, @JsonKey(name: 'laporan_keamanan')  int laporanKeamanan, @JsonKey(name: 'warga_bertengkar')  int wargaBertengkar, @JsonKey(name: 'tempat_kurang_aman')  int tempatKurangAman, @JsonKey(name: 'kerumunan_tidak_tertib')  int kerumunanTidakTertib, @JsonKey(name: 'perlu_bantuan_petugas')  int perluBantuanPetugas, @JsonKey(name: 'gangguan_kamtibmas')  int gangguanKamtibmas, @JsonKey(name: 'aktivitas_mencurigakan')  int aktivitasMencurigakan, @JsonKey(name: 'kehilangan_lingkungan')  int kehilanganLingkungan, @JsonKey(name: 'warga_butuh_bantuan')  int wargaButuhBantuan, @JsonKey(name: 'kelompok_berselisih')  int kelompokBerselisih, @JsonKey(name: 'keluhan_warga')  int keluhanWarga, @JsonKey(name: 'kejadian_mengganggu_warga')  int kejadianMenggangguWarga, @JsonKey(name: 'perlu_terusan_rt_rw')  int perluTerusanRTRW, @JsonKey(name: 'permasalahan_sosial')  int permasalahanSosial, @JsonKey(name: 'kasus_perzinahan')  int kasusPerzinahan, @JsonKey(name: 'orang_terlantar')  int orangTerlantar, @JsonKey(name: 'ada_sampah_menumpuk')  bool adaSampahMenumpuk, @JsonKey(name: 'waktu_sampah_menumpuk')  String? waktuSampahMenumpuk, @JsonKey(name: 'lokasi_sampah_menumpuk')  String? lokasiSampahMenumpuk, @JsonKey(name: 'jenis_sampah_dominan')  String? jenisSampahDominan, @JsonKey(name: 'pengangkutan_sesuai_jadwal')  bool pengangkutanSesuaiJadwal, @JsonKey(name: 'alasan_pengangkutan')  String? alasanPengangkutan, @JsonKey(name: 'ada_pembakaran_sampah')  bool adaPembakaranSampah, @JsonKey(name: 'waktu_pembakaran')  String? waktuPembakaran, @JsonKey(name: 'lokasi_pembakaran')  String? lokasiPembakaran, @JsonKey(name: 'pembakaran_diberi_tindakan')  String? pembakaranDiberiTindakan, @JsonKey(name: 'ada_pencurian')  bool adaPencurian, @JsonKey(name: 'waktu_pencurian')  String? waktuPencurian, @JsonKey(name: 'lokasi_pencurian')  String? lokasiPencurian, @JsonKey(name: 'pelaku_pencurian_diketahui')  String? pelakuPencurianDiketahui, @JsonKey(name: 'pencurian_dilaporkan_aparat')  String? pencurianDilaporkanAparat, @JsonKey(name: 'ada_tawuran')  bool adaTawuran, @JsonKey(name: 'waktu_tawuran')  String? waktuTawuran, @JsonKey(name: 'lokasi_tawuran')  String? lokasiTawuran, @JsonKey(name: 'pelaku_tawuran_diketahui')  String? pelakuTawuranDiketahui, @JsonKey(name: 'tawuran_dilaporkan_aparat')  String? tawuranDilaporkanAparat, @JsonKey(name: 'ada_narkoba')  bool adaNarkoba, @JsonKey(name: 'narkoba_dilaporkan_aparat')  String? narkobaDilaporkanAparat, @JsonKey(name: 'ada_selokan_tersumbat')  bool adaSelokanTersumbat, @JsonKey(name: 'waktu_selokan_tersumbat')  String? waktuSelokanTersumbat, @JsonKey(name: 'lokasi_selokan_tersumbat')  String? lokasiSelokanTersumbat, @JsonKey(name: 'resiko_selokan_tersumbat')  String? resikoSelokanTersumbat, @JsonKey(name: 'ada_jalan_rusak')  bool adaJalanRusak, @JsonKey(name: 'lokasi_jalan_rusak_gps')  String? lokasiJalanRusakGps, @JsonKey(name: 'latitude_jalan_rusak')  double? latitudeJalanRusak, @JsonKey(name: 'longitude_jalan_rusak')  double? longitudeJalanRusak, @JsonKey(name: 'resiko_jalan_rusak')  String? resikoJalanRusak, @JsonKey(name: 'ada_lampu_mati')  bool adaLampuMati, @JsonKey(name: 'lokasi_lampu_mati_gps')  String? lokasiLampuMatiGps, @JsonKey(name: 'latitude_lampu_mati')  double? latitudeLampuMati, @JsonKey(name: 'longitude_lampu_mati')  double? longitudeLampuMati, @JsonKey(name: 'resiko_lampu_mati')  String? resikoLampuMati, @JsonKey(name: 'keterangan')  String keterangan, @JsonKey(name: 'timestamp')  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _RondaLaporanModel():
return $default(_that.id,_that.patrolTime,_that.waktuKejadian,_that.sampahMenumpuk,_that.selokanMampet,_that.fasilitasRusak,_that.kegiatanMengganggu,_that.potensiBahaya,_that.jalanBerlubang,_that.lampuMati,_that.laporanKeamanan,_that.wargaBertengkar,_that.tempatKurangAman,_that.kerumunanTidakTertib,_that.perluBantuanPetugas,_that.gangguanKamtibmas,_that.aktivitasMencurigakan,_that.kehilanganLingkungan,_that.wargaButuhBantuan,_that.kelompokBerselisih,_that.keluhanWarga,_that.kejadianMenggangguWarga,_that.perluTerusanRTRW,_that.permasalahanSosial,_that.kasusPerzinahan,_that.orangTerlantar,_that.adaSampahMenumpuk,_that.waktuSampahMenumpuk,_that.lokasiSampahMenumpuk,_that.jenisSampahDominan,_that.pengangkutanSesuaiJadwal,_that.alasanPengangkutan,_that.adaPembakaranSampah,_that.waktuPembakaran,_that.lokasiPembakaran,_that.pembakaranDiberiTindakan,_that.adaPencurian,_that.waktuPencurian,_that.lokasiPencurian,_that.pelakuPencurianDiketahui,_that.pencurianDilaporkanAparat,_that.adaTawuran,_that.waktuTawuran,_that.lokasiTawuran,_that.pelakuTawuranDiketahui,_that.tawuranDilaporkanAparat,_that.adaNarkoba,_that.narkobaDilaporkanAparat,_that.adaSelokanTersumbat,_that.waktuSelokanTersumbat,_that.lokasiSelokanTersumbat,_that.resikoSelokanTersumbat,_that.adaJalanRusak,_that.lokasiJalanRusakGps,_that.latitudeJalanRusak,_that.longitudeJalanRusak,_that.resikoJalanRusak,_that.adaLampuMati,_that.lokasiLampuMatiGps,_that.latitudeLampuMati,_that.longitudeLampuMati,_that.resikoLampuMati,_that.keterangan,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'patrol_time')  String? patrolTime, @JsonKey(name: 'waktu_kejadian')  String? waktuKejadian, @JsonKey(name: 'sampah_menumpuk')  int sampahMenumpuk, @JsonKey(name: 'selokan_mampet')  int selokanMampet, @JsonKey(name: 'fasilitas_rusak')  int fasilitasRusak, @JsonKey(name: 'kegiatan_mengganggu')  int kegiatanMengganggu, @JsonKey(name: 'potensi_bahaya')  int potensiBahaya, @JsonKey(name: 'jalan_berlubang')  int jalanBerlubang, @JsonKey(name: 'lampu_mati')  int lampuMati, @JsonKey(name: 'laporan_keamanan')  int laporanKeamanan, @JsonKey(name: 'warga_bertengkar')  int wargaBertengkar, @JsonKey(name: 'tempat_kurang_aman')  int tempatKurangAman, @JsonKey(name: 'kerumunan_tidak_tertib')  int kerumunanTidakTertib, @JsonKey(name: 'perlu_bantuan_petugas')  int perluBantuanPetugas, @JsonKey(name: 'gangguan_kamtibmas')  int gangguanKamtibmas, @JsonKey(name: 'aktivitas_mencurigakan')  int aktivitasMencurigakan, @JsonKey(name: 'kehilangan_lingkungan')  int kehilanganLingkungan, @JsonKey(name: 'warga_butuh_bantuan')  int wargaButuhBantuan, @JsonKey(name: 'kelompok_berselisih')  int kelompokBerselisih, @JsonKey(name: 'keluhan_warga')  int keluhanWarga, @JsonKey(name: 'kejadian_mengganggu_warga')  int kejadianMenggangguWarga, @JsonKey(name: 'perlu_terusan_rt_rw')  int perluTerusanRTRW, @JsonKey(name: 'permasalahan_sosial')  int permasalahanSosial, @JsonKey(name: 'kasus_perzinahan')  int kasusPerzinahan, @JsonKey(name: 'orang_terlantar')  int orangTerlantar, @JsonKey(name: 'ada_sampah_menumpuk')  bool adaSampahMenumpuk, @JsonKey(name: 'waktu_sampah_menumpuk')  String? waktuSampahMenumpuk, @JsonKey(name: 'lokasi_sampah_menumpuk')  String? lokasiSampahMenumpuk, @JsonKey(name: 'jenis_sampah_dominan')  String? jenisSampahDominan, @JsonKey(name: 'pengangkutan_sesuai_jadwal')  bool pengangkutanSesuaiJadwal, @JsonKey(name: 'alasan_pengangkutan')  String? alasanPengangkutan, @JsonKey(name: 'ada_pembakaran_sampah')  bool adaPembakaranSampah, @JsonKey(name: 'waktu_pembakaran')  String? waktuPembakaran, @JsonKey(name: 'lokasi_pembakaran')  String? lokasiPembakaran, @JsonKey(name: 'pembakaran_diberi_tindakan')  String? pembakaranDiberiTindakan, @JsonKey(name: 'ada_pencurian')  bool adaPencurian, @JsonKey(name: 'waktu_pencurian')  String? waktuPencurian, @JsonKey(name: 'lokasi_pencurian')  String? lokasiPencurian, @JsonKey(name: 'pelaku_pencurian_diketahui')  String? pelakuPencurianDiketahui, @JsonKey(name: 'pencurian_dilaporkan_aparat')  String? pencurianDilaporkanAparat, @JsonKey(name: 'ada_tawuran')  bool adaTawuran, @JsonKey(name: 'waktu_tawuran')  String? waktuTawuran, @JsonKey(name: 'lokasi_tawuran')  String? lokasiTawuran, @JsonKey(name: 'pelaku_tawuran_diketahui')  String? pelakuTawuranDiketahui, @JsonKey(name: 'tawuran_dilaporkan_aparat')  String? tawuranDilaporkanAparat, @JsonKey(name: 'ada_narkoba')  bool adaNarkoba, @JsonKey(name: 'narkoba_dilaporkan_aparat')  String? narkobaDilaporkanAparat, @JsonKey(name: 'ada_selokan_tersumbat')  bool adaSelokanTersumbat, @JsonKey(name: 'waktu_selokan_tersumbat')  String? waktuSelokanTersumbat, @JsonKey(name: 'lokasi_selokan_tersumbat')  String? lokasiSelokanTersumbat, @JsonKey(name: 'resiko_selokan_tersumbat')  String? resikoSelokanTersumbat, @JsonKey(name: 'ada_jalan_rusak')  bool adaJalanRusak, @JsonKey(name: 'lokasi_jalan_rusak_gps')  String? lokasiJalanRusakGps, @JsonKey(name: 'latitude_jalan_rusak')  double? latitudeJalanRusak, @JsonKey(name: 'longitude_jalan_rusak')  double? longitudeJalanRusak, @JsonKey(name: 'resiko_jalan_rusak')  String? resikoJalanRusak, @JsonKey(name: 'ada_lampu_mati')  bool adaLampuMati, @JsonKey(name: 'lokasi_lampu_mati_gps')  String? lokasiLampuMatiGps, @JsonKey(name: 'latitude_lampu_mati')  double? latitudeLampuMati, @JsonKey(name: 'longitude_lampu_mati')  double? longitudeLampuMati, @JsonKey(name: 'resiko_lampu_mati')  String? resikoLampuMati, @JsonKey(name: 'keterangan')  String keterangan, @JsonKey(name: 'timestamp')  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _RondaLaporanModel() when $default != null:
return $default(_that.id,_that.patrolTime,_that.waktuKejadian,_that.sampahMenumpuk,_that.selokanMampet,_that.fasilitasRusak,_that.kegiatanMengganggu,_that.potensiBahaya,_that.jalanBerlubang,_that.lampuMati,_that.laporanKeamanan,_that.wargaBertengkar,_that.tempatKurangAman,_that.kerumunanTidakTertib,_that.perluBantuanPetugas,_that.gangguanKamtibmas,_that.aktivitasMencurigakan,_that.kehilanganLingkungan,_that.wargaButuhBantuan,_that.kelompokBerselisih,_that.keluhanWarga,_that.kejadianMenggangguWarga,_that.perluTerusanRTRW,_that.permasalahanSosial,_that.kasusPerzinahan,_that.orangTerlantar,_that.adaSampahMenumpuk,_that.waktuSampahMenumpuk,_that.lokasiSampahMenumpuk,_that.jenisSampahDominan,_that.pengangkutanSesuaiJadwal,_that.alasanPengangkutan,_that.adaPembakaranSampah,_that.waktuPembakaran,_that.lokasiPembakaran,_that.pembakaranDiberiTindakan,_that.adaPencurian,_that.waktuPencurian,_that.lokasiPencurian,_that.pelakuPencurianDiketahui,_that.pencurianDilaporkanAparat,_that.adaTawuran,_that.waktuTawuran,_that.lokasiTawuran,_that.pelakuTawuranDiketahui,_that.tawuranDilaporkanAparat,_that.adaNarkoba,_that.narkobaDilaporkanAparat,_that.adaSelokanTersumbat,_that.waktuSelokanTersumbat,_that.lokasiSelokanTersumbat,_that.resikoSelokanTersumbat,_that.adaJalanRusak,_that.lokasiJalanRusakGps,_that.latitudeJalanRusak,_that.longitudeJalanRusak,_that.resikoJalanRusak,_that.adaLampuMati,_that.lokasiLampuMatiGps,_that.latitudeLampuMati,_that.longitudeLampuMati,_that.resikoLampuMati,_that.keterangan,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RondaLaporanModel extends RondaLaporanModel {
  const _RondaLaporanModel({@JsonKey(name: 'id') this.id, @JsonKey(name: 'patrol_time') this.patrolTime, @JsonKey(name: 'waktu_kejadian') this.waktuKejadian, @JsonKey(name: 'sampah_menumpuk') this.sampahMenumpuk = 1, @JsonKey(name: 'selokan_mampet') this.selokanMampet = 1, @JsonKey(name: 'fasilitas_rusak') this.fasilitasRusak = 1, @JsonKey(name: 'kegiatan_mengganggu') this.kegiatanMengganggu = 1, @JsonKey(name: 'potensi_bahaya') this.potensiBahaya = 1, @JsonKey(name: 'jalan_berlubang') this.jalanBerlubang = 1, @JsonKey(name: 'lampu_mati') this.lampuMati = 1, @JsonKey(name: 'laporan_keamanan') this.laporanKeamanan = 1, @JsonKey(name: 'warga_bertengkar') this.wargaBertengkar = 1, @JsonKey(name: 'tempat_kurang_aman') this.tempatKurangAman = 1, @JsonKey(name: 'kerumunan_tidak_tertib') this.kerumunanTidakTertib = 1, @JsonKey(name: 'perlu_bantuan_petugas') this.perluBantuanPetugas = 1, @JsonKey(name: 'gangguan_kamtibmas') this.gangguanKamtibmas = 1, @JsonKey(name: 'aktivitas_mencurigakan') this.aktivitasMencurigakan = 1, @JsonKey(name: 'kehilangan_lingkungan') this.kehilanganLingkungan = 1, @JsonKey(name: 'warga_butuh_bantuan') this.wargaButuhBantuan = 1, @JsonKey(name: 'kelompok_berselisih') this.kelompokBerselisih = 1, @JsonKey(name: 'keluhan_warga') this.keluhanWarga = 1, @JsonKey(name: 'kejadian_mengganggu_warga') this.kejadianMenggangguWarga = 1, @JsonKey(name: 'perlu_terusan_rt_rw') this.perluTerusanRTRW = 1, @JsonKey(name: 'permasalahan_sosial') this.permasalahanSosial = 1, @JsonKey(name: 'kasus_perzinahan') this.kasusPerzinahan = 1, @JsonKey(name: 'orang_terlantar') this.orangTerlantar = 1, @JsonKey(name: 'ada_sampah_menumpuk') this.adaSampahMenumpuk = false, @JsonKey(name: 'waktu_sampah_menumpuk') this.waktuSampahMenumpuk, @JsonKey(name: 'lokasi_sampah_menumpuk') this.lokasiSampahMenumpuk, @JsonKey(name: 'jenis_sampah_dominan') this.jenisSampahDominan, @JsonKey(name: 'pengangkutan_sesuai_jadwal') this.pengangkutanSesuaiJadwal = true, @JsonKey(name: 'alasan_pengangkutan') this.alasanPengangkutan, @JsonKey(name: 'ada_pembakaran_sampah') this.adaPembakaranSampah = false, @JsonKey(name: 'waktu_pembakaran') this.waktuPembakaran, @JsonKey(name: 'lokasi_pembakaran') this.lokasiPembakaran, @JsonKey(name: 'pembakaran_diberi_tindakan') this.pembakaranDiberiTindakan, @JsonKey(name: 'ada_pencurian') this.adaPencurian = false, @JsonKey(name: 'waktu_pencurian') this.waktuPencurian, @JsonKey(name: 'lokasi_pencurian') this.lokasiPencurian, @JsonKey(name: 'pelaku_pencurian_diketahui') this.pelakuPencurianDiketahui, @JsonKey(name: 'pencurian_dilaporkan_aparat') this.pencurianDilaporkanAparat, @JsonKey(name: 'ada_tawuran') this.adaTawuran = false, @JsonKey(name: 'waktu_tawuran') this.waktuTawuran, @JsonKey(name: 'lokasi_tawuran') this.lokasiTawuran, @JsonKey(name: 'pelaku_tawuran_diketahui') this.pelakuTawuranDiketahui, @JsonKey(name: 'tawuran_dilaporkan_aparat') this.tawuranDilaporkanAparat, @JsonKey(name: 'ada_narkoba') this.adaNarkoba = false, @JsonKey(name: 'narkoba_dilaporkan_aparat') this.narkobaDilaporkanAparat, @JsonKey(name: 'ada_selokan_tersumbat') this.adaSelokanTersumbat = false, @JsonKey(name: 'waktu_selokan_tersumbat') this.waktuSelokanTersumbat, @JsonKey(name: 'lokasi_selokan_tersumbat') this.lokasiSelokanTersumbat, @JsonKey(name: 'resiko_selokan_tersumbat') this.resikoSelokanTersumbat, @JsonKey(name: 'ada_jalan_rusak') this.adaJalanRusak = false, @JsonKey(name: 'lokasi_jalan_rusak_gps') this.lokasiJalanRusakGps, @JsonKey(name: 'latitude_jalan_rusak') this.latitudeJalanRusak, @JsonKey(name: 'longitude_jalan_rusak') this.longitudeJalanRusak, @JsonKey(name: 'resiko_jalan_rusak') this.resikoJalanRusak, @JsonKey(name: 'ada_lampu_mati') this.adaLampuMati = false, @JsonKey(name: 'lokasi_lampu_mati_gps') this.lokasiLampuMatiGps, @JsonKey(name: 'latitude_lampu_mati') this.latitudeLampuMati, @JsonKey(name: 'longitude_lampu_mati') this.longitudeLampuMati, @JsonKey(name: 'resiko_lampu_mati') this.resikoLampuMati, @JsonKey(name: 'keterangan') this.keterangan = '', @JsonKey(name: 'timestamp') this.timestamp}): super._();
  factory _RondaLaporanModel.fromJson(Map<String, dynamic> json) => _$RondaLaporanModelFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'patrol_time') final  String? patrolTime;
@override@JsonKey(name: 'waktu_kejadian') final  String? waktuKejadian;
// Lingkungan
@override@JsonKey(name: 'sampah_menumpuk') final  int sampahMenumpuk;
@override@JsonKey(name: 'selokan_mampet') final  int selokanMampet;
@override@JsonKey(name: 'fasilitas_rusak') final  int fasilitasRusak;
@override@JsonKey(name: 'kegiatan_mengganggu') final  int kegiatanMengganggu;
@override@JsonKey(name: 'potensi_bahaya') final  int potensiBahaya;
@override@JsonKey(name: 'jalan_berlubang') final  int jalanBerlubang;
@override@JsonKey(name: 'lampu_mati') final  int lampuMati;
// Keamanan
@override@JsonKey(name: 'laporan_keamanan') final  int laporanKeamanan;
@override@JsonKey(name: 'warga_bertengkar') final  int wargaBertengkar;
@override@JsonKey(name: 'tempat_kurang_aman') final  int tempatKurangAman;
@override@JsonKey(name: 'kerumunan_tidak_tertib') final  int kerumunanTidakTertib;
@override@JsonKey(name: 'perlu_bantuan_petugas') final  int perluBantuanPetugas;
@override@JsonKey(name: 'gangguan_kamtibmas') final  int gangguanKamtibmas;
@override@JsonKey(name: 'aktivitas_mencurigakan') final  int aktivitasMencurigakan;
@override@JsonKey(name: 'kehilangan_lingkungan') final  int kehilanganLingkungan;
// Sosial
@override@JsonKey(name: 'warga_butuh_bantuan') final  int wargaButuhBantuan;
@override@JsonKey(name: 'kelompok_berselisih') final  int kelompokBerselisih;
@override@JsonKey(name: 'keluhan_warga') final  int keluhanWarga;
@override@JsonKey(name: 'kejadian_mengganggu_warga') final  int kejadianMenggangguWarga;
@override@JsonKey(name: 'perlu_terusan_rt_rw') final  int perluTerusanRTRW;
@override@JsonKey(name: 'permasalahan_sosial') final  int permasalahanSosial;
@override@JsonKey(name: 'kasus_perzinahan') final  int kasusPerzinahan;
@override@JsonKey(name: 'orang_terlantar') final  int orangTerlantar;
// Detail Sampah
@override@JsonKey(name: 'ada_sampah_menumpuk') final  bool adaSampahMenumpuk;
@override@JsonKey(name: 'waktu_sampah_menumpuk') final  String? waktuSampahMenumpuk;
@override@JsonKey(name: 'lokasi_sampah_menumpuk') final  String? lokasiSampahMenumpuk;
@override@JsonKey(name: 'jenis_sampah_dominan') final  String? jenisSampahDominan;
@override@JsonKey(name: 'pengangkutan_sesuai_jadwal') final  bool pengangkutanSesuaiJadwal;
@override@JsonKey(name: 'alasan_pengangkutan') final  String? alasanPengangkutan;
@override@JsonKey(name: 'ada_pembakaran_sampah') final  bool adaPembakaranSampah;
@override@JsonKey(name: 'waktu_pembakaran') final  String? waktuPembakaran;
@override@JsonKey(name: 'lokasi_pembakaran') final  String? lokasiPembakaran;
@override@JsonKey(name: 'pembakaran_diberi_tindakan') final  String? pembakaranDiberiTindakan;
// Detail Keamanan
@override@JsonKey(name: 'ada_pencurian') final  bool adaPencurian;
@override@JsonKey(name: 'waktu_pencurian') final  String? waktuPencurian;
@override@JsonKey(name: 'lokasi_pencurian') final  String? lokasiPencurian;
@override@JsonKey(name: 'pelaku_pencurian_diketahui') final  String? pelakuPencurianDiketahui;
@override@JsonKey(name: 'pencurian_dilaporkan_aparat') final  String? pencurianDilaporkanAparat;
@override@JsonKey(name: 'ada_tawuran') final  bool adaTawuran;
@override@JsonKey(name: 'waktu_tawuran') final  String? waktuTawuran;
@override@JsonKey(name: 'lokasi_tawuran') final  String? lokasiTawuran;
@override@JsonKey(name: 'pelaku_tawuran_diketahui') final  String? pelakuTawuranDiketahui;
@override@JsonKey(name: 'tawuran_dilaporkan_aparat') final  String? tawuranDilaporkanAparat;
@override@JsonKey(name: 'ada_narkoba') final  bool adaNarkoba;
@override@JsonKey(name: 'narkoba_dilaporkan_aparat') final  String? narkobaDilaporkanAparat;
// Detail Lingkungan
@override@JsonKey(name: 'ada_selokan_tersumbat') final  bool adaSelokanTersumbat;
@override@JsonKey(name: 'waktu_selokan_tersumbat') final  String? waktuSelokanTersumbat;
@override@JsonKey(name: 'lokasi_selokan_tersumbat') final  String? lokasiSelokanTersumbat;
@override@JsonKey(name: 'resiko_selokan_tersumbat') final  String? resikoSelokanTersumbat;
@override@JsonKey(name: 'ada_jalan_rusak') final  bool adaJalanRusak;
@override@JsonKey(name: 'lokasi_jalan_rusak_gps') final  String? lokasiJalanRusakGps;
@override@JsonKey(name: 'latitude_jalan_rusak') final  double? latitudeJalanRusak;
@override@JsonKey(name: 'longitude_jalan_rusak') final  double? longitudeJalanRusak;
@override@JsonKey(name: 'resiko_jalan_rusak') final  String? resikoJalanRusak;
@override@JsonKey(name: 'ada_lampu_mati') final  bool adaLampuMati;
@override@JsonKey(name: 'lokasi_lampu_mati_gps') final  String? lokasiLampuMatiGps;
@override@JsonKey(name: 'latitude_lampu_mati') final  double? latitudeLampuMati;
@override@JsonKey(name: 'longitude_lampu_mati') final  double? longitudeLampuMati;
@override@JsonKey(name: 'resiko_lampu_mati') final  String? resikoLampuMati;
@override@JsonKey(name: 'keterangan') final  String keterangan;
@override@JsonKey(name: 'timestamp') final  DateTime? timestamp;

/// Create a copy of RondaLaporanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RondaLaporanModelCopyWith<_RondaLaporanModel> get copyWith => __$RondaLaporanModelCopyWithImpl<_RondaLaporanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RondaLaporanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RondaLaporanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.patrolTime, patrolTime) || other.patrolTime == patrolTime)&&(identical(other.waktuKejadian, waktuKejadian) || other.waktuKejadian == waktuKejadian)&&(identical(other.sampahMenumpuk, sampahMenumpuk) || other.sampahMenumpuk == sampahMenumpuk)&&(identical(other.selokanMampet, selokanMampet) || other.selokanMampet == selokanMampet)&&(identical(other.fasilitasRusak, fasilitasRusak) || other.fasilitasRusak == fasilitasRusak)&&(identical(other.kegiatanMengganggu, kegiatanMengganggu) || other.kegiatanMengganggu == kegiatanMengganggu)&&(identical(other.potensiBahaya, potensiBahaya) || other.potensiBahaya == potensiBahaya)&&(identical(other.jalanBerlubang, jalanBerlubang) || other.jalanBerlubang == jalanBerlubang)&&(identical(other.lampuMati, lampuMati) || other.lampuMati == lampuMati)&&(identical(other.laporanKeamanan, laporanKeamanan) || other.laporanKeamanan == laporanKeamanan)&&(identical(other.wargaBertengkar, wargaBertengkar) || other.wargaBertengkar == wargaBertengkar)&&(identical(other.tempatKurangAman, tempatKurangAman) || other.tempatKurangAman == tempatKurangAman)&&(identical(other.kerumunanTidakTertib, kerumunanTidakTertib) || other.kerumunanTidakTertib == kerumunanTidakTertib)&&(identical(other.perluBantuanPetugas, perluBantuanPetugas) || other.perluBantuanPetugas == perluBantuanPetugas)&&(identical(other.gangguanKamtibmas, gangguanKamtibmas) || other.gangguanKamtibmas == gangguanKamtibmas)&&(identical(other.aktivitasMencurigakan, aktivitasMencurigakan) || other.aktivitasMencurigakan == aktivitasMencurigakan)&&(identical(other.kehilanganLingkungan, kehilanganLingkungan) || other.kehilanganLingkungan == kehilanganLingkungan)&&(identical(other.wargaButuhBantuan, wargaButuhBantuan) || other.wargaButuhBantuan == wargaButuhBantuan)&&(identical(other.kelompokBerselisih, kelompokBerselisih) || other.kelompokBerselisih == kelompokBerselisih)&&(identical(other.keluhanWarga, keluhanWarga) || other.keluhanWarga == keluhanWarga)&&(identical(other.kejadianMenggangguWarga, kejadianMenggangguWarga) || other.kejadianMenggangguWarga == kejadianMenggangguWarga)&&(identical(other.perluTerusanRTRW, perluTerusanRTRW) || other.perluTerusanRTRW == perluTerusanRTRW)&&(identical(other.permasalahanSosial, permasalahanSosial) || other.permasalahanSosial == permasalahanSosial)&&(identical(other.kasusPerzinahan, kasusPerzinahan) || other.kasusPerzinahan == kasusPerzinahan)&&(identical(other.orangTerlantar, orangTerlantar) || other.orangTerlantar == orangTerlantar)&&(identical(other.adaSampahMenumpuk, adaSampahMenumpuk) || other.adaSampahMenumpuk == adaSampahMenumpuk)&&(identical(other.waktuSampahMenumpuk, waktuSampahMenumpuk) || other.waktuSampahMenumpuk == waktuSampahMenumpuk)&&(identical(other.lokasiSampahMenumpuk, lokasiSampahMenumpuk) || other.lokasiSampahMenumpuk == lokasiSampahMenumpuk)&&(identical(other.jenisSampahDominan, jenisSampahDominan) || other.jenisSampahDominan == jenisSampahDominan)&&(identical(other.pengangkutanSesuaiJadwal, pengangkutanSesuaiJadwal) || other.pengangkutanSesuaiJadwal == pengangkutanSesuaiJadwal)&&(identical(other.alasanPengangkutan, alasanPengangkutan) || other.alasanPengangkutan == alasanPengangkutan)&&(identical(other.adaPembakaranSampah, adaPembakaranSampah) || other.adaPembakaranSampah == adaPembakaranSampah)&&(identical(other.waktuPembakaran, waktuPembakaran) || other.waktuPembakaran == waktuPembakaran)&&(identical(other.lokasiPembakaran, lokasiPembakaran) || other.lokasiPembakaran == lokasiPembakaran)&&(identical(other.pembakaranDiberiTindakan, pembakaranDiberiTindakan) || other.pembakaranDiberiTindakan == pembakaranDiberiTindakan)&&(identical(other.adaPencurian, adaPencurian) || other.adaPencurian == adaPencurian)&&(identical(other.waktuPencurian, waktuPencurian) || other.waktuPencurian == waktuPencurian)&&(identical(other.lokasiPencurian, lokasiPencurian) || other.lokasiPencurian == lokasiPencurian)&&(identical(other.pelakuPencurianDiketahui, pelakuPencurianDiketahui) || other.pelakuPencurianDiketahui == pelakuPencurianDiketahui)&&(identical(other.pencurianDilaporkanAparat, pencurianDilaporkanAparat) || other.pencurianDilaporkanAparat == pencurianDilaporkanAparat)&&(identical(other.adaTawuran, adaTawuran) || other.adaTawuran == adaTawuran)&&(identical(other.waktuTawuran, waktuTawuran) || other.waktuTawuran == waktuTawuran)&&(identical(other.lokasiTawuran, lokasiTawuran) || other.lokasiTawuran == lokasiTawuran)&&(identical(other.pelakuTawuranDiketahui, pelakuTawuranDiketahui) || other.pelakuTawuranDiketahui == pelakuTawuranDiketahui)&&(identical(other.tawuranDilaporkanAparat, tawuranDilaporkanAparat) || other.tawuranDilaporkanAparat == tawuranDilaporkanAparat)&&(identical(other.adaNarkoba, adaNarkoba) || other.adaNarkoba == adaNarkoba)&&(identical(other.narkobaDilaporkanAparat, narkobaDilaporkanAparat) || other.narkobaDilaporkanAparat == narkobaDilaporkanAparat)&&(identical(other.adaSelokanTersumbat, adaSelokanTersumbat) || other.adaSelokanTersumbat == adaSelokanTersumbat)&&(identical(other.waktuSelokanTersumbat, waktuSelokanTersumbat) || other.waktuSelokanTersumbat == waktuSelokanTersumbat)&&(identical(other.lokasiSelokanTersumbat, lokasiSelokanTersumbat) || other.lokasiSelokanTersumbat == lokasiSelokanTersumbat)&&(identical(other.resikoSelokanTersumbat, resikoSelokanTersumbat) || other.resikoSelokanTersumbat == resikoSelokanTersumbat)&&(identical(other.adaJalanRusak, adaJalanRusak) || other.adaJalanRusak == adaJalanRusak)&&(identical(other.lokasiJalanRusakGps, lokasiJalanRusakGps) || other.lokasiJalanRusakGps == lokasiJalanRusakGps)&&(identical(other.latitudeJalanRusak, latitudeJalanRusak) || other.latitudeJalanRusak == latitudeJalanRusak)&&(identical(other.longitudeJalanRusak, longitudeJalanRusak) || other.longitudeJalanRusak == longitudeJalanRusak)&&(identical(other.resikoJalanRusak, resikoJalanRusak) || other.resikoJalanRusak == resikoJalanRusak)&&(identical(other.adaLampuMati, adaLampuMati) || other.adaLampuMati == adaLampuMati)&&(identical(other.lokasiLampuMatiGps, lokasiLampuMatiGps) || other.lokasiLampuMatiGps == lokasiLampuMatiGps)&&(identical(other.latitudeLampuMati, latitudeLampuMati) || other.latitudeLampuMati == latitudeLampuMati)&&(identical(other.longitudeLampuMati, longitudeLampuMati) || other.longitudeLampuMati == longitudeLampuMati)&&(identical(other.resikoLampuMati, resikoLampuMati) || other.resikoLampuMati == resikoLampuMati)&&(identical(other.keterangan, keterangan) || other.keterangan == keterangan)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,patrolTime,waktuKejadian,sampahMenumpuk,selokanMampet,fasilitasRusak,kegiatanMengganggu,potensiBahaya,jalanBerlubang,lampuMati,laporanKeamanan,wargaBertengkar,tempatKurangAman,kerumunanTidakTertib,perluBantuanPetugas,gangguanKamtibmas,aktivitasMencurigakan,kehilanganLingkungan,wargaButuhBantuan,kelompokBerselisih,keluhanWarga,kejadianMenggangguWarga,perluTerusanRTRW,permasalahanSosial,kasusPerzinahan,orangTerlantar,adaSampahMenumpuk,waktuSampahMenumpuk,lokasiSampahMenumpuk,jenisSampahDominan,pengangkutanSesuaiJadwal,alasanPengangkutan,adaPembakaranSampah,waktuPembakaran,lokasiPembakaran,pembakaranDiberiTindakan,adaPencurian,waktuPencurian,lokasiPencurian,pelakuPencurianDiketahui,pencurianDilaporkanAparat,adaTawuran,waktuTawuran,lokasiTawuran,pelakuTawuranDiketahui,tawuranDilaporkanAparat,adaNarkoba,narkobaDilaporkanAparat,adaSelokanTersumbat,waktuSelokanTersumbat,lokasiSelokanTersumbat,resikoSelokanTersumbat,adaJalanRusak,lokasiJalanRusakGps,latitudeJalanRusak,longitudeJalanRusak,resikoJalanRusak,adaLampuMati,lokasiLampuMatiGps,latitudeLampuMati,longitudeLampuMati,resikoLampuMati,keterangan,timestamp]);

@override
String toString() {
  return 'RondaLaporanModel(id: $id, patrolTime: $patrolTime, waktuKejadian: $waktuKejadian, sampahMenumpuk: $sampahMenumpuk, selokanMampet: $selokanMampet, fasilitasRusak: $fasilitasRusak, kegiatanMengganggu: $kegiatanMengganggu, potensiBahaya: $potensiBahaya, jalanBerlubang: $jalanBerlubang, lampuMati: $lampuMati, laporanKeamanan: $laporanKeamanan, wargaBertengkar: $wargaBertengkar, tempatKurangAman: $tempatKurangAman, kerumunanTidakTertib: $kerumunanTidakTertib, perluBantuanPetugas: $perluBantuanPetugas, gangguanKamtibmas: $gangguanKamtibmas, aktivitasMencurigakan: $aktivitasMencurigakan, kehilanganLingkungan: $kehilanganLingkungan, wargaButuhBantuan: $wargaButuhBantuan, kelompokBerselisih: $kelompokBerselisih, keluhanWarga: $keluhanWarga, kejadianMenggangguWarga: $kejadianMenggangguWarga, perluTerusanRTRW: $perluTerusanRTRW, permasalahanSosial: $permasalahanSosial, kasusPerzinahan: $kasusPerzinahan, orangTerlantar: $orangTerlantar, adaSampahMenumpuk: $adaSampahMenumpuk, waktuSampahMenumpuk: $waktuSampahMenumpuk, lokasiSampahMenumpuk: $lokasiSampahMenumpuk, jenisSampahDominan: $jenisSampahDominan, pengangkutanSesuaiJadwal: $pengangkutanSesuaiJadwal, alasanPengangkutan: $alasanPengangkutan, adaPembakaranSampah: $adaPembakaranSampah, waktuPembakaran: $waktuPembakaran, lokasiPembakaran: $lokasiPembakaran, pembakaranDiberiTindakan: $pembakaranDiberiTindakan, adaPencurian: $adaPencurian, waktuPencurian: $waktuPencurian, lokasiPencurian: $lokasiPencurian, pelakuPencurianDiketahui: $pelakuPencurianDiketahui, pencurianDilaporkanAparat: $pencurianDilaporkanAparat, adaTawuran: $adaTawuran, waktuTawuran: $waktuTawuran, lokasiTawuran: $lokasiTawuran, pelakuTawuranDiketahui: $pelakuTawuranDiketahui, tawuranDilaporkanAparat: $tawuranDilaporkanAparat, adaNarkoba: $adaNarkoba, narkobaDilaporkanAparat: $narkobaDilaporkanAparat, adaSelokanTersumbat: $adaSelokanTersumbat, waktuSelokanTersumbat: $waktuSelokanTersumbat, lokasiSelokanTersumbat: $lokasiSelokanTersumbat, resikoSelokanTersumbat: $resikoSelokanTersumbat, adaJalanRusak: $adaJalanRusak, lokasiJalanRusakGps: $lokasiJalanRusakGps, latitudeJalanRusak: $latitudeJalanRusak, longitudeJalanRusak: $longitudeJalanRusak, resikoJalanRusak: $resikoJalanRusak, adaLampuMati: $adaLampuMati, lokasiLampuMatiGps: $lokasiLampuMatiGps, latitudeLampuMati: $latitudeLampuMati, longitudeLampuMati: $longitudeLampuMati, resikoLampuMati: $resikoLampuMati, keterangan: $keterangan, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$RondaLaporanModelCopyWith<$Res> implements $RondaLaporanModelCopyWith<$Res> {
  factory _$RondaLaporanModelCopyWith(_RondaLaporanModel value, $Res Function(_RondaLaporanModel) _then) = __$RondaLaporanModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'patrol_time') String? patrolTime,@JsonKey(name: 'waktu_kejadian') String? waktuKejadian,@JsonKey(name: 'sampah_menumpuk') int sampahMenumpuk,@JsonKey(name: 'selokan_mampet') int selokanMampet,@JsonKey(name: 'fasilitas_rusak') int fasilitasRusak,@JsonKey(name: 'kegiatan_mengganggu') int kegiatanMengganggu,@JsonKey(name: 'potensi_bahaya') int potensiBahaya,@JsonKey(name: 'jalan_berlubang') int jalanBerlubang,@JsonKey(name: 'lampu_mati') int lampuMati,@JsonKey(name: 'laporan_keamanan') int laporanKeamanan,@JsonKey(name: 'warga_bertengkar') int wargaBertengkar,@JsonKey(name: 'tempat_kurang_aman') int tempatKurangAman,@JsonKey(name: 'kerumunan_tidak_tertib') int kerumunanTidakTertib,@JsonKey(name: 'perlu_bantuan_petugas') int perluBantuanPetugas,@JsonKey(name: 'gangguan_kamtibmas') int gangguanKamtibmas,@JsonKey(name: 'aktivitas_mencurigakan') int aktivitasMencurigakan,@JsonKey(name: 'kehilangan_lingkungan') int kehilanganLingkungan,@JsonKey(name: 'warga_butuh_bantuan') int wargaButuhBantuan,@JsonKey(name: 'kelompok_berselisih') int kelompokBerselisih,@JsonKey(name: 'keluhan_warga') int keluhanWarga,@JsonKey(name: 'kejadian_mengganggu_warga') int kejadianMenggangguWarga,@JsonKey(name: 'perlu_terusan_rt_rw') int perluTerusanRTRW,@JsonKey(name: 'permasalahan_sosial') int permasalahanSosial,@JsonKey(name: 'kasus_perzinahan') int kasusPerzinahan,@JsonKey(name: 'orang_terlantar') int orangTerlantar,@JsonKey(name: 'ada_sampah_menumpuk') bool adaSampahMenumpuk,@JsonKey(name: 'waktu_sampah_menumpuk') String? waktuSampahMenumpuk,@JsonKey(name: 'lokasi_sampah_menumpuk') String? lokasiSampahMenumpuk,@JsonKey(name: 'jenis_sampah_dominan') String? jenisSampahDominan,@JsonKey(name: 'pengangkutan_sesuai_jadwal') bool pengangkutanSesuaiJadwal,@JsonKey(name: 'alasan_pengangkutan') String? alasanPengangkutan,@JsonKey(name: 'ada_pembakaran_sampah') bool adaPembakaranSampah,@JsonKey(name: 'waktu_pembakaran') String? waktuPembakaran,@JsonKey(name: 'lokasi_pembakaran') String? lokasiPembakaran,@JsonKey(name: 'pembakaran_diberi_tindakan') String? pembakaranDiberiTindakan,@JsonKey(name: 'ada_pencurian') bool adaPencurian,@JsonKey(name: 'waktu_pencurian') String? waktuPencurian,@JsonKey(name: 'lokasi_pencurian') String? lokasiPencurian,@JsonKey(name: 'pelaku_pencurian_diketahui') String? pelakuPencurianDiketahui,@JsonKey(name: 'pencurian_dilaporkan_aparat') String? pencurianDilaporkanAparat,@JsonKey(name: 'ada_tawuran') bool adaTawuran,@JsonKey(name: 'waktu_tawuran') String? waktuTawuran,@JsonKey(name: 'lokasi_tawuran') String? lokasiTawuran,@JsonKey(name: 'pelaku_tawuran_diketahui') String? pelakuTawuranDiketahui,@JsonKey(name: 'tawuran_dilaporkan_aparat') String? tawuranDilaporkanAparat,@JsonKey(name: 'ada_narkoba') bool adaNarkoba,@JsonKey(name: 'narkoba_dilaporkan_aparat') String? narkobaDilaporkanAparat,@JsonKey(name: 'ada_selokan_tersumbat') bool adaSelokanTersumbat,@JsonKey(name: 'waktu_selokan_tersumbat') String? waktuSelokanTersumbat,@JsonKey(name: 'lokasi_selokan_tersumbat') String? lokasiSelokanTersumbat,@JsonKey(name: 'resiko_selokan_tersumbat') String? resikoSelokanTersumbat,@JsonKey(name: 'ada_jalan_rusak') bool adaJalanRusak,@JsonKey(name: 'lokasi_jalan_rusak_gps') String? lokasiJalanRusakGps,@JsonKey(name: 'latitude_jalan_rusak') double? latitudeJalanRusak,@JsonKey(name: 'longitude_jalan_rusak') double? longitudeJalanRusak,@JsonKey(name: 'resiko_jalan_rusak') String? resikoJalanRusak,@JsonKey(name: 'ada_lampu_mati') bool adaLampuMati,@JsonKey(name: 'lokasi_lampu_mati_gps') String? lokasiLampuMatiGps,@JsonKey(name: 'latitude_lampu_mati') double? latitudeLampuMati,@JsonKey(name: 'longitude_lampu_mati') double? longitudeLampuMati,@JsonKey(name: 'resiko_lampu_mati') String? resikoLampuMati,@JsonKey(name: 'keterangan') String keterangan,@JsonKey(name: 'timestamp') DateTime? timestamp
});




}
/// @nodoc
class __$RondaLaporanModelCopyWithImpl<$Res>
    implements _$RondaLaporanModelCopyWith<$Res> {
  __$RondaLaporanModelCopyWithImpl(this._self, this._then);

  final _RondaLaporanModel _self;
  final $Res Function(_RondaLaporanModel) _then;

/// Create a copy of RondaLaporanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? patrolTime = freezed,Object? waktuKejadian = freezed,Object? sampahMenumpuk = null,Object? selokanMampet = null,Object? fasilitasRusak = null,Object? kegiatanMengganggu = null,Object? potensiBahaya = null,Object? jalanBerlubang = null,Object? lampuMati = null,Object? laporanKeamanan = null,Object? wargaBertengkar = null,Object? tempatKurangAman = null,Object? kerumunanTidakTertib = null,Object? perluBantuanPetugas = null,Object? gangguanKamtibmas = null,Object? aktivitasMencurigakan = null,Object? kehilanganLingkungan = null,Object? wargaButuhBantuan = null,Object? kelompokBerselisih = null,Object? keluhanWarga = null,Object? kejadianMenggangguWarga = null,Object? perluTerusanRTRW = null,Object? permasalahanSosial = null,Object? kasusPerzinahan = null,Object? orangTerlantar = null,Object? adaSampahMenumpuk = null,Object? waktuSampahMenumpuk = freezed,Object? lokasiSampahMenumpuk = freezed,Object? jenisSampahDominan = freezed,Object? pengangkutanSesuaiJadwal = null,Object? alasanPengangkutan = freezed,Object? adaPembakaranSampah = null,Object? waktuPembakaran = freezed,Object? lokasiPembakaran = freezed,Object? pembakaranDiberiTindakan = freezed,Object? adaPencurian = null,Object? waktuPencurian = freezed,Object? lokasiPencurian = freezed,Object? pelakuPencurianDiketahui = freezed,Object? pencurianDilaporkanAparat = freezed,Object? adaTawuran = null,Object? waktuTawuran = freezed,Object? lokasiTawuran = freezed,Object? pelakuTawuranDiketahui = freezed,Object? tawuranDilaporkanAparat = freezed,Object? adaNarkoba = null,Object? narkobaDilaporkanAparat = freezed,Object? adaSelokanTersumbat = null,Object? waktuSelokanTersumbat = freezed,Object? lokasiSelokanTersumbat = freezed,Object? resikoSelokanTersumbat = freezed,Object? adaJalanRusak = null,Object? lokasiJalanRusakGps = freezed,Object? latitudeJalanRusak = freezed,Object? longitudeJalanRusak = freezed,Object? resikoJalanRusak = freezed,Object? adaLampuMati = null,Object? lokasiLampuMatiGps = freezed,Object? latitudeLampuMati = freezed,Object? longitudeLampuMati = freezed,Object? resikoLampuMati = freezed,Object? keterangan = null,Object? timestamp = freezed,}) {
  return _then(_RondaLaporanModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,patrolTime: freezed == patrolTime ? _self.patrolTime : patrolTime // ignore: cast_nullable_to_non_nullable
as String?,waktuKejadian: freezed == waktuKejadian ? _self.waktuKejadian : waktuKejadian // ignore: cast_nullable_to_non_nullable
as String?,sampahMenumpuk: null == sampahMenumpuk ? _self.sampahMenumpuk : sampahMenumpuk // ignore: cast_nullable_to_non_nullable
as int,selokanMampet: null == selokanMampet ? _self.selokanMampet : selokanMampet // ignore: cast_nullable_to_non_nullable
as int,fasilitasRusak: null == fasilitasRusak ? _self.fasilitasRusak : fasilitasRusak // ignore: cast_nullable_to_non_nullable
as int,kegiatanMengganggu: null == kegiatanMengganggu ? _self.kegiatanMengganggu : kegiatanMengganggu // ignore: cast_nullable_to_non_nullable
as int,potensiBahaya: null == potensiBahaya ? _self.potensiBahaya : potensiBahaya // ignore: cast_nullable_to_non_nullable
as int,jalanBerlubang: null == jalanBerlubang ? _self.jalanBerlubang : jalanBerlubang // ignore: cast_nullable_to_non_nullable
as int,lampuMati: null == lampuMati ? _self.lampuMati : lampuMati // ignore: cast_nullable_to_non_nullable
as int,laporanKeamanan: null == laporanKeamanan ? _self.laporanKeamanan : laporanKeamanan // ignore: cast_nullable_to_non_nullable
as int,wargaBertengkar: null == wargaBertengkar ? _self.wargaBertengkar : wargaBertengkar // ignore: cast_nullable_to_non_nullable
as int,tempatKurangAman: null == tempatKurangAman ? _self.tempatKurangAman : tempatKurangAman // ignore: cast_nullable_to_non_nullable
as int,kerumunanTidakTertib: null == kerumunanTidakTertib ? _self.kerumunanTidakTertib : kerumunanTidakTertib // ignore: cast_nullable_to_non_nullable
as int,perluBantuanPetugas: null == perluBantuanPetugas ? _self.perluBantuanPetugas : perluBantuanPetugas // ignore: cast_nullable_to_non_nullable
as int,gangguanKamtibmas: null == gangguanKamtibmas ? _self.gangguanKamtibmas : gangguanKamtibmas // ignore: cast_nullable_to_non_nullable
as int,aktivitasMencurigakan: null == aktivitasMencurigakan ? _self.aktivitasMencurigakan : aktivitasMencurigakan // ignore: cast_nullable_to_non_nullable
as int,kehilanganLingkungan: null == kehilanganLingkungan ? _self.kehilanganLingkungan : kehilanganLingkungan // ignore: cast_nullable_to_non_nullable
as int,wargaButuhBantuan: null == wargaButuhBantuan ? _self.wargaButuhBantuan : wargaButuhBantuan // ignore: cast_nullable_to_non_nullable
as int,kelompokBerselisih: null == kelompokBerselisih ? _self.kelompokBerselisih : kelompokBerselisih // ignore: cast_nullable_to_non_nullable
as int,keluhanWarga: null == keluhanWarga ? _self.keluhanWarga : keluhanWarga // ignore: cast_nullable_to_non_nullable
as int,kejadianMenggangguWarga: null == kejadianMenggangguWarga ? _self.kejadianMenggangguWarga : kejadianMenggangguWarga // ignore: cast_nullable_to_non_nullable
as int,perluTerusanRTRW: null == perluTerusanRTRW ? _self.perluTerusanRTRW : perluTerusanRTRW // ignore: cast_nullable_to_non_nullable
as int,permasalahanSosial: null == permasalahanSosial ? _self.permasalahanSosial : permasalahanSosial // ignore: cast_nullable_to_non_nullable
as int,kasusPerzinahan: null == kasusPerzinahan ? _self.kasusPerzinahan : kasusPerzinahan // ignore: cast_nullable_to_non_nullable
as int,orangTerlantar: null == orangTerlantar ? _self.orangTerlantar : orangTerlantar // ignore: cast_nullable_to_non_nullable
as int,adaSampahMenumpuk: null == adaSampahMenumpuk ? _self.adaSampahMenumpuk : adaSampahMenumpuk // ignore: cast_nullable_to_non_nullable
as bool,waktuSampahMenumpuk: freezed == waktuSampahMenumpuk ? _self.waktuSampahMenumpuk : waktuSampahMenumpuk // ignore: cast_nullable_to_non_nullable
as String?,lokasiSampahMenumpuk: freezed == lokasiSampahMenumpuk ? _self.lokasiSampahMenumpuk : lokasiSampahMenumpuk // ignore: cast_nullable_to_non_nullable
as String?,jenisSampahDominan: freezed == jenisSampahDominan ? _self.jenisSampahDominan : jenisSampahDominan // ignore: cast_nullable_to_non_nullable
as String?,pengangkutanSesuaiJadwal: null == pengangkutanSesuaiJadwal ? _self.pengangkutanSesuaiJadwal : pengangkutanSesuaiJadwal // ignore: cast_nullable_to_non_nullable
as bool,alasanPengangkutan: freezed == alasanPengangkutan ? _self.alasanPengangkutan : alasanPengangkutan // ignore: cast_nullable_to_non_nullable
as String?,adaPembakaranSampah: null == adaPembakaranSampah ? _self.adaPembakaranSampah : adaPembakaranSampah // ignore: cast_nullable_to_non_nullable
as bool,waktuPembakaran: freezed == waktuPembakaran ? _self.waktuPembakaran : waktuPembakaran // ignore: cast_nullable_to_non_nullable
as String?,lokasiPembakaran: freezed == lokasiPembakaran ? _self.lokasiPembakaran : lokasiPembakaran // ignore: cast_nullable_to_non_nullable
as String?,pembakaranDiberiTindakan: freezed == pembakaranDiberiTindakan ? _self.pembakaranDiberiTindakan : pembakaranDiberiTindakan // ignore: cast_nullable_to_non_nullable
as String?,adaPencurian: null == adaPencurian ? _self.adaPencurian : adaPencurian // ignore: cast_nullable_to_non_nullable
as bool,waktuPencurian: freezed == waktuPencurian ? _self.waktuPencurian : waktuPencurian // ignore: cast_nullable_to_non_nullable
as String?,lokasiPencurian: freezed == lokasiPencurian ? _self.lokasiPencurian : lokasiPencurian // ignore: cast_nullable_to_non_nullable
as String?,pelakuPencurianDiketahui: freezed == pelakuPencurianDiketahui ? _self.pelakuPencurianDiketahui : pelakuPencurianDiketahui // ignore: cast_nullable_to_non_nullable
as String?,pencurianDilaporkanAparat: freezed == pencurianDilaporkanAparat ? _self.pencurianDilaporkanAparat : pencurianDilaporkanAparat // ignore: cast_nullable_to_non_nullable
as String?,adaTawuran: null == adaTawuran ? _self.adaTawuran : adaTawuran // ignore: cast_nullable_to_non_nullable
as bool,waktuTawuran: freezed == waktuTawuran ? _self.waktuTawuran : waktuTawuran // ignore: cast_nullable_to_non_nullable
as String?,lokasiTawuran: freezed == lokasiTawuran ? _self.lokasiTawuran : lokasiTawuran // ignore: cast_nullable_to_non_nullable
as String?,pelakuTawuranDiketahui: freezed == pelakuTawuranDiketahui ? _self.pelakuTawuranDiketahui : pelakuTawuranDiketahui // ignore: cast_nullable_to_non_nullable
as String?,tawuranDilaporkanAparat: freezed == tawuranDilaporkanAparat ? _self.tawuranDilaporkanAparat : tawuranDilaporkanAparat // ignore: cast_nullable_to_non_nullable
as String?,adaNarkoba: null == adaNarkoba ? _self.adaNarkoba : adaNarkoba // ignore: cast_nullable_to_non_nullable
as bool,narkobaDilaporkanAparat: freezed == narkobaDilaporkanAparat ? _self.narkobaDilaporkanAparat : narkobaDilaporkanAparat // ignore: cast_nullable_to_non_nullable
as String?,adaSelokanTersumbat: null == adaSelokanTersumbat ? _self.adaSelokanTersumbat : adaSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as bool,waktuSelokanTersumbat: freezed == waktuSelokanTersumbat ? _self.waktuSelokanTersumbat : waktuSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as String?,lokasiSelokanTersumbat: freezed == lokasiSelokanTersumbat ? _self.lokasiSelokanTersumbat : lokasiSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as String?,resikoSelokanTersumbat: freezed == resikoSelokanTersumbat ? _self.resikoSelokanTersumbat : resikoSelokanTersumbat // ignore: cast_nullable_to_non_nullable
as String?,adaJalanRusak: null == adaJalanRusak ? _self.adaJalanRusak : adaJalanRusak // ignore: cast_nullable_to_non_nullable
as bool,lokasiJalanRusakGps: freezed == lokasiJalanRusakGps ? _self.lokasiJalanRusakGps : lokasiJalanRusakGps // ignore: cast_nullable_to_non_nullable
as String?,latitudeJalanRusak: freezed == latitudeJalanRusak ? _self.latitudeJalanRusak : latitudeJalanRusak // ignore: cast_nullable_to_non_nullable
as double?,longitudeJalanRusak: freezed == longitudeJalanRusak ? _self.longitudeJalanRusak : longitudeJalanRusak // ignore: cast_nullable_to_non_nullable
as double?,resikoJalanRusak: freezed == resikoJalanRusak ? _self.resikoJalanRusak : resikoJalanRusak // ignore: cast_nullable_to_non_nullable
as String?,adaLampuMati: null == adaLampuMati ? _self.adaLampuMati : adaLampuMati // ignore: cast_nullable_to_non_nullable
as bool,lokasiLampuMatiGps: freezed == lokasiLampuMatiGps ? _self.lokasiLampuMatiGps : lokasiLampuMatiGps // ignore: cast_nullable_to_non_nullable
as String?,latitudeLampuMati: freezed == latitudeLampuMati ? _self.latitudeLampuMati : latitudeLampuMati // ignore: cast_nullable_to_non_nullable
as double?,longitudeLampuMati: freezed == longitudeLampuMati ? _self.longitudeLampuMati : longitudeLampuMati // ignore: cast_nullable_to_non_nullable
as double?,resikoLampuMati: freezed == resikoLampuMati ? _self.resikoLampuMati : resikoLampuMati // ignore: cast_nullable_to_non_nullable
as String?,keterangan: null == keterangan ? _self.keterangan : keterangan // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
