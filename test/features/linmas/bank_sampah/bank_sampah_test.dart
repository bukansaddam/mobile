import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:akar/features/linmas/bank_sampah/core/constants/bank_sampah_constants.dart';
import 'package:akar/features/linmas/bank_sampah/data/datasources/bank_sampah_local_datasource.dart';
import 'package:akar/features/linmas/bank_sampah/data/repositories/bank_sampah_repository_impl.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_location_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/delete_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_locations_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_reports_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences sharedPreferences;
  late BankSampahLocalDatasource localDatasource;
  late BankSampahRepositoryImpl repository;
  late GetBankSampahReportsUsecase getReportsUsecase;
  late AddBankSampahReportUsecase addReportUsecase;
  late DeleteBankSampahReportUsecase deleteReportUsecase;
  late GetBankSampahLocationsUsecase getLocationsUsecase;
  late AddBankSampahLocationUsecase addLocationUsecase;
  late BankSampahBloc bloc;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    localDatasource = BankSampahLocalDatasourceImpl(
      sharedPreferences: sharedPreferences,
    );
    repository = BankSampahRepositoryImpl(localDatasource: localDatasource);

    getReportsUsecase = GetBankSampahReportsUsecase(repository);
    addReportUsecase = AddBankSampahReportUsecase(repository);
    deleteReportUsecase = DeleteBankSampahReportUsecase(repository);
    getLocationsUsecase = GetBankSampahLocationsUsecase(repository);
    addLocationUsecase = AddBankSampahLocationUsecase(repository);

    bloc = BankSampahBloc(
      getReportsUsecase: getReportsUsecase,
      addReportUsecase: addReportUsecase,
      deleteReportUsecase: deleteReportUsecase,
      getLocationsUsecase: getLocationsUsecase,
      addLocationUsecase: addLocationUsecase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('Initial load fetches default locations and reports', () async {
    bloc.add(FetchBankSampahDataEvent());
    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<BankSampahState>((state) =>
            state.locations.isNotEmpty &&
            state.reports.isNotEmpty &&
            state.totalLaporanCount > 0 &&
            state.totalBeratKg > 0 &&
            state.totalNilaiRupiah > 0),
      ),
    );
  });

  test('Nearest location and formatted distance is computed', () async {
    bloc.add(FetchBankSampahDataEvent());
    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<BankSampahState>((state) {
          final nearest = state.nearestLocation;
          return nearest != null &&
              nearest.distanceMeters != null &&
              nearest.formattedDistance.isNotEmpty;
        }),
      ),
    );
  });

  test('Add new report calculates value as berat * 5000 automatically', () async {
    bloc.add(FetchBankSampahDataEvent());
    await bloc.stream.firstWhere((s) => s.reports.isNotEmpty);

    final initialCount = bloc.state.reports.length;
    const berat = 4.5;
    const expectedNilai = berat * BankSampahConstants.hargaPerKg;

    bloc.add(const AddBankSampahReportEvent(
      bankSampahId: 'BS-001',
      bankSampahNama: 'Bank Sampah Berkah Mandiri',
      jenisSampah: 'Organik',
      beratKg: berat,
      petugasNama: 'Budi Linmas',
      catatan: 'Testing report',
    ));

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<BankSampahState>((state) =>
            state.reports.length == initialCount + 1 &&
            state.reports.first.beratKg == berat &&
            state.reports.first.nilaiRupiah == expectedNilai &&
            state.reports.first.jenisSampah == 'Organik'),
      ),
    );
  });

  test('Delete report removes it from the list and recalculates stats', () async {
    bloc.add(FetchBankSampahDataEvent());
    await bloc.stream.firstWhere((s) => s.reports.isNotEmpty);

    final reportToDelete = bloc.state.reports.first;
    final id = reportToDelete.id;
    final initialTotalBerat = bloc.state.totalBeratKg;

    bloc.add(DeleteBankSampahReportEvent(id));

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<BankSampahState>((state) =>
            !state.reports.any((r) => r.id == id) &&
            (state.totalBeratKg - (initialTotalBerat - reportToDelete.beratKg)).abs() < 0.001),
      ),
    );
  });
}
