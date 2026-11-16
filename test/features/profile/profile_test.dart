import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/profile/domain/entities/update_profile_params.dart';
import 'package:akar/features/profile/domain/repositories/profile_repository.dart';
import 'package:akar/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:akar/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:akar/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:akar/features/profile/presentation/pages/linmas_profile_screen.dart';
import 'package:akar/features/profile/presentation/pages/masyarakat_profile_screen.dart';

class _FakeAuthBloc extends Fake implements AuthBloc {
  _FakeAuthBloc(this._state);

  final AuthState _state;

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => const Stream.empty();

  @override
  void add(AuthEvent event) {}
}

class _FakeProfileBloc extends Fake implements ProfileBloc {
  @override
  ProfileState get state => ProfileInitial();

  @override
  Stream<ProfileState> get stream => const Stream.empty();

  @override
  void add(ProfileEvent event) {}
}

class _FakeMyComplaintListBloc extends Fake implements MyComplaintListBloc {
  _FakeMyComplaintListBloc(this._state);

  final MyComplaintListState _state;

  @override
  MyComplaintListState get state => _state;

  @override
  Stream<MyComplaintListState> get stream => const Stream.empty();

  @override
  void add(MyComplaintListEvent event) {}
}

class MockProfileRepository implements ProfileRepository {
  Either<Failure, UserEntity>? getProfileResult;
  Either<Failure, UserEntity>? updateProfileResult;

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    return getProfileResult ?? const Left(ServerFailure('Mock failure'));
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    return updateProfileResult ?? const Left(ServerFailure('Mock failure'));
  }
}

