import 'package:material_ui/material_ui.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/profile/presentation/widgets/profile_points_card.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';

/// Kartu ringkasan saldo poin dan tombol penukaran voucher.
class VoucherSummaryCard extends StatelessWidget {
  final VoucherSummaryEntity summary;
  final bool isSubmitting;
  final VoidCallback onRedeemTap;

  const VoucherSummaryCard({
    super.key,
    required this.summary,
    required this.isSubmitting,
    required this.onRedeemTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final formattedPoints = ProfilePointsCard.formatPoints(
      summary.currentPoints,
    );

    final statusText = summary.canRedeem
        ? 'Dapat ditukar: ${summary.redeemableCount} voucher'
        : 'Kurang ${summary.pointsNeeded} poin untuk tukar voucher';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.warningLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.stars_rounded, color: colors.earth, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Poin Anda',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedPoints,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${summary.voucherPointCost} Poin = 1 Voucher',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: summary.canRedeem ? colors.success : colors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: (summary.canRedeem && !isSubmitting)
                  ? onRedeemTap
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.surfaceVariant,
                disabledForegroundColor: colors.textDisabled,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.redeem_rounded, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Tukar ${summary.voucherPointCost} Poin',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
