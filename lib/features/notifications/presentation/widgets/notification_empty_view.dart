import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:material_ui/material_ui.dart';

/// Tampilan state kosong pada halaman daftar notifikasi.
class NotificationEmptyView extends StatelessWidget {
  final bool unreadOnlyFilter;
  final VoidCallback? onShowAll;

  const NotificationEmptyView({
    super.key,
    required this.unreadOnlyFilter,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final title = unreadOnlyFilter
        ? 'Tidak ada notifikasi belum dibaca'
        : 'Belum ada notifikasi';
    final subtitle = unreadOnlyFilter
        ? 'Semua pemberitahuan penting sudah Anda baca.'
        : 'Pembaruan laporan, aktivasi tugas, dan info penting akan muncul di sini.';

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight > 48
                  ? constraints.maxHeight - 48
                  : 0,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 40,
                      color: colors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  if (unreadOnlyFilter && onShowAll != null) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: onShowAll,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Tampilkan Semua Notifikasi'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
