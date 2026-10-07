// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ronda_laporan_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RondaLaporanEntity {

 String? get id;// Lingkungan
 int get sampahMenumpuk; int get selokanMampet; int get fasilitasRusak; int get kegiatanMengganggu; int get potensiBahaya; int get jalanBerlubang; int get lampuMati;// Keamanan
 int get laporanKeamanan; int get wargaBertengkar; int get tempatKurangAman; int get kerumunanTidakTertib; int get perluBantuanPetugas; int get gangguanKamtibmas; int get aktivitasMencurigakan; int get kehilanganLingkungan;// Sosial
 int get wargaButuhBantuan; int get kelompokBerselisih; int get keluhanWarga; int get kejadianMenggangguWarga; int get perluTerusanRTRW; int get permasalahanSosial; int get kasusPerzinahan; int get orangTerlantar;// Detail Sampah
 bool get adaSampahMenumpuk; String? get waktuSampahMenumpuk; String? get lokasiSampahMenumpuk; String? get jenisSampahDominan; bool get pengangkutanSesuaiJadwal; String? get alasanPengangkutan; bool get adaPembakaranSampah; String? get waktuPembakaran; String? get lokasiPembakaran; String? get pembakaranDiberiTindakan;// Detail Keamanan
 bool get adaPencurian; String? get waktuPencurian; String? get lokasiPencurian; String? get pelakuPencurianDiketahui; String? get pencurianDilaporkanAparat; bool get adaTawuran; String? get waktuTawuran; String? get lokasiTawuran; String? get pelakuTawuranDiketahui; String? get tawuranDilaporkanAparat; bool get adaNarkoba; String? get narkobaDilaporkanAparat;// Detail Lingkungan
 bool get adaSelokanTersumbat; String? get waktuSelokanTersumbat; String? get lokasiSelokanTersumbat; String? get resikoSelokanTersumbat; bool get adaJalanRusak; String? get lokasiJalanRusakGps; double? get latitudeJalanRusak; double? get longitudeJalanRusak; String? get resikoJalanRusak; bool get adaLampuMati; String? get lokasiLampuMatiGps; double? get latitudeLampuMati; double? get longitudeLampuMati; String? get resikoLampuMati; String? get patrolTime; String? get waktuKejadian; String get keterangan; DateTime? get timestamp;
/// Create a copy of RondaLaporanEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RondaLaporanEntityCopyWith<RondaLaporanEntity> get copyWith => _$RondaLaporanEntityCopyWithImpl<RondaLaporanEntity>(this as RondaLaporanEntity, _$identity);

  /// Serializes this RondaLaporanEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RondaLaporanEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sampahMenumpuk, sampahMenumpuk) || other.sampahMenumpuk == sampahMenumpuk)&&(identical(other.selokanMampet, selokanMampet) || other.selokanMampet == selokanMampet)&&(identical(other.fasilitasRusak, fasilitasRusak) || other.fasilitasRusak == fasilitasRusak)&&(identical(other.kegiatanMengganggu, kegiatanMengganggu) || other.kegiatanMengganggu == kegiatanMengganggu)&&(identical(other.potensiBahaya, potensiBahaya) || other.potensiBahaya == potensiBahaya)&&(identical(other.jalanBerlubang, jalanBerlubang) || other.jalanBerlubang == jalanBerlubang)&&(identical(other.lampuMati, lampuMati) || other.lampuMati == lampuMati)&&(identical(other.laporanKeamanan, laporanKeamanan) || other.laporanKeamanan == laporanKeamanan)&&(identical(other.wargaBertengkar, wargaBertengkar) || other.wargaBertengkar == wargaBertengkar)&&(identical(other.tempatKurangAman, tempatKurangAman) || other.tempatKurangAman == tempatKurangAman)&&(identical(other.kerumunanTidakTertib, kerumunanTidakTertib) || other.kerumunanTidakTertib == kerumunanTidakTertib)&&(identical(other.perluBantuanPetugas, perluBantuanPetugas) || other.perluBantuanPetugas == perluBantuanPetugas)&&(identical(other.gangguanKamtibmas, gangguanKamtibmas) || other.gangguanKamtibmas == gangguanKamtibmas)&&(identical(other.aktivitasMencurigakan, aktivitasMencurigakan) || other.aktivitasMencurigakan == aktivitasMencurigakan)&&(identical(other.kehilanganLingkungan, kehilanganLingkungan) || other.kehilanganLingkungan == kehilanganLingkungan)&&(identical(other.wargaButuhBantuan, wargaButuhBantuan) || other.wargaButuhBantuan == wargaButuhBantuan)&&(identical(other.kelompokBerselisih, kelompokBerselisih) || other.kelompokBerselisih == kelompokBerselisih)&&(identical(other.keluhanWarga, keluhanWarga) || other.keluhanWarga == keluhanWarga)&&(identical(other.kejadianMenggangguWarga, kejadianMenggangguWarga) || other.kejadianMenggangguWarga == kejadianMenggangguWarga)&&(identical(other.perluTerusanRTRW, perluTerusanRTRW) || other.perluTerusanRTRW == perluTerusanRTRW)&&(identical(other.permasalahanSosial, permasalahanSosial) || other.permasalahanSosial == permasalahanSosial)&&(identical(other.kasusPerzinahan, kasusPerzinahan) || other.kasusPerzinahan == kasusPerzinahan)&&(identical(other.orangTerlantar, orangTerlantar) || other.orangTerlantar == orangTerlantar)&&(identical(other.adaSampahMenumpuk, adaSampahMenumpuk) || other.adaSampahMenumpuk == adaSampahMenumpuk)&&(identical(other.waktuSampahMenumpuk, waktuSampahMenumpuk) || other.waktuSampahMenumpuk == waktuSampahMenumpuk)&&(identical(other.lokasiSampahMenumpuk, lokasiSampahMenumpuk) || other.lokasiSampahMenumpuk == lokasiSampahMenumpuk)&&(identical(other.jenisSampahDominan, jenisSampahDominan) || other.jenisSampahDominan == jenisSampahDominan)&&(identical(other.pengangkutanSesuaiJadwal, pengangkutanSesuaiJadwal) || other.pengangkutanSesuaiJadwal == pengangkutanSesuaiJadwal)&&(identical(other.alasanPengangkutan, alasanPengangkutan) || other.alasanPengangkutan == alasanPengangkutan)&&(identical(other.adaPembakaranSampah, adaPembakaranSampah) || other.adaPembakaranSampah == adaPembakaranSampah)&&(identical(other.waktuPembakaran, waktuPembakaran) || other.waktuPembakaran == waktuPembakaran)&&(identical(other.lokasiPembakaran, lokasiPembakaran) || other.lokasiPembakaran == lokasiPembakaran)&&(identical(other.pembakaranDiberiTindakan, pembakaranDiberiTindakan) || other.pembakaranDiberiTindakan == pembakaranDiberiTindakan)&&(identical(other.adaPencurian, adaPencurian) || other.adaPencurian == adaPencurian)&&(identical(other.waktuPencurian, waktuPencurian) || other.waktuPencurian == waktuPencurian)&&(identical(other.lokasiPencurian, lokasiPencurian) || other.lokasiPencurian == lokasiPencurian)&&(identical(other.pelakuPencurianDiketahui, pelakuPencurianDiketahui) || other.pelakuPencurianDiketahui == pelakuPencurianDiketahui)&&(identical(other.pencurianDilaporkanAparat, pencurianDilaporkanAparat) || other.pencurianDilaporkanAparat == pencurianDilaporkanAparat)&&(identical(other.adaTawuran, adaTawuran) || other.adaTawuran == adaTawuran)&&(identical(other.waktuTawuran, waktuTawuran) || other.waktuTawuran == waktuTawuran)&&(identical(other.lokasiTawuran, lokasiTawuran) || other.lokasiTawuran == lokasiTawuran)&&(identical(other.pelakuTawuranDiketahui, pelakuTawuranDiketahui) || other.pelakuTawuranDiketahui == pelakuTawuranDiketahui)&&(identical(other.tawuranDilaporkanAparat, tawuranDilaporkanAparat) || other.tawuranDilaporkanAparat == tawuranDilaporkanAparat)&&(identical(other.adaNarkoba, adaNarkoba) || other.adaNarkoba == adaNarkoba)&&(identical(other.narkobaDilaporkanAparat, narkobaDilaporkanAparat) || other.narkobaDilaporkanAparat == narkobaDilaporkanAparat)&&(identical(other.adaSelokanTersumbat, adaSelokanTersumbat) || other.adaSelokanTersumbat == adaSelokanTersumbat)&&(identical(other.waktuSelokanTersumbat, waktuSelokanTersumbat) || other.waktuSelokanTersumbat == waktuSelokanTersumbat)&&(identical(other.lokasiSelokanTersumbat, lokasiSelokanTersumbat) || other.lokasiSelokanTersumbat == lokasiSelokanTersumbat)&&(identical(other.resikoSelokanTersumbat, resikoSelokanTersumbat) || other.resikoSelokanTersumbat == resikoSelokanTersumbat)&&(identical(other.adaJalanRusak, adaJalanRusak) || other.adaJalanRusak == adaJalanRusak)&&(identical(other.lokasiJalanRusakGps, lokasiJalanRusakGps) || other.lokasiJalanRusakGps == lokasiJalanRusakGps)&&(identical(other.latitudeJalanRusak, latitudeJalanRusak) || other.latitudeJalanRusak == latitudeJalanRusak)&&(identical(other.longitudeJalanRusak, longitudeJalanRusak) || other.longitudeJalanRusak == longitudeJalanRusak)&&(identical(other.resikoJalanRusak, resikoJalanRusak) || other.resikoJalanRusak == resikoJalanRusak)&&(identical(other.adaLampuMati, adaLampuMati) || other.adaLampuMati == adaLampuMati)&&(identical(other.lokasiLampuMatiGps, lokasiLampuMatiGps) || other.lokasiLampuMatiGps == lokasiLampuMatiGps)&&(identical(other.latitudeLampuMati, latitudeLampuMati) || other.latitudeLampuMati == latitudeLampuMati)&&(identical(other.longitudeLampuMati, longitudeLampuMati) || other.longitudeLampuMati == longitudeLampuMati)&&(identical(other.resikoLampuMati, resikoLampuMati) || other.resikoLampuMati == resikoLampuMati)&&(identical(other.patrolTime, patrolTime) || other.patrolTime == patrolTime)&&(identical(other.waktuKejadian, waktuKejadian) || other.waktuKejadian == waktuKejadian)&&(identical(other.keterangan, keterangan) || other.keterangan == keterangan)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,sampahMenumpuk,selokanMampet,fasilitasRusak,kegiatanMengganggu,potensiBahaya,jalanBerlubang,lampuMati,laporanKeamanan,wargaBertengkar,tempatKurangAman,kerumunanTidakTertib,perluBantuanPetugas,gangguanKamtibmas,aktivitasMencurigakan,kehilanganLingkungan,wargaButuhBantuan,kelompokBerselisih,keluhanWarga,kejadianMenggangguWarga,perluTerusanRTRW,permasalahanSosial,kasusPerzinahan,orangTerlantar,adaSampahMenumpuk,waktuSampahMenumpuk,lokasiSampahMenumpuk,jenisSampahDominan,pengangkutanSesuaiJadwal,alasanPengangkutan,adaPembakaranSampah,waktuPembakaran,lokasiPembakaran,pembakaranDiberiTindakan,adaPencurian,waktuPencurian,lokasiPencurian,pelakuPencurianDiketahui,pencurianDilaporkanAparat,adaTawuran,waktuTawuran,lokasiTawuran,pelakuTawuranDiketahui,tawuranDilaporkanAparat,adaNarkoba,narkobaDilaporkanAparat,adaSelokanTersumbat,waktuSelokanTersumbat,lokasiSelokanTersumbat,resikoSelokanTersumbat,adaJalanRusak,lokasiJalanRusakGps,latitudeJalanRusak,longitudeJalanRusak,resikoJalanRusak,adaLampuMati,lokasiLampuMatiGps,latitudeLampuMati,longitudeLampuMati,resikoLampuMati,patrolTime,waktuKejadian,keterangan,timestamp]);

