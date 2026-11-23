import 'dart:math' as math;

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_avatar.dart';
import 'package:flutter/material.dart';

/// Indikator animasi titik mengetik saat Siska sedang memproses jawaban.
class AiChatTypingIndicator extends StatefulWidget {
  const AiChatTypingIndicator({super.key});

  @override
  State<AiChatTypingIndicator> createState() => _AiChatTypingIndicatorState();
}

class _AiChatTypingIndicatorState extends State<AiChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Align(
      key: const Key('ai_chat_typing_indicator'),
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AiChatAvatar(size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Siska sedang mengetik',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 6),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final phase =
                        (_controller.value * 2 * math.pi) - (index * 0.9);
                    final offset = -3.0 * math.sin(phase).clamp(0.0, 1.0);
                    final alpha = 0.4 + 0.6 * math.sin(phase).clamp(0.0, 1.0);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.5),
                      child: Transform.translate(
                        offset: Offset(0, offset),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: alpha),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
