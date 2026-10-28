import 'dart:async';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/announcement/domain/entities/announcement_entity.dart';
import 'package:akar/features/linmas/announcement/domain/repositories/announcement_repository.dart';
import 'package:akar/features/linmas/announcement/domain/usecases/get_announcements_usecase.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements AnnouncementRepository {
  final requests = <_Request>[];

  @override
  Future<Either<Failure, AnnouncementPaginatedEntity>> getAnnouncements({
    String? category,
    bool? isPinned,
    int? page,
    int? perPage,
    String? audience,
  }) {
    final request = _Request(page ?? 1);
    requests.add(request);
    return request.completer.future;
  }
}

class _Request {
  _Request(this.page);

  final int page;
  final completer = Completer<Either<Failure, AnnouncementPaginatedEntity>>();

  void complete(
    List<AnnouncementEntity> items, {
    required int currentPage,
    int lastPage = 3,
  }) {
    completer.complete(
      Right(
        AnnouncementPaginatedEntity(
          success: true,
          currentPage: currentPage,
          lastPage: lastPage,
          data: items,
        ),
      ),
    );
  }
}

AnnouncementEntity _item(int id) =>
    AnnouncementEntity(id: id, title: 'Berita $id');

void main() {
  late _FakeRepository repository;
  late AnnouncementBloc bloc;

  setUp(() {
    repository = _FakeRepository();
    bloc = AnnouncementBloc(
      getAnnouncementsUsecase: GetAnnouncementsUsecase(repository),
      audience: 'member',
    );
  });

  tearDown(() => bloc.close());

  test('hasil load-more yang basi dibuang setelah refresh', () async {
    bloc.add(const FetchAnnouncements());
    await pumpEventQueue();
    repository.requests.single.complete([_item(1)], currentPage: 1);
    await pumpEventQueue();
    expect(bloc.state.announcements.map((e) => e.id), [1]);

    bloc.add(const LoadMoreAnnouncements());
    await pumpEventQueue();
    expect(repository.requests.last.page, 2);

    bloc.add(const FetchAnnouncements(isRefresh: true));
    await pumpEventQueue();
    final refreshRequest = repository.requests.last;
    expect(refreshRequest.page, 1);

    refreshRequest.complete([_item(10)], currentPage: 1);
    await pumpEventQueue();

    repository.requests[1].complete([_item(2)], currentPage: 2);
    await pumpEventQueue();

    expect(bloc.state.announcements.map((e) => e.id), [10]);
    expect(bloc.state.currentPage, 1);
    expect(bloc.state.isLoadingMore, isFalse);
  });

  test('dua event load-more beruntun hanya memuat satu halaman', () async {
    bloc.add(const FetchAnnouncements());
    await pumpEventQueue();
    repository.requests.single.complete([_item(1)], currentPage: 1);
    await pumpEventQueue();

    bloc.add(const LoadMoreAnnouncements());
    bloc.add(const LoadMoreAnnouncements());
    await pumpEventQueue();

    expect(repository.requests.where((r) => r.page == 2), hasLength(1));
  });
}
