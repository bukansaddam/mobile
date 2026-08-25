import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/announcement/domain/entities/announcement_entity.dart';

abstract class AnnouncementRepository {
  Future<Either<Failure, AnnouncementPaginatedEntity>> getAnnouncements({
    String? category,
    bool? isPinned,
    int? page,
    int? perPage,
  });
}
