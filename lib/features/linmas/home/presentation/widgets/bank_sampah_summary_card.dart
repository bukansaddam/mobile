import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankSampahSummaryCard extends StatefulWidget {
  final UserEntity? user;
  final String? userName;
  final String? userPhone;
  final String? userPhotoUrl;
  final double totalBeratKg;
  final double totalNilaiRupiah;
  final VoidCallback? onTap;
  final VoidCallback? onAvatarTap;

  const BankSampahSummaryCard({
    super.key,
    this.user,
    this.userName,
    this.userPhone,
    this.userPhotoUrl,
    required this.totalBeratKg,
    required this.totalNilaiRupiah,
    this.onTap,
    this.onAvatarTap,
  });

  @override
  State<BankSampahSummaryCard> createState() => _BankSampahSummaryCardState();
}

class _BankSampahSummaryCardState extends State<BankSampahSummaryCard> {
  bool _isBalanceHidden = false;

  String _formatBerat(double kg) {
    if (kg % 1 == 0) {
      return '${kg.toInt()} Kg';
    }
    return '${kg.toStringAsFixed(1)} Kg';
  }

  String _formatRupiah(double rupiah) {
    if (_isBalanceHidden) {
      return '••••••••';
    }
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(rupiah);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final name = (widget.userName != null && widget.userName!.trim().isNotEmpty)
        ? widget.userName!.trim()
        : ((widget.user?.name != null && widget.user!.name!.trim().isNotEmpty)
              ? widget.user!.name!.trim()
              : 'Pengguna');

    final phoneNumber =
        (widget.userPhone != null && widget.userPhone!.trim().isNotEmpty)
        ? widget.userPhone!.trim()
        : ((widget.user?.phoneNumber != null &&
                  widget.user!.phoneNumber!.trim().isNotEmpty)
              ? widget.user!.phoneNumber!.trim()
              : '-');

    final photoUrl = widget.userPhotoUrl;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onAvatarTap,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary.withValues(alpha: 0.1),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: ClipOval(
                      child: photoUrl != null && photoUrl.isNotEmpty
                          ? AppNetworkImage(
                              imageUrl: photoUrl,
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              errorIcon: Icons.person_rounded,
                              backgroundColor: Colors.transparent,
                            )
                          : Icon(
                              Icons.person_rounded,
                              size: 24,
                              color: colors.primary,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone_android_rounded,
                            size: 13,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              phoneNumber,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              'Total Pendapatan Bank Sampah',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _formatRupiah(widget.totalNilaiRupiah),
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isBalanceHidden = !_isBalanceHidden;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      _isBalanceHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Icon(Icons.recycling_rounded, size: 14, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  'Total Sampah Disetor: ',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
                Text(
                  _formatBerat(widget.totalBeratKg),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: colors.divider),
            const SizedBox(height: 8),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lihat Detail',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
