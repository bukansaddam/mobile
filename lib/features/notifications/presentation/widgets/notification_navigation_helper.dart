import 'package:akar/core/routes/app_router.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:akar/features/notifications/presentation/pages/notification_page.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Helper navigasi terpusat untuk membuka pusat notifikasi dan menangani tap item.
class NotificationNavigationHelper {
  NotificationNavigationHelper._();

  /// Membuka halaman daftar notifikasi lalu menyegarkan badge unread saat kembali.
  static Future<void> openNotificationCenter(BuildContext context) async {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      await router.pushNamed(AppRouter.notifications);
    } else {
      await NotificationPage.show(context);
    }

    if (!context.mounted) return;
    _maybeBloc(context)?.add(const FetchNotificationCountEvent());
  }

  /// Menandai notifikasi sudah dibaca lalu mengarahkan ke halaman target bila tersedia.
  static Future<void> handleNotificationTap(
    BuildContext context,
    AppNotificationEntity item,
  ) async {
    if (item.isUnread) {
      _maybeBloc(context)?.add(MarkNotificationReadEvent(item.id));
    }

    final router = GoRouter.maybeOf(context);
    final isMember = _isMemberUser(context);

    if (router != null) {
      final reportId = item.resolvedReportId;
      if (item.isJagaTanah && !isMember && reportId != null) {
        await router.pushNamed(AppRouter.jagaTanahDetail, extra: reportId);
        return;
      }

      if (item.isRegularReport && reportId != null) {
        final placeholder = ComplaintItem(
          id: item.ticketNumber ?? reportId,
          reportId: reportId,
          title: item.title,
          category: 'Umum',
          dateTime: item.createdAt ?? DateTime.now(),
          description: item.body,
          location: '-',
          attachments: const [],
          status: complaintStatusFromCode(item.status ?? ''),
          statusLabel: item.status ?? '',
          statusHistory: const [],
          icon: Icons.assignment_outlined,
        );
        await router.pushNamed(AppRouter.complaintDetail, extra: placeholder);
        return;
      }

      final activationId = item.resolvedActivationId;
      if (item.isActivation && !isMember && activationId != null) {
        await router.pushNamed(
          AppRouter.activationDetail,
          extra: {'activityId': activationId, 'autoShowInfo': true},
        );
        return;
      }
    }

    if (!context.mounted) return;
    await NotificationDetailSheet.show(
      context,
      item,
      onOpenLaporanInsidentil:
          item.isEmergencyReport && !isMember && router != null
          ? () => router.pushNamed(AppRouter.laporanInsidentil)
          : null,
    );
  }

  static NotificationBloc? _maybeBloc(BuildContext context) {
    try {
      return context.read<NotificationBloc>();
    } catch (_) {
      return null;
    }
  }

  static bool _isMemberUser(BuildContext context) {
    try {
      final authState = context.read<AuthBloc>().state;
      return authState is AuthAuthenticated && authState.user.isMember;
    } catch (_) {
      return false;
    }
  }
}
