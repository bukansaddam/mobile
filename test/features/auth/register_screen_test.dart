import 'dart:async';
import 'dart:io';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/auth/domain/entities/ktp_ocr_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';
import 'package:akar/features/auth/domain/usecases/scan_ktp_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/pages/register_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class _FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  _FakeAuthBloc() : super(const AuthInitial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepository extends Fake implements AuthRepository {
  _FakeAuthRepository(this.onScan);

  final Future<Either<Failure, KtpOcrEntity>> Function(File file) onScan;
  int scanCalls = 0;

  @override
  Future<Either<Failure, KtpOcrEntity>> scanKtp(File file) {
    scanCalls++;
    return onScan(file);
  }
}

Future<void> _pickPhotoViaSheet(WidgetTester tester) async {
  await tester.tap(find.text('Ambil Gambar'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Ambil dari Galeri'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _pumpRegisterScreen(
  WidgetTester tester, {
  required AuthBloc authBloc,
  required Future<File?> Function(ImageSource) photoPickerOverride,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: RegisterScreen(photoPickerOverride: photoPickerOverride),
      ),
    ),
  );
}

void main() {
  const validOcr = KtpOcrEntity(
    nik: '3201234567890001',
    name: 'SADDAM HUSSEIN',
    birthPlace: 'JAKARTA',
    birthDate: null,
    address: 'JL. MERDEKA NO. 12',
  );
  final validOcrWithDate = validOcr.copyWith(birthDate: DateTime(1995, 8, 15));

  late _FakeAuthBloc authBloc;

  setUp(() async {
    await sl.reset();
    authBloc = _FakeAuthBloc();
  });

  tearDown(() async {
    await authBloc.close();
    await sl.reset();
  });

  void registerScanUsecase(_FakeAuthRepository repo) {
    sl.registerLazySingleton<ScanKtpUsecase>(() => ScanKtpUsecase(repo));
  }

  testWidgets(
    'foto KTP valid memindai langsung lalu pindah Step 2 dan memunculkan dialog Isi Otomatis',
    (tester) async {
      final completer = Completer<Either<Failure, KtpOcrEntity>>();
      final repo = _FakeAuthRepository((_) => completer.future);
      registerScanUsecase(repo);

      await _pumpRegisterScreen(
        tester,
        authBloc: authBloc,
        photoPickerOverride: (_) async => File('ktp_valid.jpg'),
      );

      await _pickPhotoViaSheet(tester);
      expect(find.text('Memindai data e-KTP...'), findsOneWidget);
      expect(find.byTooltip('Hapus foto'), findsNothing);

      completer.complete(Right(validOcrWithDate));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Data Kependudukan'), findsOneWidget);
      expect(find.text('Scan KTP Berhasil'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Isi Otomatis'));
      await tester.pumpAndSettle();

      expect(find.text('3201234567890001'), findsOneWidget);
      expect(find.text('SADDAM HUSSEIN'), findsOneWidget);
      expect(find.text('JAKARTA'), findsOneWidget);
      expect(find.text('15/08/1995'), findsOneWidget);
      expect(find.text('JL. MERDEKA NO. 12'), findsOneWidget);
      expect(repo.scanCalls, 1);
    },
  );

  testWidgets(
    'Isi Manual menyisakan tombol Isi Otomatis di header dan memakai cache saat kembali ke Step 1',
    (tester) async {
      final repo = _FakeAuthRepository((_) async => Right(validOcrWithDate));
      registerScanUsecase(repo);

      await _pumpRegisterScreen(
        tester,
        authBloc: authBloc,
        photoPickerOverride: (_) async => File('ktp_valid.jpg'),
      );

      await _pickPhotoViaSheet(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Isi Manual'));
      await tester.pumpAndSettle();

      expect(find.text('3201234567890001'), findsNothing);
      expect(find.text('Isi Otomatis'), findsOneWidget);

      await tester.tap(find.text('Kembali'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();

      expect(find.text('Data Kependudukan'), findsOneWidget);
      expect(repo.scanCalls, 1);
    },
  );

  testWidgets(
    'foto bukan KTP menghapus foto, mengunci lanjut, dan menampilkan dialog error',
    (tester) async {
      final repo = _FakeAuthRepository(
        (_) async => const Left(ValidationFailure('Foto bukan e-KTP yang valid.')),
      );
      registerScanUsecase(repo);

      await _pumpRegisterScreen(
        tester,
        authBloc: authBloc,
        photoPickerOverride: (_) async => File('selfie.jpg'),
      );

      await _pickPhotoViaSheet(tester);
      await tester.pumpAndSettle();

      expect(find.text('Foto Bukan e-KTP'), findsOneWidget);
      expect(find.text('Foto bukan e-KTP yang valid.'), findsOneWidget);
      expect(find.text('Ambil Foto Ulang'), findsOneWidget);

      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      expect(find.text('Ambil Foto e-KTP'), findsOneWidget);
      expect(find.text('Ambil Gambar'), findsOneWidget);
      expect(find.text('Lanjut'), findsNothing);
    },
  );

  testWidgets(
    'ambil ulang dari KTP valid ke foto bukan KTP menghapus foto dan cache lama',
    (tester) async {
      var pickCount = 0;
      final repo = _FakeAuthRepository((file) async {
        if (file.path == 'ktp_a.jpg') return Right(validOcrWithDate);
        return const Left(ValidationFailure('Bukan KTP'));
      });
      registerScanUsecase(repo);

      await _pumpRegisterScreen(
        tester,
        authBloc: authBloc,
        photoPickerOverride: (_) async {
          pickCount++;
          return File(pickCount == 1 ? 'ktp_a.jpg' : 'bukan_ktp.jpg');
        },
      );

      await _pickPhotoViaSheet(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Isi Manual'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kembali'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ambil Ulang'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ambil dari Galeri'));
      await tester.pumpAndSettle();

      expect(find.text('Foto Bukan e-KTP'), findsOneWidget);
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      expect(find.text('Ambil Gambar'), findsOneWidget);
      expect(find.text('Lanjut'), findsNothing);
    },
  );

  testWidgets(
    'error jaringan mempertahankan foto dan menyediakan Coba Scan Ulang serta Lanjut Manual',
    (tester) async {
      final repo = _FakeAuthRepository(
        (_) async => const Left(NetworkFailure('Koneksi timeout.')),
      );
      registerScanUsecase(repo);

      await _pumpRegisterScreen(
        tester,
        authBloc: authBloc,
        photoPickerOverride: (_) async => File('ktp_offline.jpg'),
      );

      await _pickPhotoViaSheet(tester);
      await tester.pumpAndSettle();

      expect(find.text('Gagal Memindai e-KTP'), findsOneWidget);
      expect(find.text('Coba Scan Ulang'), findsOneWidget);
      expect(find.text('Lanjut Manual'), findsOneWidget);

      await tester.tap(find.text('Coba Scan Ulang'));
      await tester.pumpAndSettle();
      expect(repo.scanCalls, 2);
      expect(find.text('Gagal Memindai e-KTP'), findsOneWidget);

      await tester.tap(find.text('Lanjut Manual'));
      await tester.pumpAndSettle();
      expect(find.text('Data Kependudukan'), findsOneWidget);

      await tester.tap(find.text('Kembali'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(find.text('Data Kependudukan'), findsOneWidget);
      expect(repo.scanCalls, 2);
    },
  );

  testWidgets('dispose saat OCR berjalan tidak menimbulkan exception', (
    tester,
  ) async {
    final completer = Completer<Either<Failure, KtpOcrEntity>>();
    final repo = _FakeAuthRepository((_) => completer.future);
    registerScanUsecase(repo);

    await _pumpRegisterScreen(
      tester,
      authBloc: authBloc,
      photoPickerOverride: (_) async => File('ktp_pending.jpg'),
    );

    await _pickPhotoViaSheet(tester);
    await tester.pumpWidget(const SizedBox.shrink());

    completer.complete(Right(validOcrWithDate));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
