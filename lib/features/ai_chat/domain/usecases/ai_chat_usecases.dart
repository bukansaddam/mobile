import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:akar/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:dio/dio.dart';

class GetAiChatStatusUsecase {
  GetAiChatStatusUsecase(this._repository);

  final AiChatRepository _repository;

  Future<Either<Failure, AiChatStatusEntity>> call() => _repository.getStatus();
}

class SendAiChatMessageUsecase {
  SendAiChatMessageUsecase(this._repository);

  final AiChatRepository _repository;

  Future<Either<Failure, AiChatSendResultEntity>> call({
    int? sessionId,
    required String message,
    CancelToken? cancelToken,
  }) => _repository.sendMessage(
    sessionId: sessionId,
    message: message,
    cancelToken: cancelToken,
  );
}

class GetAiChatSessionsUsecase {
  GetAiChatSessionsUsecase(this._repository);

  final AiChatRepository _repository;

  Future<Either<Failure, List<AiChatSessionEntity>>> call({String? search}) =>
      _repository.getSessions(search: search);
}

class CreateAiChatSessionUsecase {
  CreateAiChatSessionUsecase(this._repository);

  final AiChatRepository _repository;

  Future<Either<Failure, AiChatSessionEntity>> call({String? title}) =>
      _repository.createSession(title: title);
}

class GetAiChatSessionDetailUsecase {
  GetAiChatSessionDetailUsecase(this._repository);

  final AiChatRepository _repository;

  Future<Either<Failure, AiChatSessionDetailEntity>> call({
    required int sessionId,
    int limit = 20,
    int? beforeId,
  }) => _repository.getSessionDetail(
    sessionId: sessionId,
    limit: limit,
    beforeId: beforeId,
  );
}

class RenameAiChatSessionUsecase {
  RenameAiChatSessionUsecase(this._repository);

  final AiChatRepository _repository;

  Future<Either<Failure, AiChatSessionEntity>> call({
    required int sessionId,
    required String title,
  }) => _repository.renameSession(sessionId: sessionId, title: title);
}

class DeleteAiChatSessionUsecase {
  DeleteAiChatSessionUsecase(this._repository);

  final AiChatRepository _repository;

  Future<Either<Failure, void>> call(int sessionId) =>
      _repository.deleteSession(sessionId);
}
