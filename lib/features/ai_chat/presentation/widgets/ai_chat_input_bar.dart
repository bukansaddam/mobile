import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Bilah input pesan di bagian bawah layar chat AI dengan proteksi offline & disabled.
class AiChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool canSend;
  final bool isSending;
  final bool isEnabled;
  final bool isOffline;
  final VoidCallback onSend;

  const AiChatInputBar({
    super.key,
    required this.controller,
    required this.canSend,
    required this.isSending,
    required this.isEnabled,
    required this.isOffline,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final inputActive = isEnabled && !isOffline;
    final hint = isOffline
        ? 'Tidak ada koneksi internet'
        : !isEnabled
        ? 'Layanan AI sedang dinonaktifkan'
        : 'Tulis pertanyaan untuk Siska...';

    return Material(
      color: colors.surface,
      elevation: 4,
      shadowColor: colors.shadow,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colors.border)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: inputActive && !isSending,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) {
                    if (canSend) onSend();
                  },
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textHint,
                    ),
                    filled: true,
                    fillColor: colors.surfaceVariant,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: colors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: canSend ? colors.primary : colors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  key: const Key('ai_chat_send_button'),
                  onPressed: canSend ? onSend : null,
                  tooltip: 'Kirim pesan',
                  icon: isSending
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primary,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: canSend
                              ? colors.onPrimary
                              : colors.textDisabled,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
