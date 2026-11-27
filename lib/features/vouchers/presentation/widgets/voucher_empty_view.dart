import 'package:material_ui/material_ui.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';

/// Tampilan kondisi kosong saat belum ada voucher pada status tertentu.
class VoucherEmptyView extends StatelessWidget {
  final VoucherStatus status;

  const VoucherEmptyView({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final IconData icon;
    final String title;
    final String subtitle;

    switch (status) {
      case VoucherStatus.active:
        icon = Icons.confirmation_number_outlined;
        title = 'Belum Ada Voucher Aktif';
        subtitle =
            'Tukarkan 100 poin Anda di atas untuk mendapatkan kode voucher.';
        break;
      case VoucherStatus.used:
        icon = Icons.history_rounded;
        title = 'Belum Ada Voucher Terpakai';
        subtitle =
            'Voucher yang telah ditukarkan dan dipakai akan muncul di sini.';
        break;
      case VoucherStatus.expired:
        icon = Icons.timer_off_outlined;
        title = 'Tidak Ada Voucher Kedaluwarsa';
        subtitle =
            'Semua voucher Anda masih dalam masa berlaku atau telah dipakai.';
        break;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.textMuted, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: colors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
