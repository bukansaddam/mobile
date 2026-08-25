import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/announcement/domain/entities/announcement_entity.dart';
import 'package:akar/features/linmas/announcement/domain/repositories/announcement_repository.dart';

class GetAnnouncementsUsecase {
  final AnnouncementRepository repository;

  GetAnnouncementsUsecase(this.repository);

  Future<Either<Failure, AnnouncementPaginatedEntity>> call({
    String? category,
    bool? isPinned,
    int? page,
    int? perPage,
  }) {
    return repository.getAnnouncements(
      category: category,
      isPinned: isPinned,
      page: page,
      perPage: perPage,
    );
  }
}
