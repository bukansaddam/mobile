import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/presensi/domain/entities/presensi_entity.dart';
import 'package:akar/features/linmas/presensi/domain/repositories/presensi_repository.dart';
import 'package:akar/features/linmas/presensi/domain/usecases/submit_presensi_usecase.dart';
import 'package:akar/features/linmas/presensi/presentation/bloc/presensi_bloc/presensi_bloc.dart';
import 'package:akar/features/linmas/presensi/presentation/pages/presensi_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePresensiRepository implements PresensiRepository {
  int submitCalls = 0;

  @override
  Future<Either<Failure, PresensiDataEntity>> submitPresensi(
    PresensiDataEntity data,
  ) async {
    submitCalls++;
    return Right(
      PresensiDataEntity(
        id: 'PRS-$submitCalls',
        userName: data.userName,
        address: data.address,
        kecamatan: data.kecamatan,
        kelurahan: data.kelurahan,
        rt: data.rt,
        rw: data.rw,
        latitude: data.latitude,
        longitude: data.longitude,
        timestamp: DateTime(2026, 11, 24, 16, 30),
        isSuccess: true,
      ),
    );
  }
}

class _FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  _FakeAuthBloc() : super(const AuthInitial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Perbarui Posisi (single mode tanpa Masuk/Keluar)', () {
    test('PresensiBloc submit berulang tetap sukses tanpa toggle masuk/keluar', () async {
      final repo = _FakePresensiRepository();
      final bloc = PresensiBloc(
        submitPresensiUsecase: SubmitPresensiUsecase(repo),
      );
      addTearDown(bloc.close);

      bloc.add(SubmitPresensiEvent());
      final firstSuccess = await bloc.stream.firstWhere(
        (state) => state.status == PresensiStatus.success,
      );
      expect(firstSuccess.lastResult?.id, equals('PRS-1'));

      bloc.add(SubmitPresensiEvent());
      final secondSuccess = await bloc.stream.firstWhere(
        (state) =>
            state.status == PresensiStatus.success &&
            state.lastResult?.id == 'PRS-2',
      );
      expect(secondSuccess.lastResult?.id, equals('PRS-2'));
      expect(repo.submitCalls, equals(2));
    });

    testWidgets(
      'PresensiScreen hanya menampilkan satu aksi Perbarui Posisi tanpa label Masuk/Keluar dan dialog sukses tunggal',
      (tester) async {
        final repo = _FakePresensiRepository();
        final presensiBloc = PresensiBloc(
          submitPresensiUsecase: SubmitPresensiUsecase(repo),
          fetchCurrentPosition: ({required timeLimit}) async => null,
        );
        final authBloc = _FakeAuthBloc();
        addTearDown(() async {
          await presensiBloc.close();
          await authBloc.close();
        });

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: authBloc),
              BlocProvider<PresensiBloc>.value(value: presensiBloc),
            ],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const PresensiScreen(),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Perbarui Posisi Masuk'), findsNothing);
        expect(find.text('Perbarui Posisi Keluar'), findsNothing);
        expect(find.byIcon(Icons.login_rounded), findsNothing);
        expect(find.byIcon(Icons.logout_rounded), findsNothing);
        expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
        // AppBar title + panel header + submit button
        expect(find.text('Perbarui Posisi'), findsNWidgets(3));

        // Submit pertama -> dialog sukses tunggal tanpa baris Tipe / Isi Laporan Harian
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        expect(find.text('Posisi Berhasil Diperbarui!'), findsOneWidget);
        expect(find.text('Tipe'), findsNothing);
        expect(find.text('ISI LAPORAN HARIAN'), findsNothing);
        expect(find.text('KEMBALI KE HALAMAN UTAMA'), findsOneWidget);

        // Tutup dialog, pastikan label tetap Perbarui Posisi (tidak berubah jadi Keluar)
        await tester.tap(find.text('KEMBALI KE HALAMAN UTAMA'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        expect(find.text('Perbarui Posisi Masuk'), findsNothing);
        expect(find.text('Perbarui Posisi Keluar'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
