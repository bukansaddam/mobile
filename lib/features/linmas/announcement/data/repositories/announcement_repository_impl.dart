import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/linmas/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:akar/features/linmas/announcement/domain/entities/announcement_mapper.dart';
import 'package:akar/features/linmas/announcement/domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDatasource remoteDatasource;

  AnnouncementRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, AnnouncementPaginatedEntity>> getAnnouncements({
    String? category,
    bool? isPinned,
    int? page,
    int? perPage,
  }) async {
    try {
      final responseModel = await remoteDatasource.getAnnouncements(
        category: category,
        isPinned: isPinned,
        page: page,
        perPage: perPage,
      );
      return Right(responseModel.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
