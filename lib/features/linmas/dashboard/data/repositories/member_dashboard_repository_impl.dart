import 'package:akar/core/errors/failures.dart';
import '../../domain/entities/member_dashboard_entity.dart';
import '../../domain/repositories/member_dashboard_repository.dart';
import '../datasources/member_dashboard_remote_datasource.dart';

class MemberDashboardRepositoryImpl implements MemberDashboardRepository {
  final MemberDashboardRemoteDataSource remoteDataSource;

  MemberDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MemberDashboardEntity>> getMemberDashboard() async {
    try {
      final result = await remoteDataSource.getMemberDashboard();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
