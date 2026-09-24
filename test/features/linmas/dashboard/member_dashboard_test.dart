import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/features/linmas/dashboard/data/datasources/member_dashboard_remote_datasource.dart';
import 'package:akar/features/linmas/dashboard/data/models/member_dashboard_model.dart';
import 'package:akar/features/linmas/dashboard/data/repositories/member_dashboard_repository_impl.dart';
import 'package:akar/features/linmas/dashboard/domain/usecases/get_member_dashboard_usecase.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_bloc.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_event.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_state.dart';

class FakeMemberDashboardRemoteDataSource
    implements MemberDashboardRemoteDataSource {
  MemberDashboardModel? model;
  bool shouldThrow = false;

  @override
  Future<MemberDashboardModel> getMemberDashboard() async {
    if (shouldThrow) {
      throw Exception('Server error: 500');
    }
    return model ??
        MemberDashboardModel.fromJson(const {
          'user': {
            'id': 250420,
            'name': 'Agus Sunandar',
            'username': 'agusunandar',
            'email': 'agus@example.test',
            'phone': '081234567892',
            'membership_no': null,
            'nik': '3174010101010002',
            'photo_url': null,
            'role': 'officer',
            'status': 'online',
          },
          'waste': {
            'total_earnings': 15000,
            'total_weight_kg': 12.5,
            'total_deposits': 3,
          },
          'survey': {
            'is_available': true,
            'is_filled': false,
            'period': '2026-09',
            'month': '09',
            'year': 2026,
            'survey_id': 101,
            'survey_title': 'Survey Lingkungan RT',
            'description': 'Evaluasi lingkungan RT',
            'deadline_at': '2026-09-30',
            'estimated_minutes': 5,
            'total_questions': 10,
            'submitted_at': null,
            'submission_id': null,
          },
        });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sampleJson = {
    'success': true,
    'message': 'Member dashboard data retrieved successfully',
    'data': {
      'user': {
        'id': 250420,
        'name': 'Agus Sunandar',
        'username': 'agusunandar',
        'email': 'agus@example.test',
        'phone': '081234567892',
        'membership_no': null,
        'nik': '3174010101010002',
        'photo_url': 'avatars/agus.jpg',
        'role': 'officer',
        'status': 'online',
      },
      'waste': {
        'total_earnings': 25000,
        'total_weight_kg': 10.5,
        'total_deposits': 4,
      },
      'survey': {
        'is_available': false,
        'is_filled': false,
        'period': '2026-09',
        'month': '09',
        'year': 2026,
        'survey_id': null,
        'survey_title': null,
        'description': null,
        'deadline_at': null,
        'estimated_minutes': null,
        'total_questions': 0,
        'submitted_at': null,
        'submission_id': null,
      },
    },
  };

  group('MemberDashboardModel Serialization', () {
    test('parses JSON response correctly', () {
      final response = MemberDashboardResponseModel.fromJson(sampleJson);
      expect(response.success, true);
      expect(response.data, isNotNull);

      final model = response.data!;
      expect(model.user.id, 250420);
      expect(model.user.name, 'Agus Sunandar');
      expect(model.user.phone, '081234567892');
      expect(model.user.photoUrl, 'avatars/agus.jpg');
      expect(
        model.user.displayPhotoUrl,
        '${ApiConstants.baseUrl}/storage/avatars/agus.jpg',
      );

      expect(model.waste.totalEarnings, 25000.0);
      expect(model.waste.totalWeightKg, 10.5);
      expect(model.waste.totalDeposits, 4);

      expect(model.survey.isAvailable, false);
      expect(model.survey.isFilled, false);
      expect(model.survey.periodLabel, 'September 2026');
    });

    test('handles full URL in displayPhotoUrl without duplicate baseUrl', () {
      const userJson = {
        'id': 1,
        'name': 'Budi',
        'username': 'budi',
        'email': 'budi@test.com',
        'photo_url': 'https://example.com/budi.png',
        'role': 'officer',
        'status': 'online',
      };
      final user = MemberDashboardUserModel.fromJson(userJson);
      expect(user.displayPhotoUrl, 'https://example.com/budi.png');
    });
  });

  group('MemberDashboardRepository & UseCase', () {
    test('returns MemberDashboardEntity on success', () async {
      final fakeDs = FakeMemberDashboardRemoteDataSource();
      final repo = MemberDashboardRepositoryImpl(remoteDataSource: fakeDs);
      final usecase = GetMemberDashboardUsecase(repo);

      final result = await usecase();
      expect(result.isRight, true);
      expect(result.right.user.name, 'Agus Sunandar');
      expect(result.right.waste.totalWeightKg, 12.5);
    });

    test('returns Failure when datasource throws', () async {
      final fakeDs = FakeMemberDashboardRemoteDataSource()..shouldThrow = true;
      final repo = MemberDashboardRepositoryImpl(remoteDataSource: fakeDs);
      final usecase = GetMemberDashboardUsecase(repo);

      final result = await usecase();
      expect(result.isLeft, true);
      expect(result.left.message, contains('Server error'));
    });
  });

  group('MemberDashboardBloc', () {
    test('emits [Loading, Loaded] when FetchMemberDashboardEvent succeeds',
        () async {
      final fakeDs = FakeMemberDashboardRemoteDataSource();
      final repo = MemberDashboardRepositoryImpl(remoteDataSource: fakeDs);
      final usecase = GetMemberDashboardUsecase(repo);
      final bloc = MemberDashboardBloc(getMemberDashboardUsecase: usecase);

      final states = <MemberDashboardState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const FetchMemberDashboardEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<MemberDashboardLoading>());
      expect(states[1], isA<MemberDashboardLoaded>());
      final loaded = states[1] as MemberDashboardLoaded;
      expect(loaded.dashboard.user.name, 'Agus Sunandar');

      await sub.cancel();
      await bloc.close();
    });

    test('emits [Error] when FetchMemberDashboardEvent fails', () async {
      final fakeDs = FakeMemberDashboardRemoteDataSource()..shouldThrow = true;
      final repo = MemberDashboardRepositoryImpl(remoteDataSource: fakeDs);
      final usecase = GetMemberDashboardUsecase(repo);
      final bloc = MemberDashboardBloc(getMemberDashboardUsecase: usecase);

      final states = <MemberDashboardState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const FetchMemberDashboardEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<MemberDashboardLoading>());
      expect(states[1], isA<MemberDashboardError>());

      await sub.cancel();
      await bloc.close();
    });
  });
}
