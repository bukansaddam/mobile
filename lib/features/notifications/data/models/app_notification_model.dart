import 'package:akar/features/notifications/data/models/notification_json_utils.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';

/// DTO model notifikasi tunggal dari `/api/notifications`.
class AppNotificationModel extends AppNotificationEntity {
  const AppNotificationModel({
    required super.id,
    required super.type,
    required super.kind,
    required super.severity,
    required super.title,
    required super.body,
    super.actionUrl,
    super.status,
    super.reportId,
    super.ticketNumber,
    super.reportSource,
    super.activationRunId,
    super.dueDate,
    super.totalTarget,
    super.escalationLevel,
    super.readAt,
    super.createdAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    final nestedData = notificationAsMap(json['data']);
    final payload = nestedData.isNotEmpty ? nestedData : json;

    final type = notificationAsString(
      json['type'] ?? payload['kind'],
      fallback: 'info',
    );
    final kind = notificationAsString(
      payload['kind'] ?? json['type'],
      fallback: type,
    );

    return AppNotificationModel(
      id: notificationAsString(json['id']),
      type: type,
      kind: kind,
      severity: _parseSeverity(payload['severity'] ?? json['severity']),
      title: notificationAsString(
        payload['title'] ?? json['title'],
        fallback: 'Notifikasi Baru',
      ),
      body: notificationAsString(
        payload['body'] ??
            payload['message'] ??
            json['body'] ??
            json['message'],
      ),
      actionUrl: notificationAsNullableString(
        payload['action_url'] ?? payload['actionUrl'] ?? json['action_url'],
      ),
      status: notificationAsNullableString(payload['status'] ?? json['status']),
      reportId: notificationAsNullableString(
        payload['report_id'] ?? payload['reportId'] ?? json['report_id'],
      ),
      ticketNumber: notificationAsNullableString(
        payload['ticket_number'] ??
            payload['ticketNumber'] ??
            json['ticket_number'],
      ),
      reportSource: notificationAsNullableString(
        payload['report_source'] ??
            payload['reportSource'] ??
            json['report_source'],
      ),
      activationRunId: notificationAsNullableString(
        payload['activation_run_id'] ??
            payload['activationRunId'] ??
            json['activation_run_id'],
      ),
      dueDate: notificationAsDateTime(
        payload['due_date'] ?? payload['dueDate'] ?? json['due_date'],
      ),
      totalTarget: notificationAsNullableInt(
        payload['total_target'] ??
            payload['totalTarget'] ??
            json['total_target'],
      ),
      escalationLevel: notificationAsNullableString(
        payload['escalation_level'] ??
            payload['escalationLevel'] ??
            json['escalation_level'],
      ),
      readAt: notificationAsDateTime(json['readAt'] ?? json['read_at']),
      createdAt: notificationAsDateTime(
        json['createdAt'] ?? json['created_at'],
      ),
    );
  }

  static NotificationSeverity _parseSeverity(Object? raw) {
    final value = notificationAsString(raw).toLowerCase();
    return switch (value) {
      'normal' || 'info' || 'low' => NotificationSeverity.normal,
      'warning' || 'warn' || 'medium' => NotificationSeverity.warning,
      'critical' ||
      'danger' ||
      'high' ||
      'emergency' => NotificationSeverity.critical,
      _ => NotificationSeverity.unknown,
    };
  }
}
