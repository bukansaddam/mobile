import 'package:akar/core/errors/failures.dart';
import '../entities/member_dashboard_entity.dart';

abstract class MemberDashboardRepository {
  Future<Either<Failure, MemberDashboardEntity>> getMemberDashboard();
}
