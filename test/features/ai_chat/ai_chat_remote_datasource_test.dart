import 'dart:convert';
import 'dart:typed_data';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/ai_chat/data/datasources/ai_chat_remote_datasource.dart';
import 'package:akar/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHttpClientAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;
  Future<ResponseBody> Function(RequestOptions options)? onFetch;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    if (onFetch != null) {
      return onFetch!(options);
    }
    return ResponseBody.fromString(
      jsonEncode({'success': true, 'data': {}}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

ResponseBody _jsonResponse(Map<String, dynamic> body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  late Dio dio;
  late _FakeHttpClientAdapter adapter;
  late AiChatRemoteDatasourceImpl datasource;
  late AiChatRepositoryImpl repository;

  setUp(() {
    adapter = _FakeHttpClientAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.httpClientAdapter = adapter;
    datasource = AiChatRemoteDatasourceImpl(dio: dio);
    repository = AiChatRepositoryImpl(datasource);
  });

  group('AiChatRemoteDatasourceImpl', () {
    test(
      'sendMessage posts with 90s receiveTimeout and forwards CancelToken',
      () async {
        final cancelToken = CancelToken();
        adapter.onFetch = (options) async {
          return _jsonResponse({
            'success': true,
            'data': {
              'session': {'id': 12, 'title': 'Pertanyaan Patroli'},
              'user_message': {'id': 1, 'role': 'user', 'content': 'Halo'},
              'assistant_message': {
                'id': 2,
                'role': 'assistant',
                'content': 'Halo juga!',
              },
            },
          });
        };

        final result = await datasource.sendMessage(
          sessionId: 12,
          message: 'Halo',
          cancelToken: cancelToken,
        );

        final captured = adapter.lastOptions!;
        expect(captured.method, 'POST');
        expect(captured.path, ApiConstants.aiChatMessages);
        expect(captured.receiveTimeout, const Duration(seconds: 90));
        expect(captured.cancelToken, same(cancelToken));
        expect(captured.data, {'session_id': 12, 'message': 'Halo'});
        expect(result.session?.id, 12);
        expect(result.assistantMessage.content, 'Halo juga!');
      },
    );

    test('getSessions sends optional search query param', () async {
      adapter.onFetch = (_) async => _jsonResponse({
        'success': true,
        'data': [
          {'id': 5, 'title': 'Laporan Banjir'},
        ],
      });

      final sessions = await datasource.getSessions(search: 'banjir');

      final captured = adapter.lastOptions!;
      expect(captured.method, 'GET');
      expect(captured.path, ApiConstants.aiChatSessions);
      expect(captured.queryParameters, {'search': 'banjir'});
      expect(sessions, hasLength(1));
      expect(sessions.first.id, 5);
    });

    test('getSessionDetail sends limit and before_id query params and parses nextBeforeId', () async {
      adapter.onFetch = (_) async => _jsonResponse({
        'success': true,
        'data': {
          'session': {'id': 5, 'title': 'Patroli Malam'},
          'messages': [
            {'id': 88, 'role': 'user', 'content': 'Status?'},
          ],
          'next_before_id': 77,
        },
      });

      final detail = await datasource.getSessionDetail(
        sessionId: 5,
        limit: 20,
        beforeId: 99,
      );

      final captured = adapter.lastOptions!;
      expect(captured.method, 'GET');
      expect(captured.path, ApiConstants.aiChatSessionDetail(5));
      expect(captured.queryParameters, {'limit': 20, 'before_id': 99});
      expect(detail.session.id, 5);
      expect(detail.nextBeforeId, 77);
    });

    test('renameSession sends PATCH and deleteSession sends DELETE', () async {
      adapter.onFetch = (_) async => _jsonResponse({
        'success': true,
        'data': {'id': 5, 'title': 'Baru'},
      });

      final renamed = await datasource.renameSession(
        sessionId: 5,
        title: 'Baru',
      );
      expect(adapter.lastOptions!.method, 'PATCH');
      expect(adapter.lastOptions!.path, ApiConstants.aiChatSessionDetail(5));
      expect(adapter.lastOptions!.data, {'title': 'Baru'});
      expect(renamed.title, 'Baru');

      adapter.onFetch = (_) async => _jsonResponse({'success': true});
      await datasource.deleteSession(5);
      expect(adapter.lastOptions!.method, 'DELETE');
      expect(adapter.lastOptions!.path, ApiConstants.aiChatSessionDetail(5));
    });
  });

  group('AiChatRepositoryImpl error mapping', () {
    test('maps 422 HTTP error to ValidationFailure', () async {
      adapter.onFetch = (_) async => _jsonResponse({
        'message': 'Validation failed',
        'errors': {
          'message': ['Pesan wajib diisi.'],
        },
      }, statusCode: 422);

      final result = await repository.sendMessage(message: '');

      expect(result.isLeft, isTrue);
      expect(result.left, isA<ValidationFailure>());
      expect(result.left.message, contains('Pesan wajib diisi.'));
    });

    test('maps connection error to NetworkFailure', () async {
      adapter.onFetch = (options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet',
        );
      };

      final result = await repository.getStatus();

      expect(result.isLeft, isTrue);
      expect(result.left, isA<NetworkFailure>());
    });
  });
}