@override
String toString() {
  return 'RondaLaporanEntity(id: $id, sampahMenumpuk: $sampahMenumpuk, selokanMampet: $selokanMampet, fasilitasRusak: $fasilitasRusak, kegiatanMengganggu: $kegiatanMengganggu, potensiBahaya: $potensiBahaya, jalanBerlubang: $jalanBerlubang, lampuMati: $lampuMati, laporanKeamanan: $laporanKeamanan, wargaBertengkar: $wargaBertengkar, tempatKurangAman: $tempatKurangAman, kerumunanTidakTertib: $kerumunanTidakTertib, perluBantuanPetugas: $perluBantuanPetugas, gangguanKamtibmas: $gangguanKamtibmas, aktivitasMencurigakan: $aktivitasMencurigakan, kehilanganLingkungan: $kehilanganLingkungan, wargaButuhBantuan: $wargaButuhBantuan, kelompokBerselisih: $kelompokBerselisih, keluhanWarga: $keluhanWarga, kejadianMenggangguWarga: $kejadianMenggangguWarga, perluTerusanRTRW: $perluTerusanRTRW, permasalahanSosial: $permasalahanSosial, kasusPerzinahan: $kasusPerzinahan, orangTerlantar: $orangTerlantar, adaSampahMenumpuk: $adaSampahMenumpuk, waktuSampahMenumpuk: $waktuSampahMenumpuk, lokasiSampahMenumpuk: $lokasiSampahMenumpuk, jenisSampahDominan: $jenisSampahDominan, pengangkutanSesuaiJadwal: $pengangkutanSesuaiJadwal, alasanPengangkutan: $alasanPengangkutan, adaPembakaranSampah: $adaPembakaranSampah, waktuPembakaran: $waktuPembakaran, lokasiPembakaran: $lokasiPembakaran, pembakaranDiberiTindakan: $pembakaranDiberiTindakan, adaPencurian: $adaPencurian, waktuPencurian: $waktuPencurian, lokasiPencurian: $lokasiPencurian, pelakuPencurianDiketahui: $pelakuPencurianDiketahui, pencurianDilaporkanAparat: $pencurianDilaporkanAparat, adaTawuran: $adaTawuran, waktuTawuran: $waktuTawuran, lokasiTawuran: $lokasiTawuran, pelakuTawuranDiketahui: $pelakuTawuranDiketahui, tawuranDilaporkanAparat: $tawuranDilaporkanAparat, adaNarkoba: $adaNarkoba, narkobaDilaporkanAparat: $narkobaDilaporkanAparat, adaSelokanTersumbat: $adaSelokanTersumbat, waktuSelokanTersumbat: $waktuSelokanTersumbat, lokasiSelokanTersumbat: $lokasiSelokanTersumbat, resikoSelokanTersumbat: $resikoSelokanTersumbat, adaJalanRusak: $adaJalanRusak, lokasiJalanRusakGps: $lokasiJalanRusakGps, latitudeJalanRusak: $latitudeJalanRusak, longitudeJalanRusak: $longitudeJalanRusak, resikoJalanRusak: $resikoJalanRusak, adaLampuMati: $adaLampuMati, lokasiLampuMatiGps: $lokasiLampuMatiGps, latitudeLampuMati: $latitudeLampuMati, longitudeLampuMati: $longitudeLampuMati, resikoLampuMati: $resikoLampuMati, patrolTime: $patrolTime, waktuKejadian: $waktuKejadian, keterangan: $keterangan, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $RondaLaporanEntityCopyWith<$Res>  {
  factory $RondaLaporanEntityCopyWith(RondaLaporanEntity value, $Res Function(RondaLaporanEntity) _then) = _$RondaLaporanEntityCopyWithImpl;
@useResult
$Res call({
 String? id, int sampahMenumpuk, int selokanMampet, int fasilitasRusak, int kegiatanMengganggu, int potensiBahaya, int jalanBerlubang, int lampuMati, int laporanKeamanan, int wargaBertengkar, int tempatKurangAman, int kerumunanTidakTertib, int perluBantuanPetugas, int gangguanKamtibmas, int aktivitasMencurigakan, int kehilanganLingkungan, int wargaButuhBantuan, int kelompokBerselisih, int keluhanWarga, int kejadianMenggangguWarga, int perluTerusanRTRW, int permasalahanSosial, int kasusPerzinahan, int orangTerlantar, bool adaSampahMenumpuk, String? waktuSampahMenumpuk, String? lokasiSampahMenumpuk, String? jenisSampahDominan, bool pengangkutanSesuaiJadwal, String? alasanPengangkutan, bool adaPembakaranSampah, String? waktuPembakaran, String? lokasiPembakaran, String? pembakaranDiberiTindakan, bool adaPencurian, String? waktuPencurian, String? lokasiPencurian, String? pelakuPencurianDiketahui, String? pencurianDilaporkanAparat, bool adaTawuran, String? waktuTawuran, String? lokasiTawuran, String? pelakuTawuranDiketahui, String? tawuranDilaporkanAparat, bool adaNarkoba, String? narkobaDilaporkanAparat, bool adaSelokanTersumbat, String? waktuSelokanTersumbat, String? lokasiSelokanTersumbat, String? resikoSelokanTersumbat, bool adaJalanRusak, String? lokasiJalanRusakGps, double? latitudeJalanRusak, double? longitudeJalanRusak, String? resikoJalanRusak, bool adaLampuMati, String? lokasiLampuMatiGps, double? latitudeLampuMati, double? longitudeLampuMati, String? resikoLampuMati, String? patrolTime, String? waktuKejadian, String keterangan, DateTime? timestamp
});




}
/// @nodoc
class _$RondaLaporanEntityCopyWithImpl<$Res>
    implements $RondaLaporanEntityCopyWith<$Res> {
  _$RondaLaporanEntityCopyWithImpl(this._self, this._then);

  final RondaLaporanEntity _self;
  final $Res Function(RondaLaporanEntity) _then;

/// Create a copy of RondaLaporanEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? sampahMenumpuk = null,Object? selokanMampet = null,Object? fasilitasRusak = null,Object? kegiatanMengganggu = null,Object? potensiBahaya = null,Object? jalanBerlubang = null,Object? lampuMati = null,Object? laporanKeamanan = null,Object? wargaBertengkar = null,Object? tempatKurangAman = null,Object? kerumunanTidakTertib = null,Object? perluBantuanPetugas = null,Object? gangguanKamtibmas = null,Object? aktivitasMencurigakan = null,Object? kehilanganLingkungan = null,Object? wargaButuhBantuan = null,Object? kelompokBerselisih = null,Object? keluhanWarga = null,Object? kejadianMenggangguWarga = null,Object? perluTerusanRTRW = null,Object? permasalahanSosial = null,Object? kasusPerzinahan = null,Object? orangTerlantar = null,Object? adaSampahMenumpuk = null,Object? waktuSampahMenumpuk = freezed,Object? lokasiSampahMenumpuk = freezed,Object? jenisSampahDominan = freezed,Object? pengangkutanSesuaiJadwal = null,Object? alasanPengangkutan = freezed,Object? adaPembakaranSampah = null,Object? waktuPembakaran = freezed,Object? lokasiPembakaran = freezed,Object? pembakaranDiberiTindakan = freezed,Object? adaPencurian = null,Object? waktuPencurian = freezed,Object? lokasiPencurian = freezed,Object? pelakuPencurianDiketahui = freezed,Object? pencurianDilaporkanAparat = freezed,Object? adaTawuran = null,Object? waktuTawuran = freezed,Object? lokasiTawuran = freezed,Object? pelakuTawuranDiketahui = freezed,Object? tawuranDilaporkanAparat = freezed,Object? adaNarkoba = null,Object? narkobaDilaporkanAparat = freezed,Object? adaSelokanTersumbat = null,Object? waktuSelokanTersumbat = freezed,Object? lokasiSelokanTersumbat = freezed,Object? resikoSelokanTersumbat = freezed,Object? adaJalanRusak = null,Object? lokasiJalanRusakGps = freezed,Object? latitudeJalanRusak = freezed,Object? longitudeJalanRusak = freezed,Object? resikoJalanRusak = freezed,Object? adaLampuMati = null,Object? lokasiLampuMatiGps = freezed,Object? latitudeLampuMati = freezed,Object? longitudeLampuMati = freezed,Object? resikoLampuMati = freezed,Object? patrolTime = freezed,Object? waktuKejadian = freezed,Object? keterangan = null,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
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
as String?,patrolTime: freezed == patrolTime ? _self.patrolTime : patrolTime // ignore: cast_nullable_to_non_nullable
as String?,waktuKejadian: freezed == waktuKejadian ? _self.waktuKejadian : waktuKejadian // ignore: cast_nullable_to_non_nullable
as String?,keterangan: null == keterangan ? _self.keterangan : keterangan // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RondaLaporanEntity].
extension RondaLaporanEntityPatterns on RondaLaporanEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RondaLaporanEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RondaLaporanEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RondaLaporanEntity value)  $default,){
final _that = this;
switch (_that) {
case _RondaLaporanEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RondaLaporanEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RondaLaporanEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  int sampahMenumpuk,  int selokanMampet,  int fasilitasRusak,  int kegiatanMengganggu,  int potensiBahaya,  int jalanBerlubang,  int lampuMati,  int laporanKeamanan,  int wargaBertengkar,  int tempatKurangAman,  int kerumunanTidakTertib,  int perluBantuanPetugas,  int gangguanKamtibmas,  int aktivitasMencurigakan,  int kehilanganLingkungan,  int wargaButuhBantuan,  int kelompokBerselisih,  int keluhanWarga,  int kejadianMenggangguWarga,  int perluTerusanRTRW,  int permasalahanSosial,  int kasusPerzinahan,  int orangTerlantar,  bool adaSampahMenumpuk,  String? waktuSampahMenumpuk,  String? lokasiSampahMenumpuk,  String? jenisSampahDominan,  bool pengangkutanSesuaiJadwal,  String? alasanPengangkutan,  bool adaPembakaranSampah,  String? waktuPembakaran,  String? lokasiPembakaran,  String? pembakaranDiberiTindakan,  bool adaPencurian,  String? waktuPencurian,  String? lokasiPencurian,  String? pelakuPencurianDiketahui,  String? pencurianDilaporkanAparat,  bool adaTawuran,  String? waktuTawuran,  String? lokasiTawuran,  String? pelakuTawuranDiketahui,  String? tawuranDilaporkanAparat,  bool adaNarkoba,  String? narkobaDilaporkanAparat,  bool adaSelokanTersumbat,  String? waktuSelokanTersumbat,  String? lokasiSelokanTersumbat,  String? resikoSelokanTersumbat,  bool adaJalanRusak,  String? lokasiJalanRusakGps,  double? latitudeJalanRusak,  double? longitudeJalanRusak,  String? resikoJalanRusak,  bool adaLampuMati,  String? lokasiLampuMatiGps,  double? latitudeLampuMati,  double? longitudeLampuMati,  String? resikoLampuMati,  String? patrolTime,  String? waktuKejadian,  String keterangan,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RondaLaporanEntity() when $default != null:
return $default(_that.id,_that.sampahMenumpuk,_that.selokanMampet,_that.fasilitasRusak,_that.kegiatanMengganggu,_that.potensiBahaya,_that.jalanBerlubang,_that.lampuMati,_that.laporanKeamanan,_that.wargaBertengkar,_that.tempatKurangAman,_that.kerumunanTidakTertib,_that.perluBantuanPetugas,_that.gangguanKamtibmas,_that.aktivitasMencurigakan,_that.kehilanganLingkungan,_that.wargaButuhBantuan,_that.kelompokBerselisih,_that.keluhanWarga,_that.kejadianMenggangguWarga,_that.perluTerusanRTRW,_that.permasalahanSosial,_that.kasusPerzinahan,_that.orangTerlantar,_that.adaSampahMenumpuk,_that.waktuSampahMenumpuk,_that.lokasiSampahMenumpuk,_that.jenisSampahDominan,_that.pengangkutanSesuaiJadwal,_that.alasanPengangkutan,_that.adaPembakaranSampah,_that.waktuPembakaran,_that.lokasiPembakaran,_that.pembakaranDiberiTindakan,_that.adaPencurian,_that.waktuPencurian,_that.lokasiPencurian,_that.pelakuPencurianDiketahui,_that.pencurianDilaporkanAparat,_that.adaTawuran,_that.waktuTawuran,_that.lokasiTawuran,_that.pelakuTawuranDiketahui,_that.tawuranDilaporkanAparat,_that.adaNarkoba,_that.narkobaDilaporkanAparat,_that.adaSelokanTersumbat,_that.waktuSelokanTersumbat,_that.lokasiSelokanTersumbat,_that.resikoSelokanTersumbat,_that.adaJalanRusak,_that.lokasiJalanRusakGps,_that.latitudeJalanRusak,_that.longitudeJalanRusak,_that.resikoJalanRusak,_that.adaLampuMati,_that.lokasiLampuMatiGps,_that.latitudeLampuMati,_that.longitudeLampuMati,_that.resikoLampuMati,_that.patrolTime,_that.waktuKejadian,_that.keterangan,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  int sampahMenumpuk,  int selokanMampet,  int fasilitasRusak,  int kegiatanMengganggu,  int potensiBahaya,  int jalanBerlubang,  int lampuMati,  int laporanKeamanan,  int wargaBertengkar,  int tempatKurangAman,  int kerumunanTidakTertib,  int perluBantuanPetugas,  int gangguanKamtibmas,  int aktivitasMencurigakan,  int kehilanganLingkungan,  int wargaButuhBantuan,  int kelompokBerselisih,  int keluhanWarga,  int kejadianMenggangguWarga,  int perluTerusanRTRW,  int permasalahanSosial,  int kasusPerzinahan,  int orangTerlantar,  bool adaSampahMenumpuk,  String? waktuSampahMenumpuk,  String? lokasiSampahMenumpuk,  String? jenisSampahDominan,  bool pengangkutanSesuaiJadwal,  String? alasanPengangkutan,  bool adaPembakaranSampah,  String? waktuPembakaran,  String? lokasiPembakaran,  String? pembakaranDiberiTindakan,  bool adaPencurian,  String? waktuPencurian,  String? lokasiPencurian,  String? pelakuPencurianDiketahui,  String? pencurianDilaporkanAparat,  bool adaTawuran,  String? waktuTawuran,  String? lokasiTawuran,  String? pelakuTawuranDiketahui,  String? tawuranDilaporkanAparat,  bool adaNarkoba,  String? narkobaDilaporkanAparat,  bool adaSelokanTersumbat,  String? waktuSelokanTersumbat,  String? lokasiSelokanTersumbat,  String? resikoSelokanTersumbat,  bool adaJalanRusak,  String? lokasiJalanRusakGps,  double? latitudeJalanRusak,  double? longitudeJalanRusak,  String? resikoJalanRusak,  bool adaLampuMati,  String? lokasiLampuMatiGps,  double? latitudeLampuMati,  double? longitudeLampuMati,  String? resikoLampuMati,  String? patrolTime,  String? waktuKejadian,  String keterangan,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _RondaLaporanEntity():
return $default(_that.id,_that.sampahMenumpuk,_that.selokanMampet,_that.fasilitasRusak,_that.kegiatanMengganggu,_that.potensiBahaya,_that.jalanBerlubang,_that.lampuMati,_that.laporanKeamanan,_that.wargaBertengkar,_that.tempatKurangAman,_that.kerumunanTidakTertib,_that.perluBantuanPetugas,_that.gangguanKamtibmas,_that.aktivitasMencurigakan,_that.kehilanganLingkungan,_that.wargaButuhBantuan,_that.kelompokBerselisih,_that.keluhanWarga,_that.kejadianMenggangguWarga,_that.perluTerusanRTRW,_that.permasalahanSosial,_that.kasusPerzinahan,_that.orangTerlantar,_that.adaSampahMenumpuk,_that.waktuSampahMenumpuk,_that.lokasiSampahMenumpuk,_that.jenisSampahDominan,_that.pengangkutanSesuaiJadwal,_that.alasanPengangkutan,_that.adaPembakaranSampah,_that.waktuPembakaran,_that.lokasiPembakaran,_that.pembakaranDiberiTindakan,_that.adaPencurian,_that.waktuPencurian,_that.lokasiPencurian,_that.pelakuPencurianDiketahui,_that.pencurianDilaporkanAparat,_that.adaTawuran,_that.waktuTawuran,_that.lokasiTawuran,_that.pelakuTawuranDiketahui,_that.tawuranDilaporkanAparat,_that.adaNarkoba,_that.narkobaDilaporkanAparat,_that.adaSelokanTersumbat,_that.waktuSelokanTersumbat,_that.lokasiSelokanTersumbat,_that.resikoSelokanTersumbat,_that.adaJalanRusak,_that.lokasiJalanRusakGps,_that.latitudeJalanRusak,_that.longitudeJalanRusak,_that.resikoJalanRusak,_that.adaLampuMati,_that.lokasiLampuMatiGps,_that.latitudeLampuMati,_that.longitudeLampuMati,_that.resikoLampuMati,_that.patrolTime,_that.waktuKejadian,_that.keterangan,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  int sampahMenumpuk,  int selokanMampet,  int fasilitasRusak,  int kegiatanMengganggu,  int potensiBahaya,  int jalanBerlubang,  int lampuMati,  int laporanKeamanan,  int wargaBertengkar,  int tempatKurangAman,  int kerumunanTidakTertib,  int perluBantuanPetugas,  int gangguanKamtibmas,  int aktivitasMencurigakan,  int kehilanganLingkungan,  int wargaButuhBantuan,  int kelompokBerselisih,  int keluhanWarga,  int kejadianMenggangguWarga,  int perluTerusanRTRW,  int permasalahanSosial,  int kasusPerzinahan,  int orangTerlantar,  bool adaSampahMenumpuk,  String? waktuSampahMenumpuk,  String? lokasiSampahMenumpuk,  String? jenisSampahDominan,  bool pengangkutanSesuaiJadwal,  String? alasanPengangkutan,  bool adaPembakaranSampah,  String? waktuPembakaran,  String? lokasiPembakaran,  String? pembakaranDiberiTindakan,  bool adaPencurian,  String? waktuPencurian,  String? lokasiPencurian,  String? pelakuPencurianDiketahui,  String? pencurianDilaporkanAparat,  bool adaTawuran,  String? waktuTawuran,  String? lokasiTawuran,  String? pelakuTawuranDiketahui,  String? tawuranDilaporkanAparat,  bool adaNarkoba,  String? narkobaDilaporkanAparat,  bool adaSelokanTersumbat,  String? waktuSelokanTersumbat,  String? lokasiSelokanTersumbat,  String? resikoSelokanTersumbat,  bool adaJalanRusak,  String? lokasiJalanRusakGps,  double? latitudeJalanRusak,  double? longitudeJalanRusak,  String? resikoJalanRusak,  bool adaLampuMati,  String? lokasiLampuMatiGps,  double? latitudeLampuMati,  double? longitudeLampuMati,  String? resikoLampuMati,  String? patrolTime,  String? waktuKejadian,  String keterangan,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _RondaLaporanEntity() when $default != null:
return $default(_that.id,_that.sampahMenumpuk,_that.selokanMampet,_that.fasilitasRusak,_that.kegiatanMengganggu,_that.potensiBahaya,_that.jalanBerlubang,_that.lampuMati,_that.laporanKeamanan,_that.wargaBertengkar,_that.tempatKurangAman,_that.kerumunanTidakTertib,_that.perluBantuanPetugas,_that.gangguanKamtibmas,_that.aktivitasMencurigakan,_that.kehilanganLingkungan,_that.wargaButuhBantuan,_that.kelompokBerselisih,_that.keluhanWarga,_that.kejadianMenggangguWarga,_that.perluTerusanRTRW,_that.permasalahanSosial,_that.kasusPerzinahan,_that.orangTerlantar,_that.adaSampahMenumpuk,_that.waktuSampahMenumpuk,_that.lokasiSampahMenumpuk,_that.jenisSampahDominan,_that.pengangkutanSesuaiJadwal,_that.alasanPengangkutan,_that.adaPembakaranSampah,_that.waktuPembakaran,_that.lokasiPembakaran,_that.pembakaranDiberiTindakan,_that.adaPencurian,_that.waktuPencurian,_that.lokasiPencurian,_that.pelakuPencurianDiketahui,_that.pencurianDilaporkanAparat,_that.adaTawuran,_that.waktuTawuran,_that.lokasiTawuran,_that.pelakuTawuranDiketahui,_that.tawuranDilaporkanAparat,_that.adaNarkoba,_that.narkobaDilaporkanAparat,_that.adaSelokanTersumbat,_that.waktuSelokanTersumbat,_that.lokasiSelokanTersumbat,_that.resikoSelokanTersumbat,_that.adaJalanRusak,_that.lokasiJalanRusakGps,_that.latitudeJalanRusak,_that.longitudeJalanRusak,_that.resikoJalanRusak,_that.adaLampuMati,_that.lokasiLampuMatiGps,_that.latitudeLampuMati,_that.longitudeLampuMati,_that.resikoLampuMati,_that.patrolTime,_that.waktuKejadian,_that.keterangan,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RondaLaporanEntity extends RondaLaporanEntity {
  const _RondaLaporanEntity({this.id, this.sampahMenumpuk = 1, this.selokanMampet = 1, this.fasilitasRusak = 1, this.kegiatanMengganggu = 1, this.potensiBahaya = 1, this.jalanBerlubang = 1, this.lampuMati = 1, this.laporanKeamanan = 1, this.wargaBertengkar = 1, this.tempatKurangAman = 1, this.kerumunanTidakTertib = 1, this.perluBantuanPetugas = 1, this.gangguanKamtibmas = 1, this.aktivitasMencurigakan = 1, this.kehilanganLingkungan = 1, this.wargaButuhBantuan = 1, this.kelompokBerselisih = 1, this.keluhanWarga = 1, this.kejadianMenggangguWarga = 1, this.perluTerusanRTRW = 1, this.permasalahanSosial = 1, this.kasusPerzinahan = 1, this.orangTerlantar = 1, this.adaSampahMenumpuk = false, this.waktuSampahMenumpuk, this.lokasiSampahMenumpuk, this.jenisSampahDominan, this.pengangkutanSesuaiJadwal = true, this.alasanPengangkutan, this.adaPembakaranSampah = false, this.waktuPembakaran, this.lokasiPembakaran, this.pembakaranDiberiTindakan, this.adaPencurian = false, this.waktuPencurian, this.lokasiPencurian, this.pelakuPencurianDiketahui, this.pencurianDilaporkanAparat, this.adaTawuran = false, this.waktuTawuran, this.lokasiTawuran, this.pelakuTawuranDiketahui, this.tawuranDilaporkanAparat, this.adaNarkoba = false, this.narkobaDilaporkanAparat, this.adaSelokanTersumbat = false, this.waktuSelokanTersumbat, this.lokasiSelokanTersumbat, this.resikoSelokanTersumbat, this.adaJalanRusak = false, this.lokasiJalanRusakGps, this.latitudeJalanRusak, this.longitudeJalanRusak, this.resikoJalanRusak, this.adaLampuMati = false, this.lokasiLampuMatiGps, this.latitudeLampuMati, this.longitudeLampuMati, this.resikoLampuMati, this.patrolTime, this.waktuKejadian, this.keterangan = '', this.timestamp}): super._();
  factory _RondaLaporanEntity.fromJson(Map<String, dynamic> json) => _$RondaLaporanEntityFromJson(json);

@override final  String? id;
// Lingkungan
@override@JsonKey() final  int sampahMenumpuk;
@override@JsonKey() final  int selokanMampet;
@override@JsonKey() final  int fasilitasRusak;
@override@JsonKey() final  int kegiatanMengganggu;
@override@JsonKey() final  int potensiBahaya;
@override@JsonKey() final  int jalanBerlubang;
@override@JsonKey() final  int lampuMati;
// Keamanan
@override@JsonKey() final  int laporanKeamanan;
@override@JsonKey() final  int wargaBertengkar;
@override@JsonKey() final  int tempatKurangAman;
@override@JsonKey() final  int kerumunanTidakTertib;
@override@JsonKey() final  int perluBantuanPetugas;
@override@JsonKey() final  int gangguanKamtibmas;
@override@JsonKey() final  int aktivitasMencurigakan;
@override@JsonKey() final  int kehilanganLingkungan;
// Sosial
@override@JsonKey() final  int wargaButuhBantuan;
@override@JsonKey() final  int kelompokBerselisih;
@override@JsonKey() final  int keluhanWarga;
@override@JsonKey() final  int kejadianMenggangguWarga;
@override@JsonKey() final  int perluTerusanRTRW;
@override@JsonKey() final  int permasalahanSosial;
@override@JsonKey() final  int kasusPerzinahan;
@override@JsonKey() final  int orangTerlantar;
// Detail Sampah
@override@JsonKey() final  bool adaSampahMenumpuk;
@override final  String? waktuSampahMenumpuk;
@override final  String? lokasiSampahMenumpuk;
@override final  String? jenisSampahDominan;
@override@JsonKey() final  bool pengangkutanSesuaiJadwal;
@override final  String? alasanPengangkutan;
@override@JsonKey() final  bool adaPembakaranSampah;
@override final  String? waktuPembakaran;
@override final  String? lokasiPembakaran;
@override final  String? pembakaranDiberiTindakan;
// Detail Keamanan
@override@JsonKey() final  bool adaPencurian;
@override final  String? waktuPencurian;
@override final  String? lokasiPencurian;
@override final  String? pelakuPencurianDiketahui;
@override final  String? pencurianDilaporkanAparat;
@override@JsonKey() final  bool adaTawuran;
@override final  String? waktuTawuran;
@override final  String? lokasiTawuran;
@override final  String? pelakuTawuranDiketahui;
@override final  String? tawuranDilaporkanAparat;
@override@JsonKey() final  bool adaNarkoba;
@override final  String? narkobaDilaporkanAparat;
// Detail Lingkungan
@override@JsonKey() final  bool adaSelokanTersumbat;
@override final  String? waktuSelokanTersumbat;
@override final  String? lokasiSelokanTersumbat;
@override final  String? resikoSelokanTersumbat;
@override@JsonKey() final  bool adaJalanRusak;
@override final  String? lokasiJalanRusakGps;
@override final  double? latitudeJalanRusak;
@override final  double? longitudeJalanRusak;
@override final  String? resikoJalanRusak;
@override@JsonKey() final  bool adaLampuMati;
@override final  String? lokasiLampuMatiGps;
@override final  double? latitudeLampuMati;
@override final  double? longitudeLampuMati;
@override final  String? resikoLampuMati;
@override final  String? patrolTime;
@override final  String? waktuKejadian;
@override@JsonKey() final  String keterangan;
@override final  DateTime? timestamp;

/// Create a copy of RondaLaporanEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RondaLaporanEntityCopyWith<_RondaLaporanEntity> get copyWith => __$RondaLaporanEntityCopyWithImpl<_RondaLaporanEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RondaLaporanEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RondaLaporanEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sampahMenumpuk, sampahMenumpuk) || other.sampahMenumpuk == sampahMenumpuk)&&(identical(other.selokanMampet, selokanMampet) || other.selokanMampet == selokanMampet)&&(identical(other.fasilitasRusak, fasilitasRusak) || other.fasilitasRusak == fasilitasRusak)&&(identical(other.kegiatanMengganggu, kegiatanMengganggu) || other.kegiatanMengganggu == kegiatanMengganggu)&&(identical(other.potensiBahaya, potensiBahaya) || other.potensiBahaya == potensiBahaya)&&(identical(other.jalanBerlubang, jalanBerlubang) || other.jalanBerlubang == jalanBerlubang)&&(identical(other.lampuMati, lampuMati) || other.lampuMati == lampuMati)&&(identical(other.laporanKeamanan, laporanKeamanan) || other.laporanKeamanan == laporanKeamanan)&&(identical(other.wargaBertengkar, wargaBertengkar) || other.wargaBertengkar == wargaBertengkar)&&(identical(other.tempatKurangAman, tempatKurangAman) || other.tempatKurangAman == tempatKurangAman)&&(identical(other.kerumunanTidakTertib, kerumunanTidakTertib) || other.kerumunanTidakTertib == kerumunanTidakTertib)&&(identical(other.perluBantuanPetugas, perluBantuanPetugas) || other.perluBantuanPetugas == perluBantuanPetugas)&&(identical(other.gangguanKamtibmas, gangguanKamtibmas) || other.gangguanKamtibmas == gangguanKamtibmas)&&(identical(other.aktivitasMencurigakan, aktivitasMencurigakan) || other.aktivitasMencurigakan == aktivitasMencurigakan)&&(identical(other.kehilanganLingkungan, kehilanganLingkungan) || other.kehilanganLingkungan == kehilanganLingkungan)&&(identical(other.wargaButuhBantuan, wargaButuhBantuan) || other.wargaButuhBantuan == wargaButuhBantuan)&&(identical(other.kelompokBerselisih, kelompokBerselisih) || other.kelompokBerselisih == kelompokBerselisih)&&(identical(other.keluhanWarga, keluhanWarga) || other.keluhanWarga == keluhanWarga)&&(identical(other.kejadianMenggangguWarga, kejadianMenggangguWarga) || other.kejadianMenggangguWarga == kejadianMenggangguWarga)&&(identical(other.perluTerusanRTRW, perluTerusanRTRW) || other.perluTerusanRTRW == perluTerusanRTRW)&&(identical(other.permasalahanSosial, permasalahanSosial) || other.permasalahanSosial == permasalahanSosial)&&(identical(other.kasusPerzinahan, kasusPerzinahan) || other.kasusPerzinahan == kasusPerzinahan)&&(identical(other.orangTerlantar, orangTerlantar) || other.orangTerlantar == orangTerlantar)&&(identical(other.adaSampahMenumpuk, adaSampahMenumpuk) || other.adaSampahMenumpuk == adaSampahMenumpuk)&&(identical(other.waktuSampahMenumpuk, waktuSampahMenumpuk) || other.waktuSampahMenumpuk == waktuSampahMenumpuk)&&(identical(other.lokasiSampahMenumpuk, lokasiSampahMenumpuk) || other.lokasiSampahMenumpuk == lokasiSampahMenumpuk)&&(identical(other.jenisSampahDominan, jenisSampahDominan) || other.jenisSampahDominan == jenisSampahDominan)&&(identical(other.pengangkutanSesuaiJadwal, pengangkutanSesuaiJadwal) || other.pengangkutanSesuaiJadwal == pengangkutanSesuaiJadwal)&&(identical(other.alasanPengangkutan, alasanPengangkutan) || other.alasanPengangkutan == alasanPengangkutan)&&(identical(other.adaPembakaranSampah, adaPembakaranSampah) || other.adaPembakaranSampah == adaPembakaranSampah)&&(identical(other.waktuPembakaran, waktuPembakaran) || other.waktuPembakaran == waktuPembakaran)&&(identical(other.lokasiPembakaran, lokasiPembakaran) || other.lokasiPembakaran == lokasiPembakaran)&&(identical(other.pembakaranDiberiTindakan, pembakaranDiberiTindakan) || other.pembakaranDiberiTindakan == pembakaranDiberiTindakan)&&(identical(other.adaPencurian, adaPencurian) || other.adaPencurian == adaPencurian)&&(identical(other.waktuPencurian, waktuPencurian) || other.waktuPencurian == waktuPencurian)&&(identical(other.lokasiPencurian, lokasiPencurian) || other.lokasiPencurian == lokasiPencurian)&&(identical(other.pelakuPencurianDiketahui, pelakuPencurianDiketahui) || other.pelakuPencurianDiketahui == pelakuPencurianDiketahui)&&(identical(other.pencurianDilaporkanAparat, pencurianDilaporkanAparat) || other.pencurianDilaporkanAparat == pencurianDilaporkanAparat)&&(identical(other.adaTawuran, adaTawuran) || other.adaTawuran == adaTawuran)&&(identical(other.waktuTawuran, waktuTawuran) || other.waktuTawuran == waktuTawuran)&&(identical(other.lokasiTawuran, lokasiTawuran) || other.lokasiTawuran == lokasiTawuran)&&(identical(other.pelakuTawuranDiketahui, pelakuTawuranDiketahui) || other.pelakuTawuranDiketahui == pelakuTawuranDiketahui)&&(identical(other.tawuranDilaporkanAparat, tawuranDilaporkanAparat) || other.tawuranDilaporkanAparat == tawuranDilaporkanAparat)&&(identical(other.adaNarkoba, adaNarkoba) || other.adaNarkoba == adaNarkoba)&&(identical(other.narkobaDilaporkanAparat, narkobaDilaporkanAparat) || other.narkobaDilaporkanAparat == narkobaDilaporkanAparat)&&(identical(other.adaSelokanTersumbat, adaSelokanTersumbat) || other.adaSelokanTersumbat == adaSelokanTersumbat)&&(identical(other.waktuSelokanTersumbat, waktuSelokanTersumbat) || other.waktuSelokanTersumbat == waktuSelokanTersumbat)&&(identical(other.lokasiSelokanTersumbat, lokasiSelokanTersumbat) || other.lokasiSelokanTersumbat == lokasiSelokanTersumbat)&&(identical(other.resikoSelokanTersumbat, resikoSelokanTersumbat) || other.resikoSelokanTersumbat == resikoSelokanTersumbat)&&(identical(other.adaJalanRusak, adaJalanRusak) || other.adaJalanRusak == adaJalanRusak)&&(identical(other.lokasiJalanRusakGps, lokasiJalanRusakGps) || other.lokasiJalanRusakGps == lokasiJalanRusakGps)&&(identical(other.latitudeJalanRusak, latitudeJalanRusak) || other.latitudeJalanRusak == latitudeJalanRusak)&&(identical(other.longitudeJalanRusak, longitudeJalanRusak) || other.longitudeJalanRusak == longitudeJalanRusak)&&(identical(other.resikoJalanRusak, resikoJalanRusak) || other.resikoJalanRusak == resikoJalanRusak)&&(identical(other.adaLampuMati, adaLampuMati) || other.adaLampuMati == adaLampuMati)&&(identical(other.lokasiLampuMatiGps, lokasiLampuMatiGps) || other.lokasiLampuMatiGps == lokasiLampuMatiGps)&&(identical(other.latitudeLampuMati, latitudeLampuMati) || other.latitudeLampuMati == latitudeLampuMati)&&(identical(other.longitudeLampuMati, longitudeLampuMati) || other.longitudeLampuMati == longitudeLampuMati)&&(identical(other.resikoLampuMati, resikoLampuMati) || other.resikoLampuMati == resikoLampuMati)&&(identical(other.patrolTime, patrolTime) || other.patrolTime == patrolTime)&&(identical(other.waktuKejadian, waktuKejadian) || other.waktuKejadian == waktuKejadian)&&(identical(other.keterangan, keterangan) || other.keterangan == keterangan)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,sampahMenumpuk,selokanMampet,fasilitasRusak,kegiatanMengganggu,potensiBahaya,jalanBerlubang,lampuMati,laporanKeamanan,wargaBertengkar,tempatKurangAman,kerumunanTidakTertib,perluBantuanPetugas,gangguanKamtibmas,aktivitasMencurigakan,kehilanganLingkungan,wargaButuhBantuan,kelompokBerselisih,keluhanWarga,kejadianMenggangguWarga,perluTerusanRTRW,permasalahanSosial,kasusPerzinahan,orangTerlantar,adaSampahMenumpuk,waktuSampahMenumpuk,lokasiSampahMenumpuk,jenisSampahDominan,pengangkutanSesuaiJadwal,alasanPengangkutan,adaPembakaranSampah,waktuPembakaran,lokasiPembakaran,pembakaranDiberiTindakan,adaPencurian,waktuPencurian,lokasiPencurian,pelakuPencurianDiketahui,pencurianDilaporkanAparat,adaTawuran,waktuTawuran,lokasiTawuran,pelakuTawuranDiketahui,tawuranDilaporkanAparat,adaNarkoba,narkobaDilaporkanAparat,adaSelokanTersumbat,waktuSelokanTersumbat,lokasiSelokanTersumbat,resikoSelokanTersumbat,adaJalanRusak,lokasiJalanRusakGps,latitudeJalanRusak,longitudeJalanRusak,resikoJalanRusak,adaLampuMati,lokasiLampuMatiGps,latitudeLampuMati,longitudeLampuMati,resikoLampuMati,patrolTime,waktuKejadian,keterangan,timestamp]);

@override
String toString() {
  return 'RondaLaporanEntity(id: $id, sampahMenumpuk: $sampahMenumpuk, selokanMampet: $selokanMampet, fasilitasRusak: $fasilitasRusak, kegiatanMengganggu: $kegiatanMengganggu, potensiBahaya: $potensiBahaya, jalanBerlubang: $jalanBerlubang, lampuMati: $lampuMati, laporanKeamanan: $laporanKeamanan, wargaBertengkar: $wargaBertengkar, tempatKurangAman: $tempatKurangAman, kerumunanTidakTertib: $kerumunanTidakTertib, perluBantuanPetugas: $perluBantuanPetugas, gangguanKamtibmas: $gangguanKamtibmas, aktivitasMencurigakan: $aktivitasMencurigakan, kehilanganLingkungan: $kehilanganLingkungan, wargaButuhBantuan: $wargaButuhBantuan, kelompokBerselisih: $kelompokBerselisih, keluhanWarga: $keluhanWarga, kejadianMenggangguWarga: $kejadianMenggangguWarga, perluTerusanRTRW: $perluTerusanRTRW, permasalahanSosial: $permasalahanSosial, kasusPerzinahan: $kasusPerzinahan, orangTerlantar: $orangTerlantar, adaSampahMenumpuk: $adaSampahMenumpuk, waktuSampahMenumpuk: $waktuSampahMenumpuk, lokasiSampahMenumpuk: $lokasiSampahMenumpuk, jenisSampahDominan: $jenisSampahDominan, pengangkutanSesuaiJadwal: $pengangkutanSesuaiJadwal, alasanPengangkutan: $alasanPengangkutan, adaPembakaranSampah: $adaPembakaranSampah, waktuPembakaran: $waktuPembakaran, lokasiPembakaran: $lokasiPembakaran, pembakaranDiberiTindakan: $pembakaranDiberiTindakan, adaPencurian: $adaPencurian, waktuPencurian: $waktuPencurian, lokasiPencurian: $lokasiPencurian, pelakuPencurianDiketahui: $pelakuPencurianDiketahui, pencurianDilaporkanAparat: $pencurianDilaporkanAparat, adaTawuran: $adaTawuran, waktuTawuran: $waktuTawuran, lokasiTawuran: $lokasiTawuran, pelakuTawuranDiketahui: $pelakuTawuranDiketahui, tawuranDilaporkanAparat: $tawuranDilaporkanAparat, adaNarkoba: $adaNarkoba, narkobaDilaporkanAparat: $narkobaDilaporkanAparat, adaSelokanTersumbat: $adaSelokanTersumbat, waktuSelokanTersumbat: $waktuSelokanTersumbat, lokasiSelokanTersumbat: $lokasiSelokanTersumbat, resikoSelokanTersumbat: $resikoSelokanTersumbat, adaJalanRusak: $adaJalanRusak, lokasiJalanRusakGps: $lokasiJalanRusakGps, latitudeJalanRusak: $latitudeJalanRusak, longitudeJalanRusak: $longitudeJalanRusak, resikoJalanRusak: $resikoJalanRusak, adaLampuMati: $adaLampuMati, lokasiLampuMatiGps: $lokasiLampuMatiGps, latitudeLampuMati: $latitudeLampuMati, longitudeLampuMati: $longitudeLampuMati, resikoLampuMati: $resikoLampuMati, patrolTime: $patrolTime, waktuKejadian: $waktuKejadian, keterangan: $keterangan, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$RondaLaporanEntityCopyWith<$Res> implements $RondaLaporanEntityCopyWith<$Res> {
  factory _$RondaLaporanEntityCopyWith(_RondaLaporanEntity value, $Res Function(_RondaLaporanEntity) _then) = __$RondaLaporanEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, int sampahMenumpuk, int selokanMampet, int fasilitasRusak, int kegiatanMengganggu, int potensiBahaya, int jalanBerlubang, int lampuMati, int laporanKeamanan, int wargaBertengkar, int tempatKurangAman, int kerumunanTidakTertib, int perluBantuanPetugas, int gangguanKamtibmas, int aktivitasMencurigakan, int kehilanganLingkungan, int wargaButuhBantuan, int kelompokBerselisih, int keluhanWarga, int kejadianMenggangguWarga, int perluTerusanRTRW, int permasalahanSosial, int kasusPerzinahan, int orangTerlantar, bool adaSampahMenumpuk, String? waktuSampahMenumpuk, String? lokasiSampahMenumpuk, String? jenisSampahDominan, bool pengangkutanSesuaiJadwal, String? alasanPengangkutan, bool adaPembakaranSampah, String? waktuPembakaran, String? lokasiPembakaran, String? pembakaranDiberiTindakan, bool adaPencurian, String? waktuPencurian, String? lokasiPencurian, String? pelakuPencurianDiketahui, String? pencurianDilaporkanAparat, bool adaTawuran, String? waktuTawuran, String? lokasiTawuran, String? pelakuTawuranDiketahui, String? tawuranDilaporkanAparat, bool adaNarkoba, String? narkobaDilaporkanAparat, bool adaSelokanTersumbat, String? waktuSelokanTersumbat, String? lokasiSelokanTersumbat, String? resikoSelokanTersumbat, bool adaJalanRusak, String? lokasiJalanRusakGps, double? latitudeJalanRusak, double? longitudeJalanRusak, String? resikoJalanRusak, bool adaLampuMati, String? lokasiLampuMatiGps, double? latitudeLampuMati, double? longitudeLampuMati, String? resikoLampuMati, String? patrolTime, String? waktuKejadian, String keterangan, DateTime? timestamp
});




}
/// @nodoc
class __$RondaLaporanEntityCopyWithImpl<$Res>
    implements _$RondaLaporanEntityCopyWith<$Res> {
  __$RondaLaporanEntityCopyWithImpl(this._self, this._then);

  final _RondaLaporanEntity _self;
  final $Res Function(_RondaLaporanEntity) _then;

/// Create a copy of RondaLaporanEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? sampahMenumpuk = null,Object? selokanMampet = null,Object? fasilitasRusak = null,Object? kegiatanMengganggu = null,Object? potensiBahaya = null,Object? jalanBerlubang = null,Object? lampuMati = null,Object? laporanKeamanan = null,Object? wargaBertengkar = null,Object? tempatKurangAman = null,Object? kerumunanTidakTertib = null,Object? perluBantuanPetugas = null,Object? gangguanKamtibmas = null,Object? aktivitasMencurigakan = null,Object? kehilanganLingkungan = null,Object? wargaButuhBantuan = null,Object? kelompokBerselisih = null,Object? keluhanWarga = null,Object? kejadianMenggangguWarga = null,Object? perluTerusanRTRW = null,Object? permasalahanSosial = null,Object? kasusPerzinahan = null,Object? orangTerlantar = null,Object? adaSampahMenumpuk = null,Object? waktuSampahMenumpuk = freezed,Object? lokasiSampahMenumpuk = freezed,Object? jenisSampahDominan = freezed,Object? pengangkutanSesuaiJadwal = null,Object? alasanPengangkutan = freezed,Object? adaPembakaranSampah = null,Object? waktuPembakaran = freezed,Object? lokasiPembakaran = freezed,Object? pembakaranDiberiTindakan = freezed,Object? adaPencurian = null,Object? waktuPencurian = freezed,Object? lokasiPencurian = freezed,Object? pelakuPencurianDiketahui = freezed,Object? pencurianDilaporkanAparat = freezed,Object? adaTawuran = null,Object? waktuTawuran = freezed,Object? lokasiTawuran = freezed,Object? pelakuTawuranDiketahui = freezed,Object? tawuranDilaporkanAparat = freezed,Object? adaNarkoba = null,Object? narkobaDilaporkanAparat = freezed,Object? adaSelokanTersumbat = null,Object? waktuSelokanTersumbat = freezed,Object? lokasiSelokanTersumbat = freezed,Object? resikoSelokanTersumbat = freezed,Object? adaJalanRusak = null,Object? lokasiJalanRusakGps = freezed,Object? latitudeJalanRusak = freezed,Object? longitudeJalanRusak = freezed,Object? resikoJalanRusak = freezed,Object? adaLampuMati = null,Object? lokasiLampuMatiGps = freezed,Object? latitudeLampuMati = freezed,Object? longitudeLampuMati = freezed,Object? resikoLampuMati = freezed,Object? patrolTime = freezed,Object? waktuKejadian = freezed,Object? keterangan = null,Object? timestamp = freezed,}) {
  return _then(_RondaLaporanEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
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
as String?,patrolTime: freezed == patrolTime ? _self.patrolTime : patrolTime // ignore: cast_nullable_to_non_nullable
as String?,waktuKejadian: freezed == waktuKejadian ? _self.waktuKejadian : waktuKejadian // ignore: cast_nullable_to_non_nullable
as String?,keterangan: null == keterangan ? _self.keterangan : keterangan // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
