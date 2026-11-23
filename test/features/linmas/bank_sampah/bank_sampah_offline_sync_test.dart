import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/linmas/bank_sampah/data/datasources/bank_sampah_remote_datasource.dart';
import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_location_model.dart';
import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_report_model.dart';
import 'package:akar/features/linmas/bank_sampah/data/sync/bank_sampah_sync_handler.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';
import 'package:akar/features/linmas/bank_sampah/domain/repositories/bank_sampah_repository.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_location_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/add_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/delete_bank_sampah_report_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_locations_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/domain/usecases/get_bank_sampah_reports_usecase.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockBankSampahRemoteDataSource extends Fake
    implements BankSampahRemoteDataSource {
  int? lastBankId;
  String? lastWasteType;
  double? lastWeightKg;
  String? lastReportDate;
  String? lastNotes;
  File? lastPhoto;
  String? lastIdempotencyKey;
  bool? lastSkipMediaPreparation;

  @override
  Future<BankSampahReportModel> addDeposit({
    required int bankId,
    required String wasteType,
    required double weightKg,
    required String reportDate,
    String? notes,
    File? photo,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    lastBankId = bankId;
    lastWasteType = wasteType;
    lastWeightKg = weightKg;
    lastReportDate = reportDate;
    lastNotes = notes;
    lastPhoto = photo;
    lastIdempotencyKey = idempotencyKey;
    lastSkipMediaPreparation = skipMediaPreparation;

    return BankSampahReportModel(
      id: '901',
      bankSampahId: bankId.toString(),
      bankSampahNama: 'Bank Sampah $bankId',
      jenisSampah: wasteType,
      beratKg: weightKg,
      nilaiRupiah: weightKg * 4000,
      catatan: notes ?? '',
      createdAt: DateTime.parse(reportDate),
    );
  }

  @override
  Future<List<BankSampahLocationModel>> getBankSampahMap() async => const [];

  @override
  Future<BankSampahMyDepositsResponseModel> getMyDeposits({
    int? page,
    int? perPage,
    String? sortBy,
    String? sortDirection,
    int? bankId,
    String? wasteType,
  }) async {
    return const BankSampahMyDepositsResponseModel(
      success: true,
      data: [],
      summary: BankSampahSummaryModel(),
    );
  }
}

class _MockBankSampahRepository extends Fake implements BankSampahRepository {
  Either<Failure, BankSampahReportEntity>? cannedAddResult;

  @override
  Future<Either<Failure, BankSampahReportsDataEntity>> getReports({
    int? page,
    int? perPage,
    String? sortBy,
    String? sortDirection,
    int? bankId,
    String? wasteType,
  }) async {
    return const Right(
      BankSampahReportsDataEntity(
        success: true,
        data: [],
        summary: BankSampahSummaryEntity(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<BankSampahLocationEntity>>> getLocations() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, BankSampahReportEntity>> addReport(
    BankSampahReportEntity report, {
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    return cannedAddResult ?? Right(report);
  }
}

class _MockAuthLocalDatasource extends Fake implements AuthLocalDatasource {
  @override
  String? getCachedUserId() => 'linmas-user-77';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late OfflineQueueLocalDatasource queueDatasource;
  late _MockAuthLocalDatasource mockAuthDatasource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'bank_sampah_offline_test_',
    );
    queueDatasource = OfflineQueueLocalDatasource(
      rootDirectory: () async => tempDir,
    );
    mockAuthDatasource = _MockAuthLocalDatasource();
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('BankSampahSyncHandler', () {
    test('handles OfflineFeatureType.bankSampah and calls datasource with idempotencyKey & skipMediaPreparation true', () async {
      final mockDatasource = _MockBankSampahRemoteDataSource();
      final handler = BankSampahSyncHandler(remoteDataSource: mockDatasource);

      expect(handler.canHandle(OfflineFeatureType.bankSampah), isTrue);
      expect(handler.canHandle(OfflineFeatureType.ronda), isFalse);

      final dummyPhoto = File('${tempDir.path}/sampah.jpg')
        ..writeAsStringSync('binary_photo_data');

      final queueItem = OfflineQueueItem(
        id: 'queue-bs-1',
        userId: 'linmas-user-77',
        featureType: OfflineFeatureType.bankSampah,
        clientRequestId: 'idemp-uuid-bs-456',
        payload: {
          'bank_id': 7690,
          'waste_type': 'Plastik',
          'weight_kg': 12.5,
          'report_date': '2026-11-23',
          'notes': 'Botol PET bersih',
        },
        attachments: [
          OfflineAttachment(
            localPath: dummyPhoto.path,
            originalName: 'sampah.jpg',
            fieldKey: 'photo',
            mimeType: 'image/jpeg',
            sizeBytes: dummyPhoto.lengthSync(),
            isVideo: false,
          ),
        ],
        status: OfflineItemStatus.pending,
        retryCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await handler.sync(queueItem);

      expect(mockDatasource.lastBankId, equals(7690));
      expect(mockDatasource.lastWasteType, equals('Plastik'));
      expect(mockDatasource.lastWeightKg, equals(12.5));
      expect(mockDatasource.lastReportDate, equals('2026-11-23'));
      expect(mockDatasource.lastNotes, equals('Botol PET bersih'));
      expect(mockDatasource.lastPhoto?.path, equals(dummyPhoto.path));
      expect(mockDatasource.lastIdempotencyKey, equals('idemp-uuid-bs-456'));
      expect(mockDatasource.lastSkipMediaPreparation, isTrue);
    });
  });

  group('BankSampahBloc offline queueing', () {
    test('enqueues deposit into OfflineQueueLocalDatasource when failure is retryable', () async {
      final mockRepo = _MockBankSampahRepository();
      mockRepo.cannedAddResult = const Left(
        NetworkFailure('Tidak ada koneksi internet'),
      );

      final dummyPhoto = File('${tempDir.path}/deposit_photo.jpg')
        ..writeAsStringSync('photo bytes');

      final bloc = BankSampahBloc(
        getReportsUsecase: GetBankSampahReportsUsecase(mockRepo),
        addReportUsecase: AddBankSampahReportUsecase(mockRepo),
        deleteReportUsecase: DeleteBankSampahReportUsecase(mockRepo),
        getLocationsUsecase: GetBankSampahLocationsUsecase(mockRepo),
        addLocationUsecase: AddBankSampahLocationUsecase(mockRepo),
        offlineQueue: queueDatasource,
        authLocalDatasource: mockAuthDatasource,
      );

      await pumpEventQueue();

      final report = BankSampahReportEntity(
        id: 'temp-1',
        bankSampahId: '7690',
        bankSampahNama: 'BS JALAK GREEN',
        jenisSampah: 'Kertas',
        beratKg: 8.0,
        nilaiRupiah: 0,
        catatan: 'Kardus bekas',
        fotoPath: dummyPhoto.path,
        createdAt: DateTime(2026, 11, 23),
      );

      final successFuture = bloc.stream
          .firstWhere((state) => state is BankSampahActionSuccess)
          .timeout(const Duration(seconds: 5));

      bloc.add(CreateBankSampahReportEvent(report));

      final successState = await successFuture as BankSampahActionSuccess;
      expect(successState.message.toLowerCase(), contains('antrean offline'));

      final pending = await queueDatasource.getPending('linmas-user-77');
      expect(pending.length, equals(1));
      expect(pending.first.featureType, equals(OfflineFeatureType.bankSampah));
      expect(pending.first.payload['bank_id'], equals(7690));
      expect(pending.first.payload['waste_type'], equals('Kertas'));
      expect(pending.first.payload['weight_kg'], equals(8.0));
      expect(pending.first.payload['report_date'], equals('2026-11-23'));
      expect(pending.first.payload['notes'], equals('Kardus bekas'));
      expect(pending.first.attachments.length, equals(1));

      await bloc.close();
    });
  });
}
