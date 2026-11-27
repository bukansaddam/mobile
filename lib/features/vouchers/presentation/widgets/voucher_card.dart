import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';

/// Kartu tampilan satu voucher dalam daftar.
class VoucherCard extends StatelessWidget {
  final VoucherEntity voucher;
  final VoidCallback onTap;

  const VoucherCard({super.key, required this.voucher, required this.onTap});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    try {
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year}';
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

    final dateLabel = voucher.status == VoucherStatus.used
        ? 'Dipakai: ${_formatDate(voucher.usedAt ?? voucher.redeemedAt)}'
        : 'Ditukar: ${_formatDate(voucher.redeemedAt)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.confirmation_number_rounded,
                        color: colors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        voucher.code,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            voucher.status.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: badgeFg,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (voucher.notes != null &&
                    voucher.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    voucher.notes!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Divider(height: 1, thickness: 1, color: colors.divider),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${voucher.pointsSpent} Poin',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: colors.earth,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (voucher.isActive)
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: TextButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: voucher.code),
                              );
                              AppToast.showSuccess(
                                context,
                                message: 'Kode voucher disalin',
                              );
                            },
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text('Salin Kode'),
                            style: TextButton.styleFrom(
                              foregroundColor: colors.primary,
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
