import 'package:equatable/equatable.dart';

/// Event domain presentasi untuk [AiChatBloc].
abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => const [];
}

class LoadAiChatInitialEvent extends AiChatEvent {
  const LoadAiChatInitialEvent();
}

class SendAiChatMessageEvent extends AiChatEvent {
  final String message;

  const SendAiChatMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class RetryFailedAiChatMessageEvent extends AiChatEvent {
  final String localId;

  const RetryFailedAiChatMessageEvent(this.localId);

  @override
  List<Object?> get props => [localId];
}

class LoadAiChatSessionsEvent extends AiChatEvent {
  final String? search;

  const LoadAiChatSessionsEvent({this.search});

  @override
  List<Object?> get props => [search];
}

class SelectAiChatSessionEvent extends AiChatEvent {
  final int sessionId;

  const SelectAiChatSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class LoadMoreAiChatMessagesEvent extends AiChatEvent {
  const LoadMoreAiChatMessagesEvent();
}

class StartNewAiChatSessionEvent extends AiChatEvent {
  const StartNewAiChatSessionEvent();
}

class RenameAiChatSessionEvent extends AiChatEvent {
  final int sessionId;
  final String title;

  const RenameAiChatSessionEvent({
    required this.sessionId,
    required this.title,
  });

  @override
  List<Object?> get props => [sessionId, title];
}

class DeleteAiChatSessionEvent extends AiChatEvent {
  final int sessionId;

  const DeleteAiChatSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class AiChatConnectivityChangedEvent extends AiChatEvent {
  final bool isOffline;

  const AiChatConnectivityChangedEvent(this.isOffline);

  @override
  List<Object?> get props => [isOffline];
}
