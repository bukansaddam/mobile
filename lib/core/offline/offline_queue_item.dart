enum OfflineFeatureType {
  jagaTanah,
  complaint,
  ronda,
  bankSampah,
  activation,
}

enum OfflineItemStatus {
  pending,
  waitingApproval,
  syncing,
  failedRetryable,
  failedPermanent,
}

class OfflineAttachment {
  final String fieldKey;
  final String localPath;
  final String originalName;
  final String mimeType;
  final int sizeBytes;
  final bool isVideo;
  final bool alreadyStamped;

  const OfflineAttachment({
    required this.fieldKey,
    required this.localPath,
    required this.originalName,
    required this.mimeType,
    required this.sizeBytes,
    required this.isVideo,
    this.alreadyStamped = false,
  });

  OfflineAttachment copyWith({
    String? fieldKey,
    String? localPath,
    String? originalName,
    String? mimeType,
    int? sizeBytes,
    bool? isVideo,
    bool? alreadyStamped,
  }) {
    return OfflineAttachment(
      fieldKey: fieldKey ?? this.fieldKey,
      localPath: localPath ?? this.localPath,
      originalName: originalName ?? this.originalName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      isVideo: isVideo ?? this.isVideo,
      alreadyStamped: alreadyStamped ?? this.alreadyStamped,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldKey': fieldKey,
      'localPath': localPath,
      'originalName': originalName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'isVideo': isVideo,
      'alreadyStamped': alreadyStamped,
    };
  }

  factory OfflineAttachment.fromJson(Map<String, dynamic> json) {
    return OfflineAttachment(
      fieldKey: json['fieldKey'] as String? ?? 'attachments[]',
      localPath: json['localPath'] as String? ?? '',
      originalName: json['originalName'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      isVideo: json['isVideo'] as bool? ?? false,
      alreadyStamped: json['alreadyStamped'] as bool? ?? false,
    );
  }
}

class OfflineQueueItem {
  final String id;
  final String clientRequestId;
  final OfflineFeatureType featureType;
  final String userId;
  final OfflineItemStatus status;
  final Map<String, dynamic> payload;
  final List<OfflineAttachment> attachments;
  final bool requiresCellularConsent;
  final bool isUserApprovedOnCellular;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? nextRetryAt;
  final int retryCount;
  final String? lastError;
  final int? lastStatusCode;

  const OfflineQueueItem({
    required this.id,
    required this.clientRequestId,
    required this.featureType,
    required this.userId,
    this.status = OfflineItemStatus.pending,
    required this.payload,
    this.attachments = const [],
    this.requiresCellularConsent = false,
    this.isUserApprovedOnCellular = false,
    required this.createdAt,
    required this.updatedAt,
    this.nextRetryAt,
    this.retryCount = 0,
    this.lastError,
    this.lastStatusCode,
  });

  OfflineQueueItem copyWith({
    String? id,
    String? clientRequestId,
    OfflineFeatureType? featureType,
    String? userId,
    OfflineItemStatus? status,
    Map<String, dynamic>? payload,
    List<OfflineAttachment>? attachments,
    bool? requiresCellularConsent,
    bool? isUserApprovedOnCellular,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? nextRetryAt,
    int? retryCount,
    String? lastError,
    int? lastStatusCode,
  }) {
    return OfflineQueueItem(
      id: id ?? this.id,
      clientRequestId: clientRequestId ?? this.clientRequestId,
      featureType: featureType ?? this.featureType,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      payload: payload ?? this.payload,
      attachments: attachments ?? this.attachments,
      requiresCellularConsent:
          requiresCellularConsent ?? this.requiresCellularConsent,
      isUserApprovedOnCellular:
          isUserApprovedOnCellular ?? this.isUserApprovedOnCellular,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      lastStatusCode: lastStatusCode ?? this.lastStatusCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientRequestId': clientRequestId,
      'featureType': featureType.name,
      'userId': userId,
      'status': status.name,
      'payload': payload,
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'requiresCellularConsent': requiresCellularConsent,
      'isUserApprovedOnCellular': isUserApprovedOnCellular,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'nextRetryAt': nextRetryAt?.toIso8601String(),
      'retryCount': retryCount,
      'lastError': lastError,
      'lastStatusCode': lastStatusCode,
    };
  }

  factory OfflineQueueItem.fromJson(Map<String, dynamic> json) {
    return OfflineQueueItem(
      id: json['id'] as String? ?? '',
      clientRequestId: json['clientRequestId'] as String? ?? '',
      featureType: OfflineFeatureType.values.firstWhere(
        (e) => e.name == json['featureType'],
        orElse: () => OfflineFeatureType.jagaTanah,
      ),
      userId: json['userId'] as String? ?? '',
      status: OfflineItemStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OfflineItemStatus.pending,
      ),
      payload: json['payload'] is Map
          ? Map<String, dynamic>.from(json['payload'] as Map)
          : <String, dynamic>{},
      attachments: (json['attachments'] as List?)
              ?.whereType<Map>()
              .map(
                (a) => OfflineAttachment.fromJson(Map<String, dynamic>.from(a)),
              )
              .toList() ??
          const [],
      requiresCellularConsent:
          json['requiresCellularConsent'] as bool? ?? false,
      isUserApprovedOnCellular:
          json['isUserApprovedOnCellular'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      nextRetryAt: json['nextRetryAt'] != null
          ? DateTime.tryParse(json['nextRetryAt'] as String)
          : null,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastError: json['lastError'] as String?,
      lastStatusCode: (json['lastStatusCode'] as num?)?.toInt(),
    );
  }
}
