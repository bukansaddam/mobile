part of 'presensi_bloc.dart';

abstract class PresensiEvent extends Equatable {
  const PresensiEvent();

  @override
  List<Object?> get props => [];
}

class InitPresensiLocationEvent extends PresensiEvent {
  final String userName;

  const InitPresensiLocationEvent({this.userName = ''});

  @override
  List<Object?> get props => [userName];
}

class UpdatePresensiFieldEvent extends PresensiEvent {
  final String? rt;
  final String? rw;
  final String? kecamatan;
  final String? kelurahan;
  final String? address;
  final bool? isInsideWorkingArea;

  const UpdatePresensiFieldEvent({
    this.rt,
    this.rw,
    this.kecamatan,
    this.kelurahan,
    this.address,
    this.isInsideWorkingArea,
  });

  @override
  List<Object?> get props => [
    rt,
    rw,
    kecamatan,
    kelurahan,
    address,
    isInsideWorkingArea,
  ];
}

class SubmitPresensiEvent extends PresensiEvent {}
