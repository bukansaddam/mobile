part of 'presensi_bloc.dart';

enum PresensiType { masuk, keluar }

enum PresensiStatus {
  initial,
  loadingLocation,
  loaded,
  submitting,
  success,
  failure,
}

class PresensiState extends Equatable {
  final bool hasCheckedIn;
  final PresensiType? lastSubmittedType;
  final PresensiStatus status;
  final double userLatitude;
  final double userLongitude;
  final String userName;
  final String kecamatan;
  final String kelurahan;
  final String address;
  final String rt;
  final String rw;
  final String locationName;
  final bool isInsideWorkingArea;
  final String? errorMessage;
  final PresensiDataEntity? lastResult;

  const PresensiState({
    this.hasCheckedIn = false,
    this.lastSubmittedType,
    this.status = PresensiStatus.initial,
    this.userLatitude = -6.2088,
    this.userLongitude = 106.8456,
    this.userName = 'Pengguna',
    this.kecamatan = 'Gambir',
    this.kelurahan = 'Gambir',
    this.address = 'Jl. Medan Merdeka Barat No. 12',
    this.rt = '005',
    this.rw = '002',
    this.locationName = 'PT Semesta Mahadata Indonesia',
    this.isInsideWorkingArea = true,
    this.errorMessage,
    this.lastResult,
  });

  PresensiType get presensiType =>
      hasCheckedIn ? PresensiType.keluar : PresensiType.masuk;

  String get presensiTypeTitle =>
      hasCheckedIn ? 'Perbarui Posisi Keluar' : 'Perbarui Posisi Masuk';

  String get lastSubmittedTypeTitle => lastSubmittedType == PresensiType.keluar
      ? 'Perbarui Posisi Keluar'
      : 'Perbarui Posisi Masuk';

  PresensiState copyWith({
    bool? hasCheckedIn,
    PresensiType? lastSubmittedType,
    PresensiStatus? status,
    double? userLatitude,
    double? userLongitude,
    String? userName,
    String? kecamatan,
    String? kelurahan,
    String? address,
    String? rt,
    String? rw,
    String? locationName,
    bool? isInsideWorkingArea,
    String? errorMessage,
    PresensiDataEntity? lastResult,
  }) {
    return PresensiState(
      hasCheckedIn: hasCheckedIn ?? this.hasCheckedIn,
      lastSubmittedType: lastSubmittedType ?? this.lastSubmittedType,
      status: status ?? this.status,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      userName: userName ?? this.userName,
      kecamatan: kecamatan ?? this.kecamatan,
      kelurahan: kelurahan ?? this.kelurahan,
      address: address ?? this.address,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      locationName: locationName ?? this.locationName,
      isInsideWorkingArea: isInsideWorkingArea ?? this.isInsideWorkingArea,
      errorMessage: errorMessage,
      lastResult: lastResult ?? this.lastResult,
    );
  }

  @override
  List<Object?> get props => [
    hasCheckedIn,
    lastSubmittedType,
    status,
    userLatitude,
    userLongitude,
    userName,
    kecamatan,
    kelurahan,
    address,
    rt,
    rw,
    locationName,
    isInsideWorkingArea,
    errorMessage,
    lastResult,
  ];
}
