import 'package:akar/core/errors/failures.dart';
import '../entities/member_dashboard_entity.dart';
import '../repositories/member_dashboard_repository.dart';

class GetMemberDashboardUsecase {
  final MemberDashboardRepository repository;

  GetMemberDashboardUsecase(this.repository);

  Future<Either<Failure, MemberDashboardEntity>> call() async {
    return await repository.getMemberDashboard();
  }
}
