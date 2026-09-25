import 'package:flutter_test/flutter_test.dart';
import 'package:akar/features/linmas/ronda_malam/data/datasources/ronda_remote_datasource.dart';
import 'package:akar/features/linmas/ronda_malam/data/models/ronda_laporan_model.dart';
import 'package:akar/features/linmas/ronda_malam/data/repositories/ronda_repository_impl.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';
import 'package:akar/features/linmas/ronda_malam/domain/usecases/submit_ronda_laporan_usecase.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/bloc/ronda_bloc/ronda_bloc.dart';

class FakeRondaRemoteDatasource implements RondaRemoteDatasource {
  RondaLaporanModel? lastSubmittedModel;
  bool shouldThrow = false;
  String? returnId;

  @override
  Future<RondaLaporanModel> submitLaporan(RondaLaporanModel model) async {
    if (shouldThrow) {
      throw Exception('Koneksi terputus');
    }
    lastSubmittedModel = model;
    return model.copyWith(id: returnId ?? 'RND-12345');
  }
}

void main() {
  group('RondaLaporanModel Payload & Mapping', () {
    test('toDailyReportPayload produces exact expected JSON schema', () {
      final model = RondaLaporanModel(
        patrolTime: '16:00',
        waktuKejadian: '15:30',
        adaSampahMenumpuk: true,
        waktuSampahMenumpuk: '15:30',
        lokasiSampahMenumpuk: 'TPS Pasar Lama',
        jenisSampahDominan: 'Organik & Plastik',
        pengangkutanSesuaiJadwal: false,
        alasanPengangkutan: 'Truk pengangkut terlambat datang',
        adaPembakaranSampah: true,
        waktuPembakaran: '15:45',
        lokasiPembakaran: 'Lahan Kosong RT 02',
        pembakaranDiberiTindakan: 'Dihimbau untuk dipadamkan',
        adaPencurian: false,
        pelakuPencurianDiketahui: 'tidak',
        pencurianDilaporkanAparat: 'tidak',
        adaTawuran: false,
        adaNarkoba: false,
        adaSelokanTersumbat: false,
        adaJalanRusak: false,
        resikoJalanRusak: 'str',
        adaLampuMati: false,
        keterangan: 'Patroli selesai dalam keadaan aman dan terkendali.',
      );

      final payload = model.toDailyReportPayload();

      expect(payload['patrol_time'], '16:00');
      expect(payload['waktu_kejadian'], '15:30');
      expect(payload['notes'], 'Patroli selesai dalam keadaan aman dan terkendali.');

      final checklist = payload['patrol_checklist'] as Map<String, dynamic>;

      // Penumpukan Sampah
      expect(checklist['penumpukan_sampah'], {
        'answer': 'ya',
        'waktu_kejadian': '15:30',
        'lokasi_kejadian': 'TPS Pasar Lama',
        'jenis_sampah_dominan': 'Organik & Plastik',
      });

      // Jadwal Pengangkutan
      expect(checklist['jadwal_pengangkutan'], {
        'answer': 'tidak',
        'alasan': 'Truk pengangkut terlambat datang',
      });

      // Pembakaran Sampah
      expect(checklist['pembakaran_sampah'], {
        'answer': 'ya',
        'waktu_kejadian': '15:45',
        'lokasi_kejadian': 'Lahan Kosong RT 02',
        'tindakan': 'Dihimbau untuk dipadamkan',
      });

      // Pencurian / Perampasan
      expect(checklist['pencurian_perampasan'], {
        'answer': 'tidak',
        'pelaku_diketahui': 'tidak',
        'lapor_aparat': 'tidak',
      });

      // Perkelahian Kelompok
      expect(checklist['perkelahian_kelompok'], {
        'answer': 'tidak',
      });

      // Penyalahgunaan Narkoba
      expect(checklist['penyalahgunaan_narkoba'], {
        'answer': 'tidak',
      });

      // Selokan Tersumbat
      expect(checklist['selokan_tersumbat'], {
        'answer': 'tidak',
      });

      // Jalan Rusak
      expect(checklist['jalan_rusak'], {
        'answer': 'tidak',
        'resiko': 'str',
      });

      // Lampu Mati
      expect(checklist['lampu_mati'], {
        'answer': 'tidak',
      });
    });

    test('toDailyReportPayload handles affirmative security and environment flags', () {
      final model = RondaLaporanModel(
        patrolTime: '21:00',
        waktuKejadian: '20:30',
        adaPencurian: true,
        waktuPencurian: '20:15',
        lokasiPencurian: 'Jl Mawar',
        pelakuPencurianDiketahui: 'Ya',
        pencurianDilaporkanAparat: 'Ya',
        adaTawuran: true,
        waktuTawuran: '20:30',
        lokasiTawuran: 'Perempatan',
        pelakuTawuranDiketahui: 'Ya',
        tawuranDilaporkanAparat: 'Ya',
        adaNarkoba: true,
        narkobaDilaporkanAparat: 'Ya',
        adaSelokanTersumbat: true,
        waktuSelokanTersumbat: '19:00',
        lokasiSelokanTersumbat: 'RT 01',
        resikoSelokanTersumbat: 'Banjir saat hujan',
        adaJalanRusak: true,
        lokasiJalanRusakGps: '-6.2, 106.8',
        resikoJalanRusak: 'Kecelakaan motor',
        adaLampuMati: true,
        lokasiLampuMatiGps: '-6.21, 106.81',
        resikoLampuMati: 'Rawan kejahatan malam',
        pengangkutanSesuaiJadwal: true,
      );

      final payload = model.toDailyReportPayload();
      final checklist = payload['patrol_checklist'] as Map<String, dynamic>;

      expect(checklist['pencurian_perampasan']['answer'], 'ya');
      expect(checklist['pencurian_perampasan']['pelaku_diketahui'], 'ya');
      expect(checklist['pencurian_perampasan']['lapor_aparat'], 'ya');
      expect(checklist['pencurian_perampasan']['lokasi_kejadian'], 'Jl Mawar');

      expect(checklist['perkelahian_kelompok']['answer'], 'ya');
      expect(checklist['perkelahian_kelompok']['pelaku_diketahui'], 'ya');

      expect(checklist['penyalahgunaan_narkoba']['answer'], 'ya');
      expect(checklist['penyalahgunaan_narkoba']['lapor_aparat'], 'ya');

      expect(checklist['selokan_tersumbat']['answer'], 'ya');
      expect(checklist['selokan_tersumbat']['resiko'], 'Banjir saat hujan');

      expect(checklist['jalan_rusak']['answer'], 'ya');
      expect(checklist['jalan_rusak']['resiko'], 'Kecelakaan motor');
      expect(checklist['jalan_rusak']['lokasi_kejadian'], '-6.2, 106.8');
      expect(checklist['jalan_rusak']['latitude'], -6.2);
      expect(checklist['jalan_rusak']['longitude'], 106.8);

      expect(checklist['lampu_mati']['answer'], 'ya');
      expect(checklist['lampu_mati']['resiko'], 'Rawan kejahatan malam');
      expect(checklist['lampu_mati']['lokasi_kejadian'], '-6.21, 106.81');
      expect(checklist['lampu_mati']['latitude'], -6.21);
      expect(checklist['lampu_mati']['longitude'], 106.81);

      expect(checklist['jadwal_pengangkutan']['answer'], 'ya');
      expect(checklist['jadwal_pengangkutan'].containsKey('alasan'), isFalse);
    });

    test('toDailyReportPayload includes explicit coordinates for jalan_rusak and lampu_mati', () {
      final model = RondaLaporanModel(
        adaJalanRusak: true,
        lokasiJalanRusakGps: 'Jl. Melati No. 5',
        latitudeJalanRusak: -6.237643,
        longitudeJalanRusak: 106.853477,
        resikoJalanRusak: 'Rawan kecelakaan',
        adaLampuMati: true,
        lokasiLampuMatiGps: 'Tiang Listrik Musholla',
        latitudeLampuMati: -6.237650,
        longitudeLampuMati: 106.853490,
        resikoLampuMati: 'Area gelap',
      );

      final payload = model.toDailyReportPayload();
      final checklist = payload['patrol_checklist'] as Map<String, dynamic>;

      expect(checklist['jalan_rusak']['answer'], 'ya');
      expect(checklist['jalan_rusak']['lokasi_kejadian'], 'Jl. Melati No. 5');
      expect(checklist['jalan_rusak']['latitude'], -6.237643);
      expect(checklist['jalan_rusak']['longitude'], 106.853477);
      expect(checklist['jalan_rusak']['resiko'], 'Rawan kecelakaan');

      expect(checklist['lampu_mati']['answer'], 'ya');
      expect(checklist['lampu_mati']['lokasi_kejadian'], 'Tiang Listrik Musholla');
      expect(checklist['lampu_mati']['latitude'], -6.237650);
      expect(checklist['lampu_mati']['longitude'], 106.853490);
      expect(checklist['lampu_mati']['resiko'], 'Area gelap');
    });

    test('fromApiResponse extracts ID and fallback values properly', () {
      final fallback = const RondaLaporanModel(
        patrolTime: '10:00',
        keterangan: 'Test notes',
      );

      final fromMap = RondaLaporanModel.fromApiResponse(
        {'id': 'REP-999', 'status': 'success'},
        fallback: fallback,
      );
      expect(fromMap.id, 'REP-999');
      expect(fromMap.patrolTime, '10:00');
      expect(fromMap.keterangan, 'Test notes');

      final fromNested = RondaLaporanModel.fromApiResponse(
        {
          'data': {'report_id': 777}
        },
        fallback: fallback,
      );
      expect(fromNested.id, '777');
    });
  });

  group('RondaRepositoryImpl', () {
    late FakeRondaRemoteDatasource fakeDatasource;
    late RondaRepositoryImpl repository;

    setUp(() {
      fakeDatasource = FakeRondaRemoteDatasource();
      repository = RondaRepositoryImpl(remoteDatasource: fakeDatasource);
    });

    test('submitLaporan calls datasource and returns Right(RondaLaporanEntity)', () async {
      final entity = const RondaLaporanEntity(
        patrolTime: '16:00',
        waktuKejadian: '15:30',
        keterangan: 'Aman',
      );

      final result = await repository.submitLaporan(entity);

      expect(result.isRight, isTrue);
      result.fold(
        (_) => fail('Should be right'),
        (saved) {
          expect(saved.id, 'RND-12345');
          expect(saved.patrolTime, '16:00');
          expect(saved.keterangan, 'Aman');
        },
      );
    });

    test('submitLaporan returns Left(ServerFailure) on datasource exception', () async {
      fakeDatasource.shouldThrow = true;
      final entity = const RondaLaporanEntity(keterangan: 'Aman');

      final result = await repository.submitLaporan(entity);

      expect(result.isLeft, isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('Koneksi terputus')),
        (_) => fail('Should be left'),
      );
    });
  });

  group('RondaBloc', () {
    late FakeRondaRemoteDatasource fakeDatasource;
    late RondaRepositoryImpl repository;
    late SubmitRondaLaporanUsecase usecase;
    late RondaBloc bloc;

    setUp(() {
      fakeDatasource = FakeRondaRemoteDatasource();
      repository = RondaRepositoryImpl(remoteDatasource: fakeDatasource);
      usecase = SubmitRondaLaporanUsecase(repository);
      bloc = RondaBloc(submitRondaLaporanUsecase: usecase);
    });

    tearDown(() {
      bloc.close();
    });

    test('UpdateRondaFieldEvent updates patrolTime and waktuKejadian in state', () async {
      bloc.add(const UpdateRondaFieldEvent(
        patrolTime: '18:00',
        waktuKejadian: '17:45',
        keterangan: 'Catatan patroli malam',
      ));

      await expectLater(
        bloc.stream,
        emits(predicate<RondaState>((state) {
          return state.patrolTime == '18:00' &&
              state.waktuKejadian == '17:45' &&
              state.keterangan == 'Catatan patroli malam';
        })),
      );
    });

    test('SubmitRondaLaporanEvent emits submitting then success on successful API response with time now', () async {
      bloc.add(const UpdateRondaFieldEvent(
        keterangan: 'Semua aman',
      ));
      await Future.delayed(const Duration(milliseconds: 10));

      bloc.add(SubmitRondaLaporanEvent());

      final states = <RondaState>[];
      final subscription = bloc.stream.listen(states.add);

      await Future.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(states.any((s) => s.status == RondaStatus.submitting), isTrue);
      final successState = states.firstWhere((s) => s.status == RondaStatus.success);
      expect(successState.lastResult?.id, 'RND-12345');
      final now = DateTime.now();
      final expectedTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      expect(successState.lastResult?.patrolTime, expectedTime);
      expect(successState.lastResult?.waktuKejadian, expectedTime);
    });

    test('SubmitRondaLaporanEvent emits failure on server error', () async {
      fakeDatasource.shouldThrow = true;

      bloc.add(SubmitRondaLaporanEvent());

      final states = <RondaState>[];
      final subscription = bloc.stream.listen(states.add);

      await Future.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(states.any((s) => s.status == RondaStatus.submitting), isTrue);
      final failureState = states.firstWhere((s) => s.status == RondaStatus.failure);
      expect(failureState.errorMessage, isNotNull);
    });
  });
}
