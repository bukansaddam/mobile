import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';

enum NotificationCategory { umum, pengaduan }

enum NotificationType {
  complaint, // Update status pengaduan
  announcement, // Pengumuman resmi
  system, // Informasi sistem
  disaster, // Peringatan bencana
  info, // Informasi umum
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime dateTime;
  final NotificationType type;
  final NotificationCategory category;
  final ComplaintItem? complaintItem;
  final ComplaintStatus? status;
  final IconData? customIcon;
  final Color? customIconColor;
  final Color? customBgColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.dateTime,
    this.type = NotificationType.complaint,
    this.category = NotificationCategory.pengaduan,
    this.complaintItem,
    this.status,
    this.customIcon,
    this.customIconColor,
    this.customBgColor,
    this.isRead = false,
  });

  bool get isComplaint =>
      category == NotificationCategory.pengaduan ||
      complaintItem != null ||
      type == NotificationType.complaint;

  String get displayMessage {
    if (complaintItem != null && complaintItem!.statusHistory.isNotEmpty) {
      final lastHistory = complaintItem!.statusHistory.last;
      if (lastHistory.note != null && lastHistory.note!.isNotEmpty) {
        return lastHistory.note!;
      }
    }
    return message;
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mnt lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hr lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  IconData get icon {
    if (customIcon != null) return customIcon!;
    if (complaintItem != null) return complaintItem!.icon;
    switch (type) {
      case NotificationType.disaster:
        return Icons.warning_amber_rounded;
      case NotificationType.announcement:
        return Icons.campaign_rounded;
      case NotificationType.system:
        return Icons.settings_suggest_rounded;
      case NotificationType.info:
        return Icons.info_outline_rounded;
      case NotificationType.complaint:
        return Icons.assignment_outlined;
    }
  }

  Color get iconColor {
    if (customIconColor != null) return customIconColor!;
    switch (type) {
      case NotificationType.disaster:
        return const Color(0xFFDC2626);
      case NotificationType.announcement:
        return const Color(0xFF2563EB);
      case NotificationType.system:
        return const Color(0xFF7C3AED);
      case NotificationType.info:
        return const Color(0xFF0D9488);
      case NotificationType.complaint:
        return const Color(0xFF64748B);
    }
  }

  Color get iconBgColor {
    if (customBgColor != null) return customBgColor!;
    switch (type) {
      case NotificationType.disaster:
        return const Color(0xFFFEF2F2);
      case NotificationType.announcement:
        return const Color(0xFFEFF6FF);
      case NotificationType.system:
        return const Color(0xFFF5F3FF);
      case NotificationType.info:
        return const Color(0xFFF0FDFA);
      case NotificationType.complaint:
        return const Color(0xFFF1F5F9);
    }
  }

  String get categoryLabel {
    switch (type) {
      case NotificationType.disaster:
        return 'Peringatan Bencana';
      case NotificationType.announcement:
        return 'Pengumuman';
      case NotificationType.system:
        return 'Sistem';
      case NotificationType.info:
        return 'Informasi';
      case NotificationType.complaint:
        return 'Pengaduan';
    }
  }
}
