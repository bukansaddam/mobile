import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}

Map<String, dynamic> _unwrapDataMap(dynamic raw) {
  final map = _asMap(raw);
  final data = map['data'];
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  return map;
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

String? _asNonEmptyString(dynamic value) {
  if (value == null) return null;
  final str = value.toString().trim();
  return str.isEmpty ? null : str;
}

DateTime? _asDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

class AiChatStatusModel {
  final bool enabled;
  final String? disabledMessage;

  const AiChatStatusModel({required this.enabled, this.disabledMessage});

  factory AiChatStatusModel.fromJson(dynamic raw) {
    final map = _unwrapDataMap(raw);
    bool resolvedEnabled = true;
    final rawEnabled =
        map['enabled'] ??
        map['is_enabled'] ??
        map['active'] ??
        map['available'];
    if (rawEnabled is bool) {
      resolvedEnabled = rawEnabled;
    } else if (rawEnabled is num) {
      resolvedEnabled = rawEnabled != 0;
    } else if (map['status'] is String) {
      final status = (map['status'] as String).trim().toLowerCase();
      if (status == 'disabled' ||
          status == 'inactive' ||
          status == 'maintenance' ||
          status == 'off') {
        resolvedEnabled = false;
      } else if (status == 'enabled' || status == 'active' || status == 'ok') {
        resolvedEnabled = true;
      }
    }

    final disabledMsg =
        _asNonEmptyString(map['disabled_message']) ??
        (resolvedEnabled ? null : _asNonEmptyString(map['message']));

    return AiChatStatusModel(
      enabled: resolvedEnabled,
      disabledMessage: disabledMsg,
    );
  }

  AiChatStatusEntity toDomain() =>
      AiChatStatusEntity(enabled: enabled, disabledMessage: disabledMessage);
}

class AiChatReferenceModel {
  final String title;
  final String? source;
  final String? url;

  const AiChatReferenceModel({required this.title, this.source, this.url});

  factory AiChatReferenceModel.fromJson(dynamic raw) {
    final map = _asMap(raw);
    final title =
        _asNonEmptyString(map['title']) ??
        _asNonEmptyString(map['document_name']) ??
        _asNonEmptyString(map['name']) ??
        _asNonEmptyString(map['source']) ??
        'Dokumen Referensi';
    return AiChatReferenceModel(
      title: title,
      source: _asNonEmptyString(map['source']),
      url: _asNonEmptyString(map['url']),
    );
  }

  AiChatReferenceEntity toDomain() =>
      AiChatReferenceEntity(title: title, source: source, url: url);
}

class AiChatSessionModel {
  final int id;
  final String title;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  const AiChatSessionModel({
    required this.id,
    required this.title,
    this.updatedAt,
    this.createdAt,
  });

  factory AiChatSessionModel.fromJson(dynamic raw) {
    final map = _unwrapDataMap(raw);
    final nestedSession = map['session'] is Map ? _asMap(map['session']) : map;
    final id = _asInt(nestedSession['id'] ?? nestedSession['session_id']) ?? 0;
    final title =
        _asNonEmptyString(nestedSession['title']) ??
        _asNonEmptyString(nestedSession['name']) ??
        'Percakapan Baru';

    return AiChatSessionModel(
      id: id,
      title: title,
      updatedAt: _asDateTime(nestedSession['updated_at']),
      createdAt: _asDateTime(nestedSession['created_at']),
    );
  }

  static List<AiChatSessionModel> parseModelList(dynamic raw) {
    final root = _asMap(raw);
    final listCandidate = root['data'] is List
        ? root['data'] as List
        : (root['sessions'] is List
              ? root['sessions'] as List
              : (raw is List ? raw : const []));

    return listCandidate
        .whereType<Map>()
        .map(AiChatSessionModel.fromJson)
        .where((session) => session.id > 0)
        .toList();
  }

  static List<AiChatSessionEntity> parseList(dynamic raw) =>
      parseModelList(raw).map((m) => m.toDomain()).toList();

  AiChatSessionEntity toDomain() => AiChatSessionEntity(
    id: id,
    title: title,
    updatedAt: updatedAt,
    createdAt: createdAt,
  );
}

class AiChatMessageModel {
  final int? id;
  final AiChatMessageRole role;
  final String content;
  final DateTime? createdAt;
  final List<AiChatReferenceModel> references;

  const AiChatMessageModel({
    this.id,
    required this.role,
    required this.content,
    this.createdAt,
    this.references = const [],
  });

  factory AiChatMessageModel.fromJson(
    dynamic raw, {
    AiChatMessageRole fallbackRole = AiChatMessageRole.assistant,
  }) {
    final map = _asMap(raw);
    final rawRole = _asNonEmptyString(map['role'] ?? map['sender'])
        ?.toLowerCase();
    final role = switch (rawRole) {
      'user' || 'human' => AiChatMessageRole.user,
      'assistant' || 'bot' || 'ai' || 'siska' => AiChatMessageRole.assistant,
      _ => fallbackRole,
    };

    final content =
        _asNonEmptyString(map['content']) ??
        _asNonEmptyString(map['message']) ??
        _asNonEmptyString(map['text']) ??
        _asNonEmptyString(map['answer']) ??
        _asNonEmptyString(map['reply']) ??
        '';

    final rawRefs = map['references'];
    final refs = rawRefs is List
        ? rawRefs
              .whereType<Map>()
              .map((item) => AiChatReferenceModel.fromJson(item))
              .toList()
        : const <AiChatReferenceModel>[];

    return AiChatMessageModel(
      id: _asInt(map['id']),
      role: role,
      content: content,
      createdAt: _asDateTime(map['created_at']),
      references: refs,
    );
  }

  AiChatMessageEntity toDomain() => AiChatMessageEntity(
    id: id,
    role: role,
    content: content,
    createdAt: createdAt,
    sendStatus: AiChatMessageSendStatus.sent,
    references: references.map((r) => r.toDomain()).toList(),
  );
}

class AiChatSessionDetailModel {
  final AiChatSessionModel session;
  final List<AiChatMessageModel> messages;
  final int? nextBeforeId;

  const AiChatSessionDetailModel({
    required this.session,
    required this.messages,
    this.nextBeforeId,
  });

  factory AiChatSessionDetailModel.fromJson(dynamic raw) {
    final map = _unwrapDataMap(raw);
    final sessionMap = map['session'] is Map ? map['session'] : map;
    final session = AiChatSessionModel.fromJson(sessionMap);

    final rawMessages = map['messages'] is List
        ? map['messages'] as List
        : (map['items'] is List ? map['items'] as List : const []);

    final messages = rawMessages
        .whereType<Map>()
        .map((item) => AiChatMessageModel.fromJson(item))
        .toList();

    final meta = _asMap(map['meta']);
    final pagination = _asMap(map['pagination']);
    final nextBeforeId = _asInt(
      map['next_before_id'] ??
          meta['next_before_id'] ??
          pagination['next_before_id'],
    );

    return AiChatSessionDetailModel(
      session: session,
      messages: messages,
      nextBeforeId: nextBeforeId,
    );
  }

  AiChatSessionDetailEntity toDomain() => AiChatSessionDetailEntity(
    session: session.toDomain(),
    messages: messages.map((m) => m.toDomain()).toList(),
    nextBeforeId: nextBeforeId,
  );
}

class AiChatSendResultModel {
  final AiChatSessionModel? session;
  final AiChatMessageModel? userMessage;
  final AiChatMessageModel assistantMessage;

  const AiChatSendResultModel({
    this.session,
    this.userMessage,
    required this.assistantMessage,
  });

  factory AiChatSendResultModel.fromJson(dynamic raw) {
    final map = _unwrapDataMap(raw);

    AiChatSessionModel? session;
    if (map['session'] is Map) {
      session = AiChatSessionModel.fromJson(map['session']);
    } else if (_asInt(map['session_id']) != null) {
      session = AiChatSessionModel.fromJson({
        'id': map['session_id'],
        'title': map['title'] ?? 'Percakapan',
      });
    }

    AiChatMessageModel? userMessage;
    if (map['user_message'] is Map) {
      userMessage = AiChatMessageModel.fromJson(
        map['user_message'],
        fallbackRole: AiChatMessageRole.user,
      );
    }

    AiChatMessageModel? assistantMessage;
    final assistantRaw =
        map['assistant_message'] ?? map['reply_message'] ?? map['assistant'];
    if (assistantRaw is Map) {
      assistantMessage = AiChatMessageModel.fromJson(
        assistantRaw,
        fallbackRole: AiChatMessageRole.assistant,
      );
    } else if (map['messages'] is List) {
      final list = (map['messages'] as List).whereType<Map>().toList();
      for (final m in list.reversed) {
        final parsed = AiChatMessageModel.fromJson(m);
        if (parsed.role == AiChatMessageRole.assistant) {
          assistantMessage = parsed;
          break;
        }
      }
      if (userMessage == null) {
        for (final m in list) {
          final parsed = AiChatMessageModel.fromJson(m);
          if (parsed.role == AiChatMessageRole.user) {
            userMessage = parsed;
            break;
          }
        }
      }
    }

    assistantMessage ??= AiChatMessageModel.fromJson({
      'content':
          map['reply'] ??
          map['answer'] ??
          map['response'] ??
          map['message'] ??
          '',
      'references': map['references'],
      'created_at': map['created_at'],
    }, fallbackRole: AiChatMessageRole.assistant);

    if (assistantMessage.references.isEmpty && map['references'] is List) {
      final topRefs = (map['references'] as List)
          .whereType<Map>()
          .map(AiChatReferenceModel.fromJson)
          .toList();
      if (topRefs.isNotEmpty) {
        assistantMessage = AiChatMessageModel(
          id: assistantMessage.id,
          role: assistantMessage.role,
          content: assistantMessage.content,
          createdAt: assistantMessage.createdAt,
          references: topRefs,
        );
      }
    }

    return AiChatSendResultModel(
      session: session,
      userMessage: userMessage,
      assistantMessage: assistantMessage,
    );
  }

  AiChatSendResultEntity toDomain() => AiChatSendResultEntity(
    session: session?.toDomain(),
    userMessage: userMessage?.toDomain(),
    assistantMessage: assistantMessage.toDomain(),
  );
}
