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
  final String title;
  final String category;
  final DateTime dateTime;
  final String description;
  final String location;
  final List<String> attachments;
  final ComplaintStatus status;
  final List<ComplaintStatusHistory> statusHistory;
  final IconData icon;

  const ComplaintItem({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.description,
    required this.location,
    required this.attachments,
    required this.status,
    required this.statusHistory,
    required this.icon,
  });

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
