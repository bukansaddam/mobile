import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/app_bar_notification_badge.dart';
import 'package:akar/features/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tombol lonceng notifikasi AppBar (48x48dp) dengan badge unread count reaktif.
///
/// Membaca [NotificationBloc] dari context bila tersedia; dapat ditimpa via
/// [unreadCount] untuk pengujian atau tampilan statis.
class AppBarNotificationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final int? unreadCount;

  const AppBarNotificationButton({super.key, this.onPressed, this.unreadCount});

  NotificationBloc? _maybeReadBloc(BuildContext context) {
    try {
      return context.read<NotificationBloc>();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final overrideCount = unreadCount;
    final bloc = overrideCount == null ? _maybeReadBloc(context) : null;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                fixedSize: const Size(36, 36),
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: AppColors.white.withValues(alpha: 0.9),
                shape: const CircleBorder(),
                side: const BorderSide(color: AppColors.grey300, width: 1),
              ),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
              tooltip: 'Notifikasi',
            ),
            if (overrideCount != null)
              AppBarNotificationBadge(count: overrideCount)
            else if (bloc != null)
              BlocSelector<NotificationBloc, NotificationState, int>(
                bloc: bloc,
                selector: (state) => state.unreadCount,
                builder: (context, count) =>
                    AppBarNotificationBadge(count: count),
              ),
          ],
        ),
      ),
    );
  }
}
