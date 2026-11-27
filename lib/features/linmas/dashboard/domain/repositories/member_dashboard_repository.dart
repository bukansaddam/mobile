import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/dashboard/domain/entities/member_dashboard_entity.dart';

abstract class MemberDashboardRepository {
  Future<Either<Failure, MemberDashboardEntity>> getMemberDashboard();
}
