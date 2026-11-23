import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/ai_chat/data/models/ai_chat_models.dart';
import 'package:dio/dio.dart';

/// Kontrak datasource remote untuk fitur Asisten AI Siska.
abstract class AiChatRemoteDatasource {
  Future<AiChatStatusModel> getStatus();

  Future<AiChatSendResultModel> sendMessage({
    int? sessionId,
    required String message,
    CancelToken? cancelToken,
  });

  Future<List<AiChatSessionModel>> getSessions({String? search});

  Future<AiChatSessionModel> createSession({String? title});

  Future<AiChatSessionDetailModel> getSessionDetail({
    required int sessionId,
    int limit = 20,
    int? beforeId,
  });

  Future<AiChatSessionModel> renameSession({
    required int sessionId,
    required String title,
  });

  Future<void> deleteSession(int sessionId);
}

/// Implementasi datasource remote Asisten AI menggunakan [Dio].
class AiChatRemoteDatasourceImpl extends BaseRemoteDataSource
    implements AiChatRemoteDatasource {
  AiChatRemoteDatasourceImpl({Dio? dio}) : _dioOverride = dio;

  final Dio? _dioOverride;

  @override
  Dio get dio => _dioOverride ?? super.dio;

  static const Duration _chatReceiveTimeout = Duration(seconds: 90);

  @override
  Future<AiChatStatusModel> getStatus() async {
    final raw = await _execute(() => dio.get(ApiConstants.aiChatStatus));
    return AiChatStatusModel.fromJson(raw);
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    int? sessionId,
    required String message,
    CancelToken? cancelToken,
  }) async {
    final payload = <String, dynamic>{
      'message': message,
      'session_id': ?sessionId,
    };

    final raw = await _execute(
      () => dio.post(
        ApiConstants.aiChatMessages,
        data: payload,
        cancelToken: cancelToken,
        options: Options(receiveTimeout: _chatReceiveTimeout),
      ),
    );
    return AiChatSendResultModel.fromJson(raw);
  }

  @override
  Future<List<AiChatSessionModel>> getSessions({String? search}) async {
    final trimmed = search?.trim();
    final query = (trimmed != null && trimmed.isNotEmpty)
        ? <String, dynamic>{'search': trimmed}
        : null;

    final raw = await _execute(
      () => dio.get(ApiConstants.aiChatSessions, queryParameters: query),
    );
    return AiChatSessionModel.parseModelList(raw);
  }

  @override
  Future<AiChatSessionModel> createSession({String? title}) async {
    final trimmed = title?.trim();
    final raw = await _execute(
      () => dio.post(
        ApiConstants.aiChatSessions,
        data: <String, dynamic>{
          if (trimmed != null && trimmed.isNotEmpty) 'title': trimmed,
        },
      ),
    );
    return AiChatSessionModel.fromJson(raw);
  }

  @override
  Future<AiChatSessionDetailModel> getSessionDetail({
    required int sessionId,
    int limit = 20,
    int? beforeId,
  }) async {
    final query = <String, dynamic>{'limit': limit, 'before_id': ?beforeId};

    final raw = await _execute(
      () => dio.get(
        ApiConstants.aiChatSessionDetail(sessionId),
        queryParameters: query,
      ),
    );
    return AiChatSessionDetailModel.fromJson(raw);
  }

  @override
  Future<AiChatSessionModel> renameSession({
    required int sessionId,
    required String title,
  }) async {
    final raw = await _execute(
      () => dio.patch(
        ApiConstants.aiChatSessionDetail(sessionId),
        data: <String, dynamic>{'title': title},
      ),
    );
    return AiChatSessionModel.fromJson(raw);
  }

  @override
  Future<void> deleteSession(int sessionId) async {
    await _execute(
      () => dio.delete(ApiConstants.aiChatSessionDetail(sessionId)),
    );
  }

  Future<dynamic> _execute(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      final statusCode = response.statusCode ?? 200;
      final raw = response.data;
      final dataMap = raw is Map<String, dynamic>
          ? raw
          : raw is Map
          ? Map<String, dynamic>.from(raw)
          : null;

      final is2xx = statusCode >= 200 && statusCode < 300;
      final explicitSuccess = dataMap?['success'] ?? dataMap?['is_success'];
      if (is2xx && explicitSuccess != false) {
        return raw;
      }

      final msg = dataMap != null
          ? ErrorUtils.parseErrorMessage(dataMap)
          : 'Terjadi Kesalahan';
      if (statusCode == 400 || statusCode == 422) {
        throw ValidationException(msg, statusCode: statusCode);
      }
      throw ServerException(msg, statusCode: statusCode);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) rethrow;
      throw ErrorUtils.toAppException(e);
    }
  }
}
