import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:dio/dio.dart';

/// Kontrak repository domain untuk fitur Asisten AI Siska.
abstract class AiChatRepository {
  Future<Either<Failure, AiChatStatusEntity>> getStatus();

  Future<Either<Failure, AiChatSendResultEntity>> sendMessage({
    int? sessionId,
    required String message,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, List<AiChatSessionEntity>>> getSessions({
    String? search,
  });

  Future<Either<Failure, AiChatSessionEntity>> createSession({String? title});

  Future<Either<Failure, AiChatSessionDetailEntity>> getSessionDetail({
    required int sessionId,
    int limit = 20,
    int? beforeId,
  });

  Future<Either<Failure, AiChatSessionEntity>> renameSession({
    required int sessionId,
    required String title,
  });

  Future<Either<Failure, void>> deleteSession(int sessionId);
}
