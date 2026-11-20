import 'dart:convert';
import 'dart:typed_data';

import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDioAdapter implements HttpClientAdapter {
  _FakeDioAdapter(this.onFetch);

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => onFetch(options);

  @override
  void close({bool force = false}) {}
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
  late NotificationRemoteDatasourceImpl datasource;
  RequestOptions? lastRequest;

  void setupResponder(Future<ResponseBody> Function(RequestOptions) responder) {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.httpClientAdapter = _FakeDioAdapter((options) {
      lastRequest = options;
      return responder(options);
    });
    datasource = NotificationRemoteDatasourceImpl(dio: dio);
  }

  group('NotificationRemoteDatasourceImpl', () {
    test(
      'getNotifications sends query params and parses paginated root map',
      () async {
        setupResponder(
          (_) async => _jsonResponse({
            'success': true,
            'unreadCount': 2,
            'escalationUnreadCount': 1,
            'data': [
              {
                'id': 'notif-1',
                'type': 'jaga_tanah_verified',
                'data': {
                  'kind': 'jaga_tanah_verified',
                  'severity': 'normal',
                  'title': 'Terverifikasi',
                  'body': 'Laporan Jaga Tanah disetujui.',
                  'report_id': 77,
                },
                'readAt': null,
                'createdAt': '2026-11-20T11:00:00Z',
              },
            ],
            'meta': {
              'current_page': 2,
              'last_page': 4,
              'per_page': 15,
              'total': 50,
            },
          }),
        );

        final page = await datasource.getNotifications(
          page: 2,
          perPage: 15,
          unreadOnly: true,
        );

        expect(lastRequest?.method, 'GET');
        expect(lastRequest?.path, '/api/notifications');
        expect(lastRequest?.queryParameters['page'], 2);
        expect(lastRequest?.queryParameters['per_page'], 15);
        expect(lastRequest?.queryParameters['unread_only'], true);
        expect(page.unreadCount, 2);
        expect(page.escalationUnreadCount, 1);
        expect(page.currentPage, 2);
        expect(page.lastPage, 4);
        expect(page.items.single.id, 'notif-1');
      },
    );

    test(
      'getNotifications maps 401 DioException to UnauthorizedException',
      () async {
        setupResponder(
          (_) async =>
              _jsonResponse({'message': 'Unauthenticated.'}, statusCode: 401),
        );

        expect(
          () => datasource.getNotifications(),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test('getNotificationCount unwraps /api/notifications/count', () async {
      setupResponder(
        (_) async => _jsonResponse({
          'success': true,
          'message': 'OK',
          'data': {
            'unreadCount': 5,
            'escalationUnreadCount': 2,
            'totalCount': 14,
          },
        }),
      );

      final count = await datasource.getNotificationCount();

      expect(lastRequest?.method, 'GET');
      expect(lastRequest?.path, '/api/notifications/count');
      expect(count.unreadCount, 5);
      expect(count.escalationUnreadCount, 2);
      expect(count.totalCount, 14);
    });

    test(
      'markAsRead sends PATCH /api/notifications/{id}/read and maps 404',
      () async {
        setupResponder(
          (_) async => _jsonResponse({
            'success': true,
            'message': 'Notifikasi ditandai sudah dibaca.',
          }),
        );

        await datasource.markAsRead('uuid-123');
        expect(lastRequest?.method, 'PATCH');
        expect(lastRequest?.path, '/api/notifications/uuid-123/read');

        setupResponder(
          (_) async => _jsonResponse({
            'success': false,
            'message': 'Notifikasi tidak ditemukan.',
          }, statusCode: 404),
        );

        expect(
          () => datasource.markAsRead('missing-id'),
          throwsA(isA<NotFoundException>()),
        );
      },
    );

    test('markAllAsRead sends POST /api/notifications/read-all', () async {
      setupResponder(
        (_) async => _jsonResponse({
          'success': true,
          'message': 'Semua notifikasi ditandai sudah dibaca.',
        }),
      );

      await datasource.markAllAsRead();
      expect(lastRequest?.method, 'POST');
      expect(lastRequest?.path, '/api/notifications/read-all');
    });
  });
}
