import 'dart:async';

import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:akar/features/ai_chat/domain/usecases/ai_chat_usecases.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_event.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_state.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// BLoC untuk mengelola percakapan, sesi riwayat, pembatalan request, dan guard offline Asisten AI Siska.
class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc({
    required this.getStatus,
    required this.sendMessage,
    required this.getSessions,
    required this.createSession,
    required this.getSessionDetail,
    required this.renameSession,
    required this.deleteSession,
    Future<bool> Function()? checkOffline,
    Stream<bool>? offlineStream,
  }) : _checkOffline = checkOffline ?? _defaultCheckOffline,
       super(const AiChatState()) {
    on<LoadAiChatInitialEvent>(_onLoadInitial);
    on<SendAiChatMessageEvent>(_onSendMessage);
    on<RetryFailedAiChatMessageEvent>(_onRetryFailedMessage);
    on<LoadAiChatSessionsEvent>(_onLoadSessions);
    on<SelectAiChatSessionEvent>(_onSelectSession);
    on<LoadMoreAiChatMessagesEvent>(_onLoadMore);
    on<StartNewAiChatSessionEvent>(_onStartNewSession);
    on<RenameAiChatSessionEvent>(_onRenameSession);
    on<DeleteAiChatSessionEvent>(_onDeleteSession);
    on<AiChatConnectivityChangedEvent>(_onConnectivityChanged);

    final stream =
        offlineStream ??
        (checkOffline == null ? _defaultOfflineStream() : null);
    if (stream != null) {
      try {
        _connectivitySub = stream.listen(
          (offline) => add(AiChatConnectivityChangedEvent(offline)),
          onError: (_) {},
        );
      } catch (_) {}
    }
  }

  final GetAiChatStatusUsecase getStatus;
  final SendAiChatMessageUsecase sendMessage;
  final GetAiChatSessionsUsecase getSessions;
  final CreateAiChatSessionUsecase createSession;
  final GetAiChatSessionDetailUsecase getSessionDetail;
  final RenameAiChatSessionUsecase renameSession;
  final DeleteAiChatSessionUsecase deleteSession;
  final Future<bool> Function() _checkOffline;

  StreamSubscription<bool>? _connectivitySub;
  CancelToken? _activeSendCancelToken;
  int _sessionEpoch = 0;
  int _localSequence = 0;

  static Future<bool> _defaultCheckOffline() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.every((r) => r == ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  static Stream<bool> _defaultOfflineStream() {
    try {
      return Connectivity().onConnectivityChanged.map(
        (results) => results.every((r) => r == ConnectivityResult.none),
      );
    } catch (_) {
      return const Stream<bool>.empty();
    }
  }

  void _cancelInFlightSend() {
    _sessionEpoch++;
    final token = _activeSendCancelToken;
    if (token != null && !token.isCancelled) {
      token.cancel('AiChat session changed');
    }
    _activeSendCancelToken = null;
  }

  Future<void> _onLoadInitial(
    LoadAiChatInitialEvent event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingStatus: true, clearErrorMessage: true));
    final offline = await _checkOffline();
    if (offline) {
      emit(state.copyWith(isLoadingStatus: false, isOffline: true));
      return;
    }

    final result = await getStatus();
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingStatus: false, errorMessage: failure.message),
      ),
      (status) => emit(
        state.copyWith(
          isLoadingStatus: false,
          isOffline: false,
          isEnabled: status.enabled,
          disabledMessage: status.disabledMessage,
          clearDisabledMessage: status.enabled,
        ),
      ),
    );
  }

  Future<void> _onSendMessage(
    SendAiChatMessageEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final trimmed = event.message.trim();
    if (trimmed.isEmpty ||
        state.isSending ||
        !state.isEnabled ||
        state.isOffline) {
      return;
    }

    final localId = 'local_${++_localSequence}';
    final optimisticUser = AiChatMessageEntity(
      localId: localId,
      role: AiChatMessageRole.user,
      content: trimmed,
      createdAt: DateTime.now(),
      sendStatus: AiChatMessageSendStatus.sending,
    );

    await _dispatchSend(
      messageText: trimmed,
      localId: localId,
      updatedMessages: [...state.messages, optimisticUser],
      emit: emit,
    );
  }

  Future<void> _onRetryFailedMessage(
    RetryFailedAiChatMessageEvent event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.isSending || !state.isEnabled || state.isOffline) return;

    final targetIndex = state.messages.indexWhere(
      (m) => m.localId == event.localId,
    );
    if (targetIndex == -1) return;

    final target = state.messages[targetIndex];
    final updatedMessages = List<AiChatMessageEntity>.from(state.messages)
      ..[targetIndex] = target.copyWith(
        sendStatus: AiChatMessageSendStatus.sending,
      );

    await _dispatchSend(
      messageText: target.content,
      localId: event.localId,
      updatedMessages: updatedMessages,
      emit: emit,
    );
  }

  Future<void> _dispatchSend({
    required String messageText,
    required String localId,
    required List<AiChatMessageEntity> updatedMessages,
    required Emitter<AiChatState> emit,
  }) async {
    final epoch = _sessionEpoch;
    final token = CancelToken();
    _activeSendCancelToken = token;

    emit(
      state.copyWith(
        messages: updatedMessages,
        isSending: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final result = await sendMessage(
        sessionId: state.activeSession?.id,
        message: messageText,
        cancelToken: token,
      );

      if (epoch != _sessionEpoch || token.isCancelled) return;
      _activeSendCancelToken = null;

      result.fold(
        (failure) {
          final failedMessages = state.messages
              .map(
                (m) => m.localId == localId
                    ? m.copyWith(sendStatus: AiChatMessageSendStatus.failed)
                    : m,
              )
              .toList();
          emit(
            state.copyWith(
              messages: failedMessages,
              isSending: false,
              errorMessage: failure.message,
            ),
          );
        },
        (data) {
          final finalizedMessages = state.messages.map((m) {
            if (m.localId != localId) return m;
            return (data.userMessage ?? m).copyWith(
              localId: localId,
              sendStatus: AiChatMessageSendStatus.sent,
            );
          }).toList()..add(data.assistantMessage);

          final nextSession = data.session ?? state.activeSession;
          emit(
            state.copyWith(
              activeSession: nextSession,
              messages: finalizedMessages,
              isSending: false,
            ),
          );
        },
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel || epoch != _sessionEpoch) return;
      _activeSendCancelToken = null;
      emit(state.copyWith(isSending: false, errorMessage: e.message));
    }
  }

  Future<void> _onLoadSessions(
    LoadAiChatSessionsEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final query = event.search?.trim() ?? '';
    emit(
      state.copyWith(
        isLoadingSessions: true,
        sessionSearchQuery: query,
        clearErrorMessage: true,
      ),
    );

    final result = await getSessions(search: query.isEmpty ? null : query);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingSessions: false, errorMessage: failure.message),
      ),
      (sessions) =>
          emit(state.copyWith(isLoadingSessions: false, sessions: sessions)),
    );
  }

  Future<void> _onSelectSession(
    SelectAiChatSessionEvent event,
    Emitter<AiChatState> emit,
  ) async {
    _cancelInFlightSend();
    final epoch = _sessionEpoch;

    emit(
      state.copyWith(
        isLoadingSession: true,
        isSending: false,
        clearErrorMessage: true,
      ),
    );

    final result = await getSessionDetail(sessionId: event.sessionId);
    if (epoch != _sessionEpoch) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingSession: false, errorMessage: failure.message),
      ),
      (detail) => emit(
        state.copyWith(
          isLoadingSession: false,
          activeSession: detail.session,
          messages: detail.messages,
          nextBeforeId: detail.nextBeforeId,
          clearNextBeforeId: detail.nextBeforeId == null,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreAiChatMessagesEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final sessionId = state.activeSession?.id;
    final beforeId = state.nextBeforeId;
    if (sessionId == null || beforeId == null || state.isLoadingMore) return;

    final epoch = _sessionEpoch;
    emit(state.copyWith(isLoadingMore: true));

    final result = await getSessionDetail(
      sessionId: sessionId,
      beforeId: beforeId,
    );
    if (epoch != _sessionEpoch) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (detail) {
        final existingIds = state.messages
            .map((m) => m.id)
            .whereType<int>()
            .toSet();
        final older = detail.messages
            .where((m) => m.id == null || !existingIds.contains(m.id))
            .toList();
        emit(
          state.copyWith(
            isLoadingMore: false,
            messages: [...older, ...state.messages],
            nextBeforeId: detail.nextBeforeId,
            clearNextBeforeId: detail.nextBeforeId == null,
          ),
        );
      },
    );
  }

  Future<void> _onStartNewSession(
    StartNewAiChatSessionEvent event,
    Emitter<AiChatState> emit,
  ) async {
    _cancelInFlightSend();
    emit(
      state.copyWith(
        clearActiveSession: true,
        messages: const [],
        clearNextBeforeId: true,
        isSending: false,
        isLoadingSession: false,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> _onRenameSession(
    RenameAiChatSessionEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final trimmed = event.title.trim();
    if (trimmed.isEmpty) return;

    final result = await renameSession(
      sessionId: event.sessionId,
      title: trimmed,
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updated) {
        final updatedSessions = state.sessions
            .map((s) => s.id == updated.id ? updated : s)
            .toList();
        final updatedActive = state.activeSession?.id == updated.id
            ? updated
            : state.activeSession;
        emit(
          state.copyWith(
            sessions: updatedSessions,
            activeSession: updatedActive,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteSession(
    DeleteAiChatSessionEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final isDeletingActive = state.activeSession?.id == event.sessionId;
    final result = await deleteSession(event.sessionId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final remaining = state.sessions
            .where((s) => s.id != event.sessionId)
            .toList();
        if (isDeletingActive) {
          _cancelInFlightSend();
          emit(
            state.copyWith(
              sessions: remaining,
              clearActiveSession: true,
              messages: const [],
              clearNextBeforeId: true,
              isSending: false,
            ),
          );
        } else {
          emit(state.copyWith(sessions: remaining));
        }
      },
    );
  }

  void _onConnectivityChanged(
    AiChatConnectivityChangedEvent event,
    Emitter<AiChatState> emit,
  ) {
    if (state.isOffline == event.isOffline) return;
    final wasOffline = state.isOffline;
    emit(state.copyWith(isOffline: event.isOffline));
    if (wasOffline && !event.isOffline && state.disabledMessage == null) {
      add(const LoadAiChatInitialEvent());
    }
  }

  /// Opsional: membuat sesi eksplisit bila dipanggil manual di luar auto-create send.
  Future<AiChatSessionEntity?> createExplicitSession({String? title}) async {
    final res = await createSession(title: title);
    return res.fold((_) => null, (s) => s);
  }

  @override
  Future<void> close() {
    _cancelInFlightSend();
    _connectivitySub?.cancel();
    return super.close();
  }
}
