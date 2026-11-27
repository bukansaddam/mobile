import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/ai_chat/data/datasources/ai_chat_remote_datasource.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_cancellation_token.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:akar/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:dio/dio.dart';

/// Implementasi [AiChatRepository] yang memetakan seluruh exception ke [Failure].
class AiChatRepositoryImpl implements AiChatRepository {
  AiChatRepositoryImpl(this._datasource);

  final AiChatRemoteDatasource _datasource;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Right(await run());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw AiChatCancelledException(e.message);
      }
      return Left(ErrorUtils.toFailure(e));
    } on AiChatCancelledException {
      rethrow;
    } catch (e) {
      return Left(ErrorUtils.toFailure(e));
    }
  }

  @override
  Future<Either<Failure, AiChatStatusEntity>> getStatus() =>
      _guard(() async => (await _datasource.getStatus()).toDomain());

  @override
  Future<Either<Failure, AiChatSendResultEntity>> sendMessage({
    int? sessionId,
    required String message,
    AiChatCancellationToken? cancelToken,
  }) {
    CancelToken? dioCancelToken;
    if (cancelToken != null) {
      dioCancelToken = CancelToken();
      cancelToken.onCancel((reason) {
        if (!dioCancelToken!.isCancelled) {
          dioCancelToken.cancel(reason);
        }
      });
    }
    return _guard(
      () async => (await _datasource.sendMessage(
        sessionId: sessionId,
        message: message,
        cancelToken: dioCancelToken,
      )).toDomain(),
    );
  }

  @override
  Future<Either<Failure, List<AiChatSessionEntity>>> getSessions({
    String? search,
  }) => _guard(() async {
    final models = await _datasource.getSessions(search: search);
    return models.map((m) => m.toDomain()).toList();
  });

  @override
  Future<Either<Failure, AiChatSessionEntity>> createSession({String? title}) =>
      _guard(
        () async => (await _datasource.createSession(title: title)).toDomain(),
      );

  @override
  Future<Either<Failure, AiChatSessionDetailEntity>> getSessionDetail({
    required int sessionId,
    int limit = 20,
    int? beforeId,
  }) => _guard(
    () async => (await _datasource.getSessionDetail(
      sessionId: sessionId,
      limit: limit,
      beforeId: beforeId,
    )).toDomain(),
  );

  @override
  Future<Either<Failure, AiChatSessionEntity>> renameSession({
    required int sessionId,
    required String title,
  }) => _guard(
    () async => (await _datasource.renameSession(
      sessionId: sessionId,
      title: title,
    )).toDomain(),
  );

  @override
  Future<Either<Failure, void>> deleteSession(int sessionId) =>
      _guard(() => _datasource.deleteSession(sessionId));
}
