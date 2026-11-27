import 'package:material_ui/material_ui.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';

/// Floating dialog konfirmasi penukaran poin ke kode voucher unik.
class VoucherRedeemDialog extends StatefulWidget {
  final VoucherSummaryEntity summary;

  const VoucherRedeemDialog({super.key, required this.summary});

  static Future<({bool confirmed, String notes})?> show(
    BuildContext context, {
    required VoucherSummaryEntity summary,
  }) {
    return AppDialogs.showCustom<({bool confirmed, String notes})?>(
      context,
      builder: (dialogContext) => VoucherRedeemDialog(summary: summary),
    );
  }

  @override
  State<VoucherRedeemDialog> createState() => _VoucherRedeemDialogState();
}

class _VoucherRedeemDialogState extends State<VoucherRedeemDialog> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final remainingEstimate =
        widget.summary.currentPoints - widget.summary.voucherPointCost;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RosetteBadge(
            icon: Icons.redeem_rounded,
            badgeColor: colors.primaryLight,
            iconColor: colors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Tukar Poin ke Voucher',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tukarkan 100 poin menjadi 1 kode voucher unik.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                _buildRow(
                  label: 'Poin saat ini',
                  value: '${widget.summary.currentPoints} Poin',
                  colors: colors,
                ),
                const SizedBox(height: 8),
                _buildRow(
                  label: 'Biaya penukaran',
                  value: '-${widget.summary.voucherPointCost} Poin',
                  colors: colors,
                  valueColor: colors.error,
                ),
                Divider(height: 16, thickness: 1, color: colors.divider),
                _buildRow(
                  label: 'Estimasi sisa poin',
                  value: '$remainingEstimate Poin',
                  colors: colors,
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _notesController,
            maxLength: 255,
            maxLines: 2,
            style: TextStyle(fontSize: 13, color: colors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Catatan (opsional)',
              labelStyle: TextStyle(fontSize: 13, color: colors.textMuted),
              hintText: 'Contoh: Tukar voucher sembako',
              hintStyle: TextStyle(fontSize: 12, color: colors.textHint),
              filled: true,
              fillColor: colors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, null),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textSecondary,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      final notes = _notesController.text.trim();
                      Navigator.pop(context, (confirmed: true, notes: notes));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tukar Sekarang',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildRow({
    required String label,
    required String value,
    required AppColorScheme colors,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: colors.textSecondary,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 12.5,
            color:
                valueColor ??
                (isBold ? colors.textPrimary : colors.textSecondary),
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
