import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_category.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

export 'complaint_category.dart';

enum ComplaintStatus {
  received(
    'Laporan Masuk',
    Color(0xFF2563EB),
    Color(0xFFEFF6FF),
    Icons.inbox_rounded,
  ),
  pending(
    'Menunggu Verifikasi',
    Color(0xFFD97706),
    Color(0xFFFEF3C7),
    Icons.hourglass_top_rounded,
  ),
  verified(
    'Diverifikasi',
    Color(0xFF0284C7),
    Color(0xFFE0F2FE),
    Icons.verified_user_rounded,
  ),
  rejected(
    'Ditolak',
    Color(0xFFDC2626),
    Color(0xFFFFEBEE),
    Icons.gavel_rounded,
  ),
  inProgress(
    'Diproses',
    Color(0xFFEA580C),
    Color(0xFFFFEDD5),
    Icons.engineering_rounded,
  ),
  completed(
    'Selesai',
    Color(0xFF16A34A),
    Color(0xFFDCFCE7),
    Icons.check_circle_rounded,
  ),
  cancelled(
    'Dibatalkan',
    Color(0xFF64748B),
    Color(0xFFF1F5F9),
    Icons.cancel_rounded,
  );

  final String label;
  final Color textColor;
  final Color bgColor;
  final IconData icon;

  const ComplaintStatus(this.label, this.textColor, this.bgColor, this.icon);
}

ComplaintStatus complaintStatusFromCode(String code) {
  switch (code.toLowerCase()) {
    case 'new':
    case 'created':
      return ComplaintStatus.received;
    case 'pending':
      return ComplaintStatus.pending;
    case 'verification':
    case 'verified':
    case 'in_review':
      return ComplaintStatus.verified;
    case 'in_progress':
    case 'processing':
      return ComplaintStatus.inProgress;
    case 'resolved':
    case 'completed':
    case 'done':
      return ComplaintStatus.completed;
    case 'rejected':
      return ComplaintStatus.rejected;
    case 'cancelled':
    case 'canceled':
      return ComplaintStatus.cancelled;
    default:
      return ComplaintStatus.received;
  }
}

String complaintStatusCode(ComplaintStatus status) => switch (status) {
  ComplaintStatus.received => 'new',
  ComplaintStatus.pending => 'pending',
  ComplaintStatus.verified => 'verification',
  ComplaintStatus.inProgress => 'in_progress',
  ComplaintStatus.completed => 'completed',
  ComplaintStatus.rejected => 'rejected',
  ComplaintStatus.cancelled => 'cancelled',
};

class ComplaintStatusHistory {
  final ComplaintStatus status;
  final DateTime dateTime;
  final String? note;

  const ComplaintStatusHistory({
    required this.status,
    required this.dateTime,
    this.note,
  });

  String get dateString {
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
    } catch (_) {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  String get timeString => '${DateFormat('HH:mm').format(dateTime)} WIB';

  String get fullDateTimeString => '$dateString • $timeString';
}

class ComplaintItem {
  final String id;
  final String? reportId;
  final String title;
  final String category;
  final DateTime dateTime;
  final String description;
  final String location;
  final List<String> attachments;
  final Set<String> videoUrls;
  final ComplaintStatus status;
  final String statusLabel;
  final List<ComplaintStatusHistory> statusHistory;
  final IconData icon;

  const ComplaintItem({
    required this.id,
    this.reportId,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.description,
    required this.location,
    required this.attachments,
    this.videoUrls = const {},
    required this.status,
    this.statusLabel = '',
    required this.statusHistory,
    required this.icon,
  });

  factory ComplaintItem.fromReport(ComplaintReportEntity report) {
    final status = complaintStatusFromCode(report.status);
    final dateTime = report.reportedAt ?? DateTime.now();
    final attachments = report.attachments
        .map((attachment) => attachment.url)
        .where((url) => url.isNotEmpty)
        .toList();

    return ComplaintItem(
      id: report.ticketNumber.isNotEmpty ? report.ticketNumber : report.id,
      reportId: report.id.isNotEmpty ? report.id : null,
      title: report.title,
      category: report.category.isNotEmpty ? report.category : 'Umum',
      dateTime: dateTime,
      description: report.description,
      location: report.address,
      attachments: attachments,
      videoUrls: report.attachments
          .where((attachment) => attachment.isVideo)
          .map((attachment) => attachment.url)
          .toSet(),
      status: status,
      statusLabel: report.statusLabel,
      icon: ComplaintCategory.getIconFor(report.category),
      statusHistory: report.timeline.isEmpty
          ? [
              ComplaintStatusHistory(
                status: status,
                dateTime: dateTime,
                note: report.statusLabel.isNotEmpty
                    ? report.statusLabel
                    : 'Laporan dibuat.',
              ),
            ]
          // API mengirim timeline terbaru-dulu; UI butuh urutan kronologis.
          : report.timeline.reversed
                .map(
                  (entry) => ComplaintStatusHistory(
                    status: status,
                    dateTime: entry.createdAt ?? dateTime,
                    note: entry.description,
                  ),
                )
                .toList(),
    );
  }

  bool isVideoAttachment(String path) =>
      videoUrls.contains(path) || FileSecurityUtils.isVideoPath(path);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} hari yang lalu';
    } else {
      try {
        return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
      } catch (_) {
        return DateFormat('dd MMM yyyy').format(dateTime);
      }
    }
  }

  String get formattedDateTime {
    try {
      return '${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dateTime)} WIB';
    } catch (_) {
      return '${DateFormat('dd MMM yyyy, HH:mm').format(dateTime)} WIB';
    }
  }
}
