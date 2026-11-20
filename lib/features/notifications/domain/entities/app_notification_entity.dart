import 'package:equatable/equatable.dart';

/// Tingkat urgensi notifikasi dari backend.
enum NotificationSeverity { normal, warning, critical, unknown }

/// Entitas domain untuk notifikasi in-app (lintas peran Linmas & Masyarakat).
class AppNotificationEntity extends Equatable {
  final String id;
  final String type;
  final String kind;
  final NotificationSeverity severity;
  final String title;
  final String body;
  final String? actionUrl;
  final String? status;
  final String? reportId;
  final String? ticketNumber;
  final String? reportSource;
  final String? activationRunId;
  final DateTime? dueDate;
  final int? totalTarget;
  final String? escalationLevel;
  final DateTime? readAt;
  final DateTime? createdAt;

  const AppNotificationEntity({
    required this.id,
    required this.type,
    required this.kind,
    required this.severity,
    required this.title,
    required this.body,
    this.actionUrl,
    this.status,
    this.reportId,
    this.ticketNumber,
    this.reportSource,
    this.activationRunId,
    this.dueDate,
    this.totalTarget,
    this.escalationLevel,
    this.readAt,
    this.createdAt,
  });

  bool get isRead => readAt != null;

  bool get isUnread => readAt == null;

  bool get isEscalation =>
      severity == NotificationSeverity.critical ||
      kind.contains('escalation') ||
      (escalationLevel != null &&
          escalationLevel!.isNotEmpty &&
          escalationLevel != '0');

  bool get isJagaTanah =>
      kind.startsWith('jaga_tanah') ||
      reportSource == 'jaga_tanah' ||
      (actionUrl?.contains('jaga-tanah') ?? false);

  bool get isActivation =>
      kind.startsWith('activation') ||
      (activationRunId != null && activationRunId!.isNotEmpty) ||
      (actionUrl?.contains('activation') ?? false);

  bool get isEmergencyReport =>
      kind == 'emergency_report_status_update' ||
      reportSource == 'emergency' ||
      (actionUrl?.contains('emergency') ?? false);

  bool get isRegularReport =>
      kind == 'report_status_update' ||
      reportSource == 'regular' ||
      ((actionUrl?.contains('/reports/') ?? false) &&
          !isJagaTanah &&
          !isEmergencyReport);

  /// Mengambil ID laporan dari field eksplisit maupun path [actionUrl].
  String? get resolvedReportId {
    if (reportId != null && reportId!.trim().isNotEmpty) {
      return reportId!.trim();
    }
    return _extractTrailingSegment(actionUrl);
  }

  /// Mengambil ID aktivasi dari field eksplisit maupun path [actionUrl].
  String? get resolvedActivationId {
    if (activationRunId != null && activationRunId!.trim().isNotEmpty) {
      return activationRunId!.trim();
    }
    if (!isActivation) return null;
    return _extractTrailingSegment(actionUrl);
  }

  static String? _extractTrailingSegment(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final parsed = Uri.tryParse(url.trim());
    final segments = (parsed?.pathSegments ?? url.split('/'))
        .where((s) => s.trim().isNotEmpty)
        .toList();
    if (segments.isEmpty) return null;
    final last = segments.last.trim();
    return last.isEmpty ? null : last;
  }

  AppNotificationEntity copyWith({DateTime? readAt, bool clearReadAt = false}) {
    return AppNotificationEntity(
      id: id,
      type: type,
      kind: kind,
      severity: severity,
      title: title,
      body: body,
      actionUrl: actionUrl,
      status: status,
      reportId: reportId,
      ticketNumber: ticketNumber,
      reportSource: reportSource,
      activationRunId: activationRunId,
      dueDate: dueDate,
      totalTarget: totalTarget,
      escalationLevel: escalationLevel,
      readAt: clearReadAt ? null : (readAt ?? this.readAt),
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    kind,
    severity,
    title,
    body,
    actionUrl,
    status,
    reportId,
    ticketNumber,
    reportSource,
    activationRunId,
    dueDate,
    totalTarget,
    escalationLevel,
    readAt,
    createdAt,
  ];
}
