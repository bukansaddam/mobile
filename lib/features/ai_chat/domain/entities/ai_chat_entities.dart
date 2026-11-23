import 'package:equatable/equatable.dart';

enum AiChatMessageRole { user, assistant }

enum AiChatMessageSendStatus { sent, sending, failed }

class AiChatStatusEntity extends Equatable {
  final bool enabled;
  final String? disabledMessage;

  const AiChatStatusEntity({required this.enabled, this.disabledMessage});

  @override
  List<Object?> get props => [enabled, disabledMessage];
}

class AiChatReferenceEntity extends Equatable {
  final String title;
  final String? source;
  final String? url;

  const AiChatReferenceEntity({required this.title, this.source, this.url});

  @override
  List<Object?> get props => [title, source, url];
}

class AiChatSessionEntity extends Equatable {
  final int id;
  final String title;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  const AiChatSessionEntity({
    required this.id,
    required this.title,
    this.updatedAt,
    this.createdAt,
  });

  AiChatSessionEntity copyWith({
    int? id,
    String? title,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return AiChatSessionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, updatedAt, createdAt];
}

class AiChatMessageEntity extends Equatable {
  final int? id;
  final String? localId;
  final AiChatMessageRole role;
  final String content;
  final DateTime? createdAt;
  final AiChatMessageSendStatus sendStatus;
  final List<AiChatReferenceEntity> references;

  const AiChatMessageEntity({
    this.id,
    this.localId,
    required this.role,
    required this.content,
    this.createdAt,
    this.sendStatus = AiChatMessageSendStatus.sent,
    this.references = const [],
  });

  AiChatMessageEntity copyWith({
    int? id,
    String? localId,
    AiChatMessageRole? role,
    String? content,
    DateTime? createdAt,
    AiChatMessageSendStatus? sendStatus,
    List<AiChatReferenceEntity>? references,
  }) {
    return AiChatMessageEntity(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      sendStatus: sendStatus ?? this.sendStatus,
      references: references ?? this.references,
    );
  }

  @override
  List<Object?> get props => [
    id,
    localId,
    role,
    content,
    createdAt,
    sendStatus,
    references,
  ];
}

class AiChatSessionDetailEntity extends Equatable {
  final AiChatSessionEntity session;
  final List<AiChatMessageEntity> messages;
  final int? nextBeforeId;

  const AiChatSessionDetailEntity({
    required this.session,
    required this.messages,
    this.nextBeforeId,
  });

  @override
  List<Object?> get props => [session, messages, nextBeforeId];
}

class AiChatSendResultEntity extends Equatable {
  final AiChatSessionEntity? session;
  final AiChatMessageEntity? userMessage;
  final AiChatMessageEntity assistantMessage;

  const AiChatSendResultEntity({
    this.session,
    this.userMessage,
    required this.assistantMessage,
  });

  @override
  List<Object?> get props => [session, userMessage, assistantMessage];
}
