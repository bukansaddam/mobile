import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import '../models/member_dashboard_model.dart';

abstract class MemberDashboardRemoteDataSource {
  Future<MemberDashboardModel> getMemberDashboard();
}

class MemberDashboardRemoteDataSourceImpl extends BaseRemoteDataSource
    implements MemberDashboardRemoteDataSource {
  @override
  Future<MemberDashboardModel> getMemberDashboard() async {
    final response = await handleRequest<MemberDashboardModel>(
      () => dio.get(ApiConstants.dashboardMember),
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return MemberDashboardModel.fromJson(json);
        } else if (json is Map) {
          return MemberDashboardModel.fromJson(Map<String, dynamic>.from(json));
        }
        throw Exception('Format data member dashboard tidak sesuai');
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Gagal memuat data dashboard member');
    }
  }
}
