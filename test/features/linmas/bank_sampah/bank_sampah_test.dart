import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:akar/features/linmas/bank_sampah/core/constants/bank_sampah_constants.dart';
import 'package:akar/features/linmas/bank_sampah/data/datasources/bank_sampah_remote_datasource.dart';
import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_location_model.dart';
import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_report_model.dart';
import 'package:akar/features/linmas/bank_sampah/data/repositories/bank_sampah_repository_impl.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_location_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/delete_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_locations_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_reports_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';

class FakeBankSampahRemoteDataSource implements BankSampahRemoteDataSource {
  BankSampahMyDepositsResponseModel? response;
  List<BankSampahLocationModel>? mapLocations;
  bool shouldThrow = false;

  @override
  Future<BankSampahMyDepositsResponseModel> getMyDeposits({
    int? page,
    int? perPage,
  }) async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    return response ??
        const BankSampahMyDepositsResponseModel(
          success: true,
          data: [],
          summary: BankSampahSummaryModel(),
        );
  }

  @override
  Future<List<BankSampahLocationModel>> getBankSampahMap() async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    return mapLocations ?? [];
  }

  @override
  Future<BankSampahReportModel> addDeposit({
    required int bankId,
    required String wasteType,
    required double weightKg,
    required String reportDate,
    String? notes,
    File? photo,
  }) async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    return BankSampahReportModel(
      id: '362416',
      bankSampahId: bankId.toString(),
      bankSampahNama: 'Bank Sampah $bankId',
      jenisSampah: wasteType,
      beratKg: weightKg,
      nilaiRupiah: weightKg * 5000,
      catatan: notes ?? '',
      createdAt: DateTime.tryParse(reportDate) ?? DateTime.now(),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeBankSampahRemoteDataSource remoteDataSource;
  late BankSampahRepositoryImpl repository;
  late GetBankSampahReportsUsecase getReportsUsecase;
  late AddBankSampahReportUsecase addReportUsecase;
  late DeleteBankSampahReportUsecase deleteReportUsecase;
  late GetBankSampahLocationsUsecase getLocationsUsecase;
  late AddBankSampahLocationUsecase addLocationUsecase;
  late BankSampahBloc bloc;

  final initialReport = BankSampahReportModel(
    id: '362415',
    bankSampahId: '7690',
    bankSampahNama: 'BS JALAK GREEN COLLECTION',
    jenisSampah: 'Organik',
    beratKg: 10.0,
    nilaiRupiah: 50000.0,
    catatan: 'Sampah awal',
    createdAt: DateTime(2026, 9, 20),
  );

  const initialLocation = BankSampahLocationModel(
    id: '7690',
    nama: 'BS JALAK GREEN COLLECTION',
    alamat: 'Cipinang Besar Selatan',
    latitude: -6.2297588,
    longitude: 106.8831983,
  );

  setUp(() {
    remoteDataSource = FakeBankSampahRemoteDataSource();
    remoteDataSource.response = BankSampahMyDepositsResponseModel(
      success: true,
      data: [initialReport],
      summary: const BankSampahSummaryModel(
        totalKg: 10.0,
        totalPendapatan: 50000.0,
        totalSetoran: 1,
      ),
    );
    remoteDataSource.mapLocations = [initialLocation];

    repository = BankSampahRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

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

  group('API Model Parsing Tests', () {
    test('parses live backend JSON response correctly', () {
      final json = {
        "success": true,
        "data": [
          {
            "id": 362415,
            "reportDate": "2026-09-13",
            "time": "09:27",
            "status": "verified",
            "statusLabel": "Terverifikasi",
            "weight": 38.9,
            "weight_kg": 38.9,
            "value": 194500,
            "total_pendapatan": 194500,
            "photo": null,
            "photo_path": null,
            "photo_url": null,
            "photoUrl": null,
            "notes": "Kardus bersih",
            "member": {
              "id": 171948,
              "name": "Siti Rahmawati",
              "villageId": 25695,
              "village": "Tebet Timur"
            },
            "bank": {
              "id": 8692,
              "name": "Bank Sampah Jaya Sungai Gampa",
              "region": "Sungai Gampa"
            },
            "wasteType": {
              "id": 11,
              "name": "Organik"
            }
          }
        ],
        "summary": {
          "total_kg": 38.9,
          "total_pendapatan": 194500,
          "total_setoran": 1,
          "verified_kg": 38.9,
          "verified_pendapatan": 194500,
          "pending_kg": 0,
          "pending_pendapatan": 0,
          "conversion_price_per_kg": 5000
        },
        "meta": {
          "total": 1,
          "current_page": 1,
          "per_page": 20,
          "last_page": 1
        },
        "message": "OK"
      };

      final responseModel = BankSampahMyDepositsResponseModel.fromJson(json);

      expect(responseModel.success, true);
      expect(responseModel.data.length, 1);

      final item = responseModel.data.first;
      expect(item.id, '362415');
      expect(item.bankSampahId, '8692');
      expect(item.bankSampahNama, 'Bank Sampah Jaya Sungai Gampa');
      expect(item.bankSampahRegion, 'Sungai Gampa');
      expect(item.jenisSampah, 'Organik');
      expect(item.beratKg, 38.9);
      expect(item.nilaiRupiah, 194500.0);
      expect(item.status, 'verified');
      expect(item.statusLabel, 'Terverifikasi');
      expect(item.catatan, 'Kardus bersih');
      expect(item.createdAt.year, 2026);
      expect(item.createdAt.month, 9);
      expect(item.createdAt.day, 13);
      expect(item.createdAt.hour, 9);
      expect(item.createdAt.minute, 27);

      final summary = responseModel.summary;
      expect(summary?.totalKg, 38.9);
      expect(summary?.totalPendapatan, 194500);
      expect(summary?.totalSetoran, 1);

      final domain = responseModel.toDomain();
      expect(domain.reports.length, 1);
      expect(domain.reports.first.bankSampahNama, 'Bank Sampah Jaya Sungai Gampa');
      expect(domain.summary?.totalKg, 38.9);
    });

    test('formats relative photo path with /storage/ correctly', () {
      final jsonWithRelativePhoto = {
        "id": 101,
        "reportDate": "2026-09-23",
        "weight": 5.0,
        "photo": "deposits/sample_image.jpg",
        "bank": {"id": 1, "name": "Bank 1"},
        "wasteType": {"name": "Organik"}
      };
      final model = BankSampahReportModel.fromJson(jsonWithRelativePhoto);
      expect(model.fotoUrl, contains('/storage/deposits/sample_image.jpg'));

      final entity = model.toDomain();
      expect(entity.displayPhotoUrl, contains('/storage/deposits/sample_image.jpg'));
    });

    test('preserves full http/https photo url as is', () {
      final jsonWithFullUrl = {
        "id": 102,
        "reportDate": "2026-09-23",
        "weight": 2.0,
        "photo": "https://cdn.example.com/storage/deposits/pic.jpg",
        "bank": {"id": 1, "name": "Bank 1"},
        "wasteType": {"name": "Anorganik"}
      };
      final model = BankSampahReportModel.fromJson(jsonWithFullUrl);
      expect(model.fotoUrl, 'https://cdn.example.com/storage/deposits/pic.jpg');

      final entity = model.toDomain();
      expect(entity.displayPhotoUrl, 'https://cdn.example.com/storage/deposits/pic.jpg');
    });

    test('parses live map JSON response into BankSampahLocationModel correctly', () {
      final json = {
        "id": 7690,
        "name": "BS JALAK GREEN COLLECTION",
        "latitude": -6.2297588,
        "longitude": 106.8831983,
        "villageId": 25779,
        "villageName": "Cipinang Besar Selatan",
        "districtName": "Jatinegara",
        "regencyName": "Kota Administrasi Jakarta Timur",
        "provinceName": "Daerah Khusus Ibukota Jakarta",
        "openTime": "08:00:00",
        "closeTime": "16:00:00",
        "isActive": true
      };

      final location = BankSampahLocationModel.fromJson(json);
      expect(location.id, '7690');
      expect(location.nama, 'BS JALAK GREEN COLLECTION');
      expect(location.kelurahan, 'Cipinang Besar Selatan');
      expect(location.alamat, 'Cipinang Besar Selatan, Jatinegara, Kota Administrasi Jakarta Timur');
      expect(location.latitude, -6.2297588);
      expect(location.longitude, 106.8831983);
    });

    test('Repository addReport routes to remoteDataSource.addDeposit when bankId is numeric', () async {
      final report = BankSampahReportModel(
        id: '',
        bankSampahId: '7690',
        bankSampahNama: 'BS JALAK GREEN COLLECTION',
        jenisSampah: 'Organik',
        beratKg: 3.5,
        nilaiRupiah: 17500,
        createdAt: DateTime(2026, 9, 23),
      ).toDomain();

      final result = await repository.addReport(report);
      expect(result.isRight, true);
      result.fold((l) => fail('should succeed'), (data) {
        expect(data.bankSampahId, '7690');
        expect(data.beratKg, 3.5);
      });
    });

    test('Repository getLocations routes to remoteDataSource.getBankSampahMap', () async {
      final result = await repository.getLocations();
      expect(result.isRight, true);
      result.fold((l) => fail('should succeed'), (data) {
        expect(data.length, 1);
        expect(data.first.id, '7690');
        expect(data.first.nama, 'BS JALAK GREEN COLLECTION');
      });
    });

    test('Repository returns ServerFailure when remote server throws', () async {
      remoteDataSource.shouldThrow = true;
      final result = await repository.getReports();
      expect(result.isLeft, true);
    });

    test('Repository deleteReport returns unsupported failure', () async {
      final result = await repository.deleteReport('123');
      expect(result.isLeft, true);
    });
  });

  group('BankSampahBloc Tests', () {
    test('Initial load fetches server locations and reports', () async {
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

    test('Nearest location is identified from server locations', () async {
      bloc.add(FetchBankSampahDataEvent());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<BankSampahState>((state) {
            final nearest = state.nearestLocation;
            return nearest != null && nearest.id == '7690';
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
        bankSampahId: '7690',
        bankSampahNama: 'BS JALAK GREEN COLLECTION',
        jenisSampah: 'Organik',
        beratKg: berat,
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
  });
}
