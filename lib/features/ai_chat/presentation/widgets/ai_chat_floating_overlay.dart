import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

/// Overlay FAB Asisten AI Siska yang dapat digeser (drag) dan menempel otomatis ke tepi layar.
class AiChatFloatingOverlay extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AiChatFloatingOverlay({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<AiChatFloatingOverlay> createState() => _AiChatFloatingOverlayState();
}

class _AiChatFloatingOverlayState extends State<AiChatFloatingOverlay> {
  static const double _bubbleSize = 56;
  static const double _edgeMargin = 12;
  static const double _minTopClearance = 12;
  static const double _minBottomClearance = 44;

  double? _left;
  double? _top;
  bool _isDragging = false;

  void _clampToBounds(double maxWidth, double maxHeight) {
    final maxLeft = (maxWidth - _bubbleSize - _edgeMargin).clamp(
      _edgeMargin,
      double.infinity,
    );
    final maxTop = (maxHeight - _bubbleSize - _minBottomClearance).clamp(
      _minTopClearance,
      double.infinity,
    );
    _left = (_left ?? maxLeft).clamp(_edgeMargin, maxLeft);
    _top = (_top ?? maxTop).clamp(_minTopClearance, maxTop);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        _clampToBounds(maxWidth, maxHeight);

        final maxLeft = (maxWidth - _bubbleSize - _edgeMargin).clamp(
          _edgeMargin,
          double.infinity,
        );
        final maxTop = (maxHeight - _bubbleSize - _minBottomClearance).clamp(
          _minTopClearance,
          double.infinity,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            AnimatedPositioned(
              duration: _isDragging
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              left: _left!,
              top: _top!,
              child: GestureDetector(
                onPanStart: (_) => setState(() => _isDragging = true),
                onPanUpdate: (details) {
                  setState(() {
                    _left = (_left! + details.delta.dx).clamp(
                      _edgeMargin,
                      maxLeft,
                    );
                    _top = (_top! + details.delta.dy).clamp(
                      _minTopClearance,
                      maxTop,
                    );
                  });
                },
                onPanEnd: (_) {
                  final centerX = _left! + (_bubbleSize / 2);
                  final snapLeft = centerX < (maxWidth / 2)
                      ? _edgeMargin
                      : maxLeft;
                  setState(() {
                    _isDragging = false;
                    _left = snapLeft;
                  });
                },
                child: Semantics(
                  button: true,
                  label: 'Buka Asisten AI Siska',
                  child: Tooltip(
                    message: 'Tanya Asisten AI Siska',
                    child: Material(
                      key: const Key('ai_chat_floating_fab'),
                      color: colors.primary,
                      elevation: 6,
                      shadowColor: colors.shadow,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: colors.onPrimary.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: widget.onTap,
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          width: _bubbleSize,
                          height: _bubbleSize,
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: colors.onPrimary,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
