import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Tampilan awal percakapan Siska dengan contoh pertanyaan cepat berbasis peran pengguna.
class AiChatEmptyView extends StatelessWidget {
  final bool isOfficer;
  final bool canSend;
  final ValueChanged<String> onSelectPrompt;

  const AiChatEmptyView({
    super.key,
    required this.isOfficer,
    required this.canSend,
    required this.onSelectPrompt,
  });

  static const List<String> _officerPrompts = [
    'Apa itu AKAR Aslinmas dan apa saja fitur utamanya?',
    'Bagaimana tugas dan peran Linmas di sistem Aslinmas?',
    'Bagaimana cara menggunakan fitur laporan dan presensi di Aslinmas?',
  ];

  static const List<String> _memberPrompts = [
    'Apa itu layanan Dumas AKAR dan bagaimana cara kerjanya?',
    'Jenis pengaduan apa saja yang bisa dilaporkan lewat Dumas?',
    'Bagaimana alur tindak lanjut aduan warga hingga selesai?',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final prompts = isOfficer ? _officerPrompts : _memberPrompts;
    final roleSubtitle = isOfficer
        ? 'Tanyakan informasi umum seputar Aslinmas, fitur aplikasi, dan panduan penggunaan.'
        : 'Tanyakan informasi umum seputar layanan Dumas, alur pengaduan, dan panduan aplikasi.';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: colors.primaryBorder),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: colors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Halo, saya Siska',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            roleSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pertanyaan Cepat',
              style: AppTextStyles.labelLarge.copyWith(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 10),
          ...prompts.map(
            (prompt) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: canSend ? () => onSelectPrompt(prompt) : null,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                          color: canSend ? colors.primary : colors.textDisabled,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            prompt,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: canSend
                                  ? colors.textPrimary
                                  : colors.textDisabled,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: canSend
                              ? colors.textMuted
                              : colors.textDisabled,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
