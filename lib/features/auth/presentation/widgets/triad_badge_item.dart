import 'package:flutter/material.dart';

import 'package:akar/features/auth/presentation/widgets/feature_highlight_item.dart';

class TriadBadgeItem extends StatelessWidget {
  final int index;
  final FeatureHighlightItem item;
  final bool isSelected;
  final double turns;
  final Duration orbitDuration;
  final Curve orbitCurve;
  final Offset center;
  final double badgeBox;
  final ValueChanged<int> onSelected;

  const TriadBadgeItem({
    super.key,
    required this.index,
    required this.item,
    required this.isSelected,
    required this.turns,
    required this.orbitDuration,
    required this.orbitCurve,
    required this.center,
    required this.badgeBox,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSelected ? 80.0 : 60.0;

    return Positioned(
      key: ValueKey(index),
      left: center.dx - badgeBox / 2,
      top: center.dy - badgeBox / 2,
      width: badgeBox,
      height: badgeBox,
      child: Center(
        child: AnimatedRotation(
          turns: -turns,
          duration: orbitDuration,
          curve: orbitCurve,
          child: Semantics(
            button: true,
            selected: isSelected,
            label: item.title,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutBack,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: item.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: isSelected ? 4.0 : 3.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isSelected ? 1.1 : 1.0,
                    child: Icon(
                      item.icon,
                      size: size * 0.44,
                      color: item.iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
