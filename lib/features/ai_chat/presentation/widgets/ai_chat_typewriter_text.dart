import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_formatted_text.dart';
import 'package:flutter/material.dart';

/// Menampilkan teks jawaban Siska secara bertahap (typewriter) tanpa mengubah posisi scroll.
class AiChatTypewriterText extends StatefulWidget {
  final String text;
  final TextStyle baseStyle;
  final bool animate;
  final VoidCallback? onCompleted;

  const AiChatTypewriterText({
    super.key,
    required this.text,
    required this.baseStyle,
    this.animate = false,
    this.onCompleted,
  });

  @override
  State<AiChatTypewriterText> createState() => _AiChatTypewriterTextState();
}

class _AiChatTypewriterTextState extends State<AiChatTypewriterText>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late List<int> _checkpoints;

  @override
  void initState() {
    super.initState();
    _checkpoints = _buildCheckpoints(widget.text);
    if (widget.animate && _checkpoints.length > 1) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant AiChatTypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _checkpoints = _buildCheckpoints(widget.text);
    }
    if (!widget.animate) {
      _controller?.stop();
    } else if (!oldWidget.animate || oldWidget.text != widget.text) {
      if (_checkpoints.length > 1) {
        _startAnimation();
      } else {
        widget.onCompleted?.call();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  List<int> _buildCheckpoints(String input) {
    if (input.isEmpty) return const [0];
    final tokenRegex = RegExp(r'(\*\*[^*\n]+\*\*|\*[^*\n]+\*|\S+\s*)');
    final points = <int>[];
    for (final match in tokenRegex.allMatches(input)) {
      points.add(match.end);
    }
    if (points.isEmpty || points.last != input.length) {
      points.add(input.length);
    }
    return points;
  }

  void _startAnimation() {
    _controller?.dispose();
    final ms = (_checkpoints.length * 38).clamp(280, 2200);
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms),
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onCompleted?.call();
      }
    });
    _controller = controller..forward();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (!widget.animate || controller == null) {
      return AiChatFormattedText(
        text: widget.text,
        baseStyle: widget.baseStyle,
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        final stepCount = (controller.value * _checkpoints.length).ceil().clamp(
          1,
          _checkpoints.length,
        );
        final endIndex = _checkpoints[stepCount - 1];
        return AiChatFormattedText(
          text: widget.text.substring(0, endIndex),
          baseStyle: widget.baseStyle,
        );
      },
    );
  }
}
