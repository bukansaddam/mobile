import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/dashboard/domain/entities/member_dashboard_entity.dart';
import 'package:akar/features/linmas/dashboard/domain/repositories/member_dashboard_repository.dart';

class GetMemberDashboardUsecase {
  final MemberDashboardRepository repository;

  GetMemberDashboardUsecase(this.repository);

  Future<Either<Failure, MemberDashboardEntity>> call() async {
    return await repository.getMemberDashboard();
  }
}
