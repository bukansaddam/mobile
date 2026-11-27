import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';

import 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';

class TokohDetailSheet extends StatelessWidget {
  final TokohEntity tokoh;
  final VoidCallback? onEdit;

  const TokohDetailSheet({super.key, required this.tokoh, this.onEdit});

  static Future<void> show(
    BuildContext context,
    TokohEntity tokoh, {
    VoidCallback? onEdit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => TokohDetailSheet(tokoh: tokoh, onEdit: onEdit),
    );
  }

  Color _getAfiliasiColor(String afiliasi, AppColorScheme colors) {
    switch (afiliasi.toLowerCase()) {
      case 'politik':
        return colors.error;
      case 'ormas':
        return colors.orange;
      case 'agama':
        return colors.info;
      case 'budaya':
        return colors.indigo;
      case 'pemuda':
        return colors.success;
      case 'pengusaha':
        return colors.emerald;
      default:
        return colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final afiliasiColor = _getAfiliasiColor(tokoh.afiliasi, colors);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.borderStrong,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Tokoh Demografi',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Informasi profil lengkap tokoh',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: colors.primary,
                    child: Text(
                      tokoh.nama.isNotEmpty ? tokoh.nama[0].toUpperCase() : 'T',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tokoh.nama,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tokoh.profesi,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: afiliasiColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: afiliasiColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                tokoh.afiliasi,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: afiliasiColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: colors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.public_rounded,
                                    size: 12,
                                    color: colors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    tokoh.wilayah,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identitas Personal',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        children: [
                          _buildInfoTile(
                            colors: colors,
                            icon: Icons.wc_rounded,
                            label: 'Jenis Kelamin',
                            value: tokoh.jenisKelamin,
                          ),
                          Divider(height: 1, color: colors.divider),
                          _buildInfoTile(
                            colors: colors,
                            icon: Icons.work_outline_rounded,
                            label: 'Profesi',
                            value: tokoh.profesi,
                          ),
                          if (tokoh.suku.isNotEmpty) ...[
                            Divider(height: 1, color: colors.divider),
                            _buildInfoTile(
                              colors: colors,
                              icon: Icons.diversity_3_rounded,
                              label: 'Suku',
                              value: tokoh.suku,
                            ),
                          ],
                          Divider(height: 1, color: colors.divider),
                          _buildInfoTile(
                            colors: colors,
                            icon: Icons.phone_rounded,
                            label: 'No. Telepon',
                            value: tokoh.noTelp.isNotEmpty ? tokoh.noTelp : '-',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (tokoh.namaInstitusi.isNotEmpty) ...[
                      Text(
                        'Institusi',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          children: [
                            _buildInfoTile(
                              colors: colors,
                              icon: Icons.account_balance_rounded,
                              label: 'Nama Institusi',
                              value: tokoh.namaInstitusi,
                            ),
                            if (tokoh.jabatanInstitusi.isNotEmpty) ...[
                              Divider(height: 1, color: colors.divider),
                              _buildInfoTile(
                                colors: colors,
                                icon: Icons.badge_outlined,
                                label: 'Jabatan di Institusi',
                                value: tokoh.jabatanInstitusi,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (tokoh.namaOrganisasi.isNotEmpty) ...[
                      Text(
                        'Organisasi',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          children: [
                            _buildInfoTile(
                              colors: colors,
                              icon: Icons.groups_rounded,
                              label: 'Nama Organisasi',
                              value: tokoh.namaOrganisasi,
                            ),
                            if (tokoh.jabatanOrganisasi.isNotEmpty) ...[
                              Divider(height: 1, color: colors.divider),
                              _buildInfoTile(
                                colors: colors,
                                icon: Icons.badge_outlined,
                                label: 'Jabatan di Organisasi',
                                value: tokoh.jabatanOrganisasi,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (tokoh.createdAt != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 18,
                              color: colors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tanggal Disubmit: ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(tokoh.createdAt!)} WIB',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (onEdit != null) {
                            onEdit!();
                          } else {
                            context.push(
                              AppRouter.tambahTokohPath,
                              extra: tokoh,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Ubah Data',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required AppColorScheme colors,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
