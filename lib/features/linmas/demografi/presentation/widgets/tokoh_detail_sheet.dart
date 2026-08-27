import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/demografi/domain/entities/tokoh_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TokohDetailSheet extends StatelessWidget {
  final TokohEntity tokoh;

  const TokohDetailSheet({super.key, required this.tokoh});

  static Future<void> show(BuildContext context, TokohEntity tokoh) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => TokohDetailSheet(tokoh: tokoh),
    );
  }

  Color _getAfiliasiColor(String afiliasi) {
    switch (afiliasi.toLowerCase()) {
      case 'politik':
        return const Color(0xFFE53935);
      case 'ormas':
        return const Color(0xFFFB8C00);
      case 'agama':
        return const Color(0xFF1E88E5);
      case 'budaya':
        return const Color(0xFF8E24AA);
      case 'pemuda':
        return const Color(0xFF43A047);
      case 'pengusaha':
        return const Color(0xFF00ACC1);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final afiliasiColor = _getAfiliasiColor(tokoh.afiliasi);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sheet Title & Close Button
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Informasi profil lengkap tokoh',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.grey600),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Header Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        tokoh.nama.isNotEmpty ? tokoh.nama[0].toUpperCase() : 'T',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.white,
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
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tokoh.profesi,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              // Afiliasi Badge
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
                              // Wilayah Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grey100,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.grey300),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.public_rounded,
                                      size: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tokoh.wilayah,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
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

              // Section: Identitas & Profil
              Text(
                'Identitas Personal',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.wc_rounded,
                      label: 'Jenis Kelamin',
                      value: tokoh.jenisKelamin,
                    ),
                    const Divider(height: 1, color: AppColors.grey200),
                    _buildInfoTile(
                      icon: Icons.work_outline_rounded,
                      label: 'Profesi',
                      value: tokoh.profesi,
                    ),
                    if (tokoh.suku.isNotEmpty) ...[
                      const Divider(height: 1, color: AppColors.grey200),
                      _buildInfoTile(
                        icon: Icons.diversity_3_rounded,
                        label: 'Suku',
                        value: tokoh.suku,
                      ),
                    ],
                    const Divider(height: 1, color: AppColors.grey200),
                    _buildInfoTile(
                      icon: Icons.phone_rounded,
                      label: 'No. Telepon',
                      value: tokoh.noTelp.isNotEmpty ? tokoh.noTelp : '-',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section: Institusi (if available)
              if (tokoh.namaInstitusi.isNotEmpty) ...[
                Text(
                  'Institusi',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        icon: Icons.account_balance_rounded,
                        label: 'Nama Institusi',
                        value: tokoh.namaInstitusi,
                      ),
                      if (tokoh.jabatanInstitusi.isNotEmpty) ...[
                        const Divider(height: 1, color: AppColors.grey200),
                        _buildInfoTile(
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

              // Section: Organisasi (if available)
              if (tokoh.namaOrganisasi.isNotEmpty) ...[
                Text(
                  'Organisasi',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        icon: Icons.groups_rounded,
                        label: 'Nama Organisasi',
                        value: tokoh.namaOrganisasi,
                      ),
                      if (tokoh.jabatanOrganisasi.isNotEmpty) ...[
                        const Divider(height: 1, color: AppColors.grey200),
                        _buildInfoTile(
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

              // Section: Waktu Submission
              if (tokoh.createdAt != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: AppColors.grey600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tanggal Disubmit: ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(tokoh.createdAt!)} WIB',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
