import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/ai_chat/domain/entities/ai_chat_entities.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_avatar.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_typewriter_text.dart';
import 'package:material_ui/material_ui.dart';

/// Bubble percakapan tunggal untuk pesan pengguna atau Asisten AI Siska.
class AiChatMessageBubble extends StatelessWidget {
  final AiChatMessageEntity message;
  final VoidCallback? onRetry;
  final bool animateTyping;
  final VoidCallback? onTypingCompleted;

  const AiChatMessageBubble({
    super.key,
    required this.message,
    this.onRetry,
    this.animateTyping = false,
    this.onTypingCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isUser = message.role == AiChatMessageRole.user;
    final maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.82;

    final bubbleColor = isUser ? colors.primary : colors.surface;
    final textColor = isUser ? colors.onPrimary : colors.textPrimary;
    final textStyle = AppTextStyles.bodyMedium.copyWith(
      color: textColor,
      height: 1.4,
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 16),
            ),
            border: isUser ? null : Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AiChatAvatar(size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Asisten AI Siska',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              AiChatTypewriterText(
                text: message.content,
                baseStyle: textStyle,
                animate: !isUser && animateTyping,
                onCompleted: onTypingCompleted,
              ),
              if (!isUser &&
                  !animateTyping &&
                  message.references.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: message.references
                      .map(
                        (ref) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceElevated,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: 12,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  ref.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (isUser &&
                  message.sendStatus != AiChatMessageSendStatus.sent) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.sendStatus ==
                        AiChatMessageSendStatus.sending) ...[
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.6,
                          color: colors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Mengirim...',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ] else if (message.sendStatus ==
                        AiChatMessageSendStatus.failed) ...[
                      Icon(
                        Icons.error_outline_rounded,
                        size: 14,
                        color: colors.onPrimary,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onRetry,
                        child: Text(
                          'Gagal · Ketuk coba lagi',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colors.onPrimary,
                            decoration: TextDecoration.underline,
                            decorationColor: colors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
