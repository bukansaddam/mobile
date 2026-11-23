import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:equatable/equatable.dart';

/// State terstruktur untuk layar Asisten AI Siska.
class AiChatState extends Equatable {
  final bool isLoadingStatus;
  final bool isEnabled;
  final String? disabledMessage;
  final bool isOffline;
  final AiChatSessionEntity? activeSession;
  final List<AiChatMessageEntity> messages;
  final int? nextBeforeId;
  final bool isSending;
  final bool isLoadingSession;
  final bool isLoadingMore;
  final bool isLoadingSessions;
  final List<AiChatSessionEntity> sessions;
  final String sessionSearchQuery;
  final String? errorMessage;

  const AiChatState({
    this.isLoadingStatus = false,
    this.isEnabled = true,
    this.disabledMessage,
    this.isOffline = false,
    this.activeSession,
    this.messages = const [],
    this.nextBeforeId,
    this.isSending = false,
    this.isLoadingSession = false,
    this.isLoadingMore = false,
    this.isLoadingSessions = false,
    this.sessions = const [],
    this.sessionSearchQuery = '',
    this.errorMessage,
  });

  bool get canSend =>
      isEnabled && !isOffline && !isSending && !isLoadingSession;

  AiChatState copyWith({
    bool? isLoadingStatus,
    bool? isEnabled,
    String? disabledMessage,
    bool clearDisabledMessage = false,
    bool? isOffline,
    AiChatSessionEntity? activeSession,
    bool clearActiveSession = false,
    List<AiChatMessageEntity>? messages,
    int? nextBeforeId,
    bool clearNextBeforeId = false,
    bool? isSending,
    bool? isLoadingSession,
    bool? isLoadingMore,
    bool? isLoadingSessions,
    List<AiChatSessionEntity>? sessions,
    String? sessionSearchQuery,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AiChatState(
      isLoadingStatus: isLoadingStatus ?? this.isLoadingStatus,
      isEnabled: isEnabled ?? this.isEnabled,
      disabledMessage: clearDisabledMessage
          ? null
          : (disabledMessage ?? this.disabledMessage),
      isOffline: isOffline ?? this.isOffline,
      activeSession: clearActiveSession
          ? null
          : (activeSession ?? this.activeSession),
      messages: messages ?? this.messages,
      nextBeforeId: clearNextBeforeId
          ? null
          : (nextBeforeId ?? this.nextBeforeId),
      isSending: isSending ?? this.isSending,
      isLoadingSession: isLoadingSession ?? this.isLoadingSession,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingSessions: isLoadingSessions ?? this.isLoadingSessions,
      sessions: sessions ?? this.sessions,
      sessionSearchQuery: sessionSearchQuery ?? this.sessionSearchQuery,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoadingStatus,
    isEnabled,
    disabledMessage,
    isOffline,
    activeSession,
    messages,
    nextBeforeId,
    isSending,
    isLoadingSession,
    isLoadingMore,
    isLoadingSessions,
    sessions,
    sessionSearchQuery,
    errorMessage,
  ];
}
