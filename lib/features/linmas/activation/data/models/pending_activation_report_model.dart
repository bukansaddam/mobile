class PendingActivationReportModel {
  final String id;
  final String userId;
  final String participantId;
  final String activityTitle;
  final List<String> attachmentPaths;
  final DateTime createdAt;
  final String? notes;
  final String? receiverNik;
  final String? receiverName;
  final String? lastError;

  const PendingActivationReportModel({
    required this.id,
    required this.userId,
    required this.participantId,
    required this.activityTitle,
    required this.attachmentPaths,
    required this.createdAt,
    this.notes,
    this.receiverNik,
    this.receiverName,
    this.lastError,
  });

  factory PendingActivationReportModel.fromJson(Map<String, dynamic> json) {
    return PendingActivationReportModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      participantId: json['participant_id'] as String,
      activityTitle: json['activity_title'] as String? ?? 'Penugasan',
      attachmentPaths: (json['attachments'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(
            int.tryParse(json['id'].toString()) ?? 0,
          ),
      notes: json['notes'] as String?,
      receiverNik: json['receiver_nik'] as String?,
      receiverName: json['receiver_name'] as String?,
      lastError: json['last_error'] as String?,
    );
  }

  bool belongsTo(String? currentUserId) {
    if (currentUserId == null) return userId.isEmpty;
    return userId.isEmpty || userId == currentUserId;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'participant_id': participantId,
    'activity_title': activityTitle,
    'attachments': attachmentPaths,
    'created_at': createdAt.toIso8601String(),
    'notes': notes,
    'receiver_nik': receiverNik,
    'receiver_name': receiverName,
    'last_error': lastError,
  };

  PendingActivationReportModel copyWith({String? lastError}) {
    return PendingActivationReportModel(
      id: id,
      userId: userId,
      participantId: participantId,
      activityTitle: activityTitle,
      attachmentPaths: attachmentPaths,
      createdAt: createdAt,
      notes: notes,
      receiverNik: receiverNik,
      receiverName: receiverName,
      lastError: lastError ?? this.lastError,
    );
  }
}
