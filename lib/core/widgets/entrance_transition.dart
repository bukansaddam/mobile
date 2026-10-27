import 'package:flutter/material.dart';

/// Fades and lifts [child] in while [animation] runs between [start] and [end].
///
/// [start] and [end] are fractions (0-1) of the parent animation, so a single
/// controller can stagger several widgets. Respects reduced-motion settings.
class EntranceTransition extends StatelessWidget {
  final Animation<double> animation;
  final double start;
  final double end;
  final Widget child;

  const EntranceTransition({
    super.key,
    required this.animation,
    required this.start,
    required this.end,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
