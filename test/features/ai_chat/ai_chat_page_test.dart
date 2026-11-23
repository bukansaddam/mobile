import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:akar/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:akar/features/ai_chat/domain/usecases/ai_chat_usecases.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_event.dart';
import 'package:akar/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestAiChatRepo implements AiChatRepository {
  AiChatStatusEntity status = const AiChatStatusEntity(enabled: true);
  final List<String> sentMessages = [];

  @override
  Future<Either<Failure, AiChatStatusEntity>> getStatus() async =>
      Right(status);

  @override
  Future<Either<Failure, AiChatSendResultEntity>> sendMessage({
    int? sessionId,
    required String message,
    CancelToken? cancelToken,
  }) async {
    sentMessages.add(message);
    return Right(
      AiChatSendResultEntity(
        session: const AiChatSessionEntity(id: 1, title: 'Sesi Uji'),
        userMessage: AiChatMessageEntity(
          id: 1,
          role: AiChatMessageRole.user,
          content: message,
        ),
        assistantMessage: const AiChatMessageEntity(
          id: 2,
          role: AiChatMessageRole.assistant,
          content: '**Jawaban**: Berikut langkahnya.\n- Cek kondisi sekitar',
          references: [AiChatReferenceEntity(title: 'SOP Patroli.pdf')],
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<AiChatSessionEntity>>> getSessions({
    String? search,
  }) async => const Right([]);

  @override
  Future<Either<Failure, AiChatSessionEntity>> createSession({
    String? title,
  }) async => const Right(AiChatSessionEntity(id: 1, title: 'Baru'));

  @override
  Future<Either<Failure, AiChatSessionDetailEntity>> getSessionDetail({
    required int sessionId,
    int limit = 20,
    int? beforeId,
  }) async => Right(
    AiChatSessionDetailEntity(
      session: AiChatSessionEntity(id: sessionId, title: 'Sesi #$sessionId'),
      messages: const [],
    ),
  );

  @override
  Future<Either<Failure, AiChatSessionEntity>> renameSession({
    required int sessionId,
    required String title,
  }) async => Right(AiChatSessionEntity(id: sessionId, title: title));

  @override
  Future<Either<Failure, void>> deleteSession(int sessionId) async =>
      const Right(null);
}

AiChatBloc _makeBloc(_TestAiChatRepo repo, {bool isOffline = false}) {
  return AiChatBloc(
    getStatus: GetAiChatStatusUsecase(repo),
    sendMessage: SendAiChatMessageUsecase(repo),
    getSessions: GetAiChatSessionsUsecase(repo),
    createSession: CreateAiChatSessionUsecase(repo),
    getSessionDetail: GetAiChatSessionDetailUsecase(repo),
    renameSession: RenameAiChatSessionUsecase(repo),
    deleteSession: DeleteAiChatSessionUsecase(repo),
    checkOffline: () async => isOffline,
  )..add(const LoadAiChatInitialEvent());
}

Widget _wrapPage({
  required AiChatBloc bloc,
  required bool isOfficer,
  ThemeData? theme,
  double textScale = 1.0,
}) {
  return MaterialApp(
    theme: theme ?? AppTheme.lightTheme,
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(320, 640),
        textScaler: TextScaler.linear(textScale),
      ),
      child: BlocProvider<AiChatBloc>.value(
        value: bloc,
        child: AiChatPage(isOfficerOverride: isOfficer),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'renders officer vs member role-specific quick prompts and dispatches send on tap',
    (tester) async {
      final repo = _TestAiChatRepo();
      final officerBloc = _makeBloc(repo);
      addTearDown(officerBloc.close);

      await tester.pumpWidget(_wrapPage(bloc: officerBloc, isOfficer: true));
      await tester.pumpAndSettle();

      expect(
        find.text('Apa itu Aslinmas dan apa saja fitur utamanya?'),
        findsOneWidget,
      );
      expect(
        find.text('Apa itu layanan Dumas dan bagaimana cara kerjanya?'),
        findsNothing,
      );

      await tester.tap(
        find.text('Apa itu Aslinmas dan apa saja fitur utamanya?'),
      );
      await tester.pumpAndSettle();

      expect(repo.sentMessages, [
        'Apa itu Aslinmas dan apa saja fitur utamanya?',
      ]);
      expect(find.textContaining('Berikut langkahnya.'), findsOneWidget);
      expect(find.text('SOP Patroli.pdf'), findsOneWidget);

      final memberRepo = _TestAiChatRepo();
      final memberBloc = _makeBloc(memberRepo);
      addTearDown(memberBloc.close);

      await tester.pumpWidget(_wrapPage(bloc: memberBloc, isOfficer: false));
      await tester.pumpAndSettle();

      expect(
        find.text('Apa itu layanan Dumas dan bagaimana cara kerjanya?'),
        findsOneWidget,
      );
      expect(
        find.text('Apa itu Aslinmas dan apa saja fitur utamanya?'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'enabled=false displays disabled_message banner and disables send button',
    (tester) async {
      final repo = _TestAiChatRepo()
        ..status = const AiChatStatusEntity(
          enabled: false,
          disabledMessage: 'AI Siska sedang dinonaktifkan admin.',
        );
      final bloc = _makeBloc(repo);
      addTearDown(bloc.close);

      await tester.pumpWidget(_wrapPage(bloc: bloc, isOfficer: false));
      await tester.pumpAndSettle();

      expect(find.text('AI Siska sedang dinonaktifkan admin.'), findsOneWidget);
      final sendButton = tester.widget<IconButton>(
        find.byKey(const Key('ai_chat_send_button')),
      );
      expect(sendButton.onPressed, isNull);
    },
  );

  testWidgets(
    'isOffline=true displays offline banner and disables send button',
    (tester) async {
      final repo = _TestAiChatRepo();
      final bloc = _makeBloc(repo, isOffline: true);
      addTearDown(bloc.close);

      await tester.pumpWidget(_wrapPage(bloc: bloc, isOfficer: true));
      await tester.pumpAndSettle();

      expect(find.textContaining('Sedang offline'), findsOneWidget);
      final sendButton = tester.widget<IconButton>(
        find.byKey(const Key('ai_chat_send_button')),
      );
      expect(sendButton.onPressed, isNull);
    },
  );

  testWidgets(
    'renders cleanly in Light and Dark themes on 320x640 with 2.0x text scale',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        final repo = _TestAiChatRepo();
        final bloc = _makeBloc(repo);
        addTearDown(bloc.close);

        await tester.pumpWidget(
          _wrapPage(bloc: bloc, isOfficer: true, theme: theme, textScale: 2.0),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    },
  );
}
