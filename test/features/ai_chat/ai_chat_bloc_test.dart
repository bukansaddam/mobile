import 'dart:async';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:akar/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:akar/features/ai_chat/domain/usecases/ai_chat_usecases.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAiChatRepository implements AiChatRepository {
  AiChatStatusEntity statusToReturn = const AiChatStatusEntity(enabled: true);
  Future<Either<Failure, AiChatSendResultEntity>> Function({
    int? sessionId,
    required String message,
    CancelToken? cancelToken,
  })?
  onSendMessage;

  Future<Either<Failure, AiChatSessionDetailEntity>> Function({
    required int sessionId,
    int limit,
    int? beforeId,
  })?
  onGetSessionDetail;

  List<AiChatSessionEntity> sessionsToReturn = const [];
  int sendCallCount = 0;

  @override
  Future<Either<Failure, AiChatStatusEntity>> getStatus() async =>
      Right(statusToReturn);

  @override
  Future<Either<Failure, AiChatSendResultEntity>> sendMessage({
    int? sessionId,
    required String message,
    CancelToken? cancelToken,
  }) async {
    sendCallCount++;
    if (onSendMessage != null) {
      return onSendMessage!(
        sessionId: sessionId,
        message: message,
        cancelToken: cancelToken,
      );
    }
    return Right(
      AiChatSendResultEntity(
        session: const AiChatSessionEntity(id: 1, title: 'Sesi 1'),
        userMessage: AiChatMessageEntity(
          id: 10,
          role: AiChatMessageRole.user,
          content: message,
        ),
        assistantMessage: const AiChatMessageEntity(
          id: 11,
          role: AiChatMessageRole.assistant,
          content: 'Balasan AI',
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<AiChatSessionEntity>>> getSessions({
    String? search,
  }) async => Right(sessionsToReturn);

  @override
  Future<Either<Failure, AiChatSessionEntity>> createSession({
    String? title,
  }) async => Right(AiChatSessionEntity(id: 99, title: title ?? 'Baru'));

  @override
  Future<Either<Failure, AiChatSessionDetailEntity>> getSessionDetail({
    required int sessionId,
    int limit = 20,
    int? beforeId,
  }) async {
    if (onGetSessionDetail != null) {
      return onGetSessionDetail!(
        sessionId: sessionId,
        limit: limit,
        beforeId: beforeId,
      );
    }
    return Right(
      AiChatSessionDetailEntity(
        session: AiChatSessionEntity(id: sessionId, title: 'Sesi #$sessionId'),
        messages: const [],
      ),
    );
  }

  @override
  Future<Either<Failure, AiChatSessionEntity>> renameSession({
    required int sessionId,
    required String title,
  }) async => Right(AiChatSessionEntity(id: sessionId, title: title));

  @override
  Future<Either<Failure, void>> deleteSession(int sessionId) async =>
      const Right(null);
}

AiChatBloc _buildBloc(
  _FakeAiChatRepository repo, {
  Future<bool> Function()? checkOffline,
  Stream<bool>? offlineStream,
}) {
  return AiChatBloc(
    getStatus: GetAiChatStatusUsecase(repo),
    sendMessage: SendAiChatMessageUsecase(repo),
    getSessions: GetAiChatSessionsUsecase(repo),
    createSession: CreateAiChatSessionUsecase(repo),
    getSessionDetail: GetAiChatSessionDetailUsecase(repo),
    renameSession: RenameAiChatSessionUsecase(repo),
    deleteSession: DeleteAiChatSessionUsecase(repo),
    checkOffline: checkOffline ?? () async => false,
    offlineStream: offlineStream,
  );
}

void main() {
  late _FakeAiChatRepository repo;
  late AiChatBloc bloc;

  setUp(() {
    repo = _FakeAiChatRepository();
    bloc = _buildBloc(repo);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('LoadAiChatInitialEvent handles disabled AI while allowing history selection', () async {
    repo.statusToReturn = const AiChatStatusEntity(
      enabled: false,
      disabledMessage: 'Sedang pemeliharaan.',
    );
    repo.onGetSessionDetail =
        ({required int sessionId, int limit = 20, int? beforeId}) async =>
            Right(
              AiChatSessionDetailEntity(
                session: AiChatSessionEntity(id: sessionId, title: 'Arsip'),
                messages: const [
                  AiChatMessageEntity(
                    id: 1,
                    role: AiChatMessageRole.user,
                    content: 'Lama',
                  ),
                ],
              ),
            );

    bloc.add(const LoadAiChatInitialEvent());
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(bloc.state.isEnabled, isFalse);
    expect(bloc.state.disabledMessage, 'Sedang pemeliharaan.');
    expect(bloc.state.canSend, isFalse);

    // Sending while disabled must not hit repository
    bloc.add(const SendAiChatMessageEvent('Tes'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(repo.sendCallCount, 0);

    // Reading old session still works
    bloc.add(const SelectAiChatSessionEvent(5));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state.activeSession?.id, 5);
    expect(bloc.state.messages.single.content, 'Lama');
  });

  test('SendAiChatMessageEvent appends optimistic message, ignores double submit, and stores reply', () async {
    final completer = Completer<Either<Failure, AiChatSendResultEntity>>();
    repo.onSendMessage = ({
      int? sessionId,
      required String message,
      CancelToken? cancelToken,
    }) => completer.future;

    bloc.add(const SendAiChatMessageEvent('Halo Siska'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(bloc.state.isSending, isTrue);
    expect(bloc.state.messages, hasLength(1));
    expect(
      bloc.state.messages.first.sendStatus,
      AiChatMessageSendStatus.sending,
    );

    // Double-submit while isSending == true must be ignored
    bloc.add(const SendAiChatMessageEvent('Double submit'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(repo.sendCallCount, 1);

    completer.complete(
      const Right(
        AiChatSendResultEntity(
          session: AiChatSessionEntity(id: 77, title: 'Halo Siska'),
          userMessage: AiChatMessageEntity(
            id: 100,
            role: AiChatMessageRole.user,
            content: 'Halo Siska',
          ),
          assistantMessage: AiChatMessageEntity(
            id: 101,
            role: AiChatMessageRole.assistant,
            content: 'Halo, ada yang bisa dibantu?',
          ),
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(bloc.state.isSending, isFalse);
    expect(bloc.state.activeSession?.id, 77);
    expect(bloc.state.messages, hasLength(2));
    expect(bloc.state.messages.last.content, 'Halo, ada yang bisa dibantu?');
  });

  test('starting new session mid-request cancels CancelToken and ignores stale reply', () async {
    CancelToken? capturedToken;
    final completer = Completer<Either<Failure, AiChatSendResultEntity>>();
    repo.onSendMessage =
        ({int? sessionId, required String message, CancelToken? cancelToken}) {
          capturedToken = cancelToken;
          return completer.future;
        };

    bloc.add(const SendAiChatMessageEvent('Pesan lama'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(capturedToken?.isCancelled, isFalse);

    bloc.add(const StartNewAiChatSessionEvent());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(capturedToken?.isCancelled, isTrue);
    expect(bloc.state.activeSession, isNull);
    expect(bloc.state.messages, isEmpty);

    // Even if a late response resolves without throwing, stale epoch drops it
    completer.complete(
      const Right(
        AiChatSendResultEntity(
          session: AiChatSessionEntity(id: 50, title: 'Bocor'),
          assistantMessage: AiChatMessageEntity(
            id: 2,
            role: AiChatMessageRole.assistant,
            content: 'Balasan bocor',
          ),
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(bloc.state.activeSession, isNull);
    expect(bloc.state.messages, isEmpty);
  });

  test('DeleteAiChatSessionEvent on active session clears activeSession, messages, and nextBeforeId', () async {
    repo.onGetSessionDetail =
        ({required int sessionId, int limit = 20, int? beforeId}) async =>
            Right(
              AiChatSessionDetailEntity(
                session: AiChatSessionEntity(id: sessionId, title: 'Aktif'),
                messages: const [
                  AiChatMessageEntity(
                    id: 9,
                    role: AiChatMessageRole.user,
                    content: 'Hai',
                  ),
                ],
                nextBeforeId: 8,
              ),
            );

    bloc.add(const SelectAiChatSessionEvent(15));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.activeSession?.id, 15);
    expect(bloc.state.nextBeforeId, 8);

    bloc.add(const DeleteAiChatSessionEvent(15));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(bloc.state.activeSession, isNull);
    expect(bloc.state.messages, isEmpty);
    expect(bloc.state.nextBeforeId, isNull);
  });

  test(
    'LoadMoreAiChatMessagesEvent prepends older messages using nextBeforeId',
    () async {
      repo.onGetSessionDetail =
          ({required int sessionId, int limit = 20, int? beforeId}) async {
            if (beforeId == null) {
              return Right(
                AiChatSessionDetailEntity(
                  session: AiChatSessionEntity(id: sessionId, title: 'Sesi'),
                  messages: const [
                    AiChatMessageEntity(
                      id: 20,
                      role: AiChatMessageRole.user,
                      content: 'Terbaru',
                    ),
                  ],
                  nextBeforeId: 20,
                ),
              );
            }
            return Right(
              AiChatSessionDetailEntity(
                session: AiChatSessionEntity(id: sessionId, title: 'Sesi'),
                messages: const [
                  AiChatMessageEntity(
                    id: 10,
                    role: AiChatMessageRole.assistant,
                    content: 'Lebih lama',
                  ),
                ],
                nextBeforeId: null,
              ),
            );
          };

      bloc.add(const SelectAiChatSessionEvent(1));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.messages.map((m) => m.id), [20]);

      bloc.add(const LoadMoreAiChatMessagesEvent());
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.messages.map((m) => m.id), [10, 20]);
      expect(bloc.state.nextBeforeId, isNull);
    },
  );

  test('offline connectivity sets isOffline=true and blocks sending', () async {
    var offlineFlag = true;
    final offlineController = StreamController<bool>();
    final offlineBloc = _buildBloc(
      repo,
      checkOffline: () async => offlineFlag,
      offlineStream: offlineController.stream,
    );

    offlineBloc.add(const LoadAiChatInitialEvent());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(offlineBloc.state.isOffline, isTrue);

    offlineBloc.add(const SendAiChatMessageEvent('Tes offline'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(repo.sendCallCount, 0);

    offlineFlag = false;
    offlineController.add(false);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(offlineBloc.state.isOffline, isFalse);

    await offlineBloc.close();
    await offlineController.close();
  });
}
