import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';

/// Floating dialog detail rincian voucher dan kode salin besar.
class VoucherDetailDialog extends StatelessWidget {
  final VoucherEntity voucher;
  final bool isNewlyRedeemed;
  final int? remainingPoints;

  const VoucherDetailDialog({
    super.key,
    required this.voucher,
    this.isNewlyRedeemed = false,
    this.remainingPoints,
  });

  static Future<void> show(
    BuildContext context, {
    required VoucherEntity voucher,
    bool isNewlyRedeemed = false,
    int? remainingPoints,
  }) {
    return AppDialogs.showCustom<void>(
      context,
      builder: (dialogContext) => VoucherDetailDialog(
        voucher: voucher,
        isNewlyRedeemed: isNewlyRedeemed,
        remainingPoints: remainingPoints,
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    try {
      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final Color badgeBg;
    final Color badgeFg;
    switch (voucher.status) {
      case VoucherStatus.active:
        badgeBg = colors.successLight;
        badgeFg = colors.success;
        break;
      case VoucherStatus.used:
        badgeBg = colors.surfaceVariant;
        badgeFg = colors.textSecondary;
        break;
      case VoucherStatus.expired:
        badgeBg = colors.errorLight;
        badgeFg = colors.errorDark;
        break;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RosetteBadge(
            icon: isNewlyRedeemed
                ? Icons.check_rounded
                : Icons.confirmation_number_rounded,
            badgeColor: isNewlyRedeemed
                ? colors.successLight
                : colors.primaryLight,
            iconColor: isNewlyRedeemed ? colors.success : colors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            isNewlyRedeemed ? 'Voucher Berhasil Ditukar' : 'Detail Voucher',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          if (isNewlyRedeemed && remainingPoints != null) ...[
            const SizedBox(height: 4),
            Text(
              'Voucher siap digunakan. Sisa poin: $remainingPoints Poin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: colors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border, width: 1.2),
            ),
            child: Column(
              children: [
                Text(
                  'KODE VOUCHER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.textMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  voucher.code,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: colors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        voucher.status.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: badgeFg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  label: 'Poin Digunakan',
                  value: '${voucher.pointsSpent} Poin',
                  colors: colors,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  label: 'Waktu Penukaran',
                  value: _formatDate(voucher.redeemedAt),
                  colors: colors,
                ),
                if (voucher.usedAt != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    label: 'Waktu Digunakan',
                    value: _formatDate(voucher.usedAt),
                    colors: colors,
                  ),
                ],
                if (voucher.notes != null &&
                    voucher.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    label: 'Catatan',
                    value: voucher.notes!.trim(),
                    colors: colors,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textSecondary,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tutup'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: voucher.code));
                      AppToast.showSuccess(
                        context,
                        message: 'Kode voucher disalin',
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Salin Kode'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required AppColorScheme colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