void main() {
  const testUser = UserEntity(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    username: 'johndoe',
    phoneNumber: '081234567890',
    nik: '3201234567890001',
    birthDate: '1995-01-01',
    address: 'Jl. Merdeka No. 10',
    profilePic: 'https://example.com/photo.webp',
  );

  group('GetProfileUsecase Tests', () {
    late MockProfileRepository repository;
    late GetProfileUsecase usecase;

    setUp(() {
      repository = MockProfileRepository();
      usecase = GetProfileUsecase(repository);
    });

    test('should return UserEntity on successful profile fetch', () async {
      repository.getProfileResult = const Right(testUser);

      final result = await usecase();

      expect(result.isRight, true);
      expect(result.right, testUser);
    });

    test('should return ServerFailure when getProfile fails', () async {
      repository.getProfileResult = const Left(
        ServerFailure('Gagal memuat profil'),
      );

      final result = await usecase();

      expect(result.isLeft, true);
      expect(result.left.message, 'Gagal memuat profil');
    });
  });

  group('UpdateProfileUsecase Tests', () {
    late MockProfileRepository repository;
    late UpdateProfileUsecase usecase;

    setUp(() {
      repository = MockProfileRepository();
      usecase = UpdateProfileUsecase(repository);
    });

    test('should return UserEntity on successful profile update', () async {
      repository.updateProfileResult = const Right(testUser);

      const params = UpdateProfileParams(
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        phone: '081234567890',
        nik: '3201234567890001',
        birthDate: '1995-01-01',
        address: 'Jl. Merdeka No. 10',
      );

      final result = await usecase(params);

      expect(result.isRight, true);
      expect(result.right, testUser);
    });

    test('should return ServerFailure when updateProfile fails', () async {
      repository.updateProfileResult = const Left(
        ServerFailure('Gagal memperbarui profil'),
      );

      const params = UpdateProfileParams(name: 'John Doe', username: 'johndoe');

      final result = await usecase(params);

      expect(result.isLeft, true);
      expect(result.left.message, 'Gagal memperbarui profil');
    });
  });

  group('UserEntity displayProfilePic resolution tests', () {
    test('returns null when profilePic is null or empty', () {
      const userWithoutPic = UserEntity(id: 1, profilePic: null);
      expect(userWithoutPic.displayProfilePic, isNull);

      const userWithEmptyPic = UserEntity(id: 1, profilePic: '   ');
      expect(userWithEmptyPic.displayProfilePic, isNull);
    });

    test('preserves full http/https URLs as-is', () {
      const user = UserEntity(
        id: 1,
        profilePic: 'https://cdn.example.com/avatars/1.png',
      );
      expect(user.displayProfilePic, 'https://cdn.example.com/avatars/1.png');
    });

    test('prepends baseUrl and storage for relative paths', () {
      const user1 = UserEntity(
        id: 1,
        profilePic: 'profile_pictures/avatar.jpg',
      );
      expect(
        user1.displayProfilePic,
        contains('/storage/profile_pictures/avatar.jpg'),
      );

      const user2 = UserEntity(
        id: 1,
        profilePic: '/storage/profile_pictures/avatar.jpg',
      );
      expect(
        user2.displayProfilePic,
        contains('/storage/profile_pictures/avatar.jpg'),
      );
      expect(user2.displayProfilePic, isNot(contains('/storage/storage/')));

      const user3 = UserEntity(
        id: 1,
        profilePic: 'storage/profile_pictures/avatar.jpg',
      );
      expect(
        user3.displayProfilePic,
        contains('/storage/profile_pictures/avatar.jpg'),
      );
      expect(user3.displayProfilePic, isNot(contains('/storage/storage/')));
    });
  });

  group('Profile Screen NIK Display Tests', () {
    testWidgets(
      'MasyarakatProfileScreen menampilkan centang hijau untuk NIK, telepon, dan email tanpa menampilkan teks sensitifnya',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(600, 900));
        final user = testUser.copyWith(role: 'member', profilePic: '');

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(
                value: _FakeAuthBloc(
                  AuthAuthenticated(user: user, token: 'tok'),
                ),
              ),
              BlocProvider<ProfileBloc>.value(value: _FakeProfileBloc()),
            ],
            child: const MaterialApp(home: MasyarakatProfileScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('NIK'), findsOneWidget);
        expect(find.text('No. Telepon'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('3201234567890001'), findsNothing);
        expect(find.text('081234567890'), findsNothing);
        expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(3));
        expect(
          find.text('Pengaturan Notifikasi & Alarm Bencana'),
          findsNothing,
        );
        expect(find.text('Ubah Kata Sandi'), findsNothing);

        final partialUser = testUser.copyWith(
          role: 'member',
          profilePic: '',
          email: '',
        );
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(
                value: _FakeAuthBloc(
                  AuthAuthenticated(user: partialUser, token: 'tok'),
                ),
              ),
              BlocProvider<ProfileBloc>.value(value: _FakeProfileBloc()),
            ],
            child: const MaterialApp(home: MasyarakatProfileScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(2));
        expect(find.text('-'), findsOneWidget);
        expect(find.text('0'), findsNWidgets(3));

        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets(
      'MasyarakatProfileScreen menghitung statistik Laporan, Proses, dan Selesai secara dinamis dari MyComplaintListBloc',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(600, 900));
        final user = testUser.copyWith(role: 'member', profilePic: '');
        const complaintState = MyComplaintListState(
          status: MyComplaintListStatus.loaded,
          total: 5,
          items: [
            ComplaintReportEntity(id: '1', status: 'new'),
            ComplaintReportEntity(id: '2', status: 'verification'),
            ComplaintReportEntity(id: '3', status: 'in_progress'),
            ComplaintReportEntity(id: '4', status: 'completed'),
            ComplaintReportEntity(id: '5', status: 'rejected'),
          ],
        );

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(
                value: _FakeAuthBloc(
                  AuthAuthenticated(user: user, token: 'tok'),
                ),
              ),
              BlocProvider<ProfileBloc>.value(value: _FakeProfileBloc()),
              BlocProvider<MyComplaintListBloc>.value(
                value: _FakeMyComplaintListBloc(complaintState),
              ),
            ],
            child: const MaterialApp(home: MasyarakatProfileScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets('LinmasProfileScreen menampilkan NIK lengkap tanpa masking', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(600, 900));
      final user = testUser.copyWith(role: 'officer', profilePic: '');

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(
              value: _FakeAuthBloc(AuthAuthenticated(user: user, token: 'tok')),
            ),
            BlocProvider<ProfileBloc>.value(value: _FakeProfileBloc()),
          ],
          child: const MaterialApp(home: LinmasProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('3201234567890001'), findsOneWidget);
      expect(find.textContaining('****'), findsNothing);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
