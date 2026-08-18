import 'package:akar/features/linmas/bank_sampah/core/constants/bank_sampah_constants.dart';
import 'package:akar/features/linmas/bank_sampah/data/datasources/bank_sampah_local_datasource.dart';
import 'package:akar/features/linmas/bank_sampah/data/repositories/bank_sampah_repository_impl.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_location_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/delete_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_locations_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_reports_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/provider/bank_sampah_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late BankSampahProvider provider;

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

    provider = BankSampahProvider(
      getReportsUsecase: getReportsUsecase,
      addReportUsecase: addReportUsecase,
      deleteReportUsecase: deleteReportUsecase,
      getLocationsUsecase: getLocationsUsecase,
      addLocationUsecase: addLocationUsecase,
    );
  });

  test('Initial load fetches default locations and reports', () async {
    await provider.fetchInitialData();
    expect(provider.locations.isNotEmpty, true);
    expect(provider.reports.isNotEmpty, true);
    expect(provider.totalLaporanCount, greaterThan(0));
    expect(provider.totalBeratKg, greaterThan(0));
    expect(provider.totalNilaiRupiah, greaterThan(0));
  });

  test('Nearest location and formatted distance is computed', () async {
    await provider.fetchInitialData();
    final nearest = provider.nearestLocation;
    expect(nearest, isNotNull);
    expect(nearest!.distanceMeters, isNotNull);
    expect(nearest.formattedDistance.isNotEmpty, true);

    for (int i = 0; i < provider.locations.length - 1; i++) {
      final current = provider.locations[i].distanceMeters ?? 0.0;
      final next = provider.locations[i + 1].distanceMeters ?? double.infinity;
      expect(current <= next, true);
    }
  });

  test(
    'Add new report calculates value as berat * 5000 automatically',
    () async {
      await provider.fetchInitialData();
      final initialCount = provider.reports.length;

      const berat = 4.5;
      const expectedNilai = berat * BankSampahConstants.hargaPerKg;

      final success = await provider.addReport(
        bankSampahId: 'BS-001',
        bankSampahNama: 'Bank Sampah Berkah Mandiri',
        jenisSampah: 'Organik',
        beratKg: berat,
        petugasNama: 'Budi Linmas',
        catatan: 'Testing report',
      );

      expect(success, true);
      expect(provider.reports.length, initialCount + 1);
      final newlyAdded = provider.reports.first;
      expect(newlyAdded.beratKg, berat);
      expect(newlyAdded.nilaiRupiah, expectedNilai);
      expect(newlyAdded.jenisSampah, 'Organik');
    },
  );

  test('Filter by search query and jenis sampah works correctly', () async {
    await provider.fetchInitialData();

    provider.setSelectedJenisSampahFilter('Organik');
    expect(
      provider.filteredReports.every(
        (r) => r.jenisSampah.toLowerCase() == 'organik',
      ),
      true,
    );

    provider.setSearchQuery('Melati Bersih');
    expect(
      provider.filteredReports.every(
        (r) =>
            r.jenisSampah.toLowerCase() == 'organik' &&
            r.bankSampahNama.toLowerCase().contains('melati bersih'),
      ),
      true,
    );

    provider.clearFilters();
    expect(provider.filteredReports.length, provider.reports.length);

    provider.setSortOption(BankSampahSortOption.bobotTerbanyak);
    final sortedByBerat = provider.filteredReports;
    for (int i = 0; i < sortedByBerat.length - 1; i++) {
      expect(sortedByBerat[i].beratKg >= sortedByBerat[i + 1].beratKg, true);
    }

    provider.setSelectedBankSampahFilter('Bank Sampah Berkah Mandiri');
    expect(
      provider.filteredReports.every(
        (r) => r.bankSampahNama == 'Bank Sampah Berkah Mandiri',
      ),
      true,
    );
  });

  test(
    'Delete report removes it from the list and recalculates stats',
    () async {
      await provider.fetchInitialData();
      final reportToDelete = provider.reports.first;
      final id = reportToDelete.id;
      final initialTotalBerat = provider.totalBeratKg;

      final success = await provider.deleteReport(id);
      expect(success, true);
      expect(provider.reports.any((r) => r.id == id), false);
      expect(
        provider.totalBeratKg,
        closeTo(initialTotalBerat - reportToDelete.beratKg, 0.001),
      );
    },
  );
}
