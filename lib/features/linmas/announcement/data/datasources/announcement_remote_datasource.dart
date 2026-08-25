import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/features/linmas/announcement/data/models/announcement_model.dart';

abstract class AnnouncementRemoteDatasource {
  Future<AnnouncementResponseModel> getAnnouncements({
    String? category,
    bool? isPinned,
    int? page,
    int? perPage,
  });
}

class AnnouncementRemoteDatasourceImpl extends BaseRemoteDataSource
    implements AnnouncementRemoteDatasource {
  @override
  Future<AnnouncementResponseModel> getAnnouncements({
    String? category,
    bool? isPinned,
    int? page,
    int? perPage,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (isPinned != null) {
      queryParams['is_pinned'] = isPinned ? 1 : 0;
    }
    if (page != null) {
      queryParams['page'] = page;
    }
    if (perPage != null) {
      queryParams['per_page'] = perPage;
    }

    final response = await handleRequest<AnnouncementResponseModel>(
      () => dio.get(
        ApiConstants.news,
        queryParameters: queryParams,
      ),
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return AnnouncementResponseModel.fromJson(json);
        }
        if (json is List) {
          return AnnouncementResponseModel(
            success: true,
            data: json
                .map((e) => AnnouncementModel.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList(),
          );
        }
        return const AnnouncementResponseModel();
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Gagal mengambil data pengumuman');
    }
  }
}
