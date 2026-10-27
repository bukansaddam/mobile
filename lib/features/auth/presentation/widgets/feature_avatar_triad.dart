import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:akar/features/auth/presentation/widgets/feature_highlight_item.dart';
import 'package:akar/features/auth/presentation/widgets/triad_badge_item.dart';

export 'package:akar/features/auth/presentation/widgets/feature_highlight_item.dart';

/// A triad of overlapping circular avatar/icon badges representing features.
///
/// The three badges sit 120° apart on a shared orbit. The selected badge is at
/// the top of the ring, and every feature change rotates the whole ring, with
/// each badge counter-rotated so its icon stays upright.
class FeatureAvatarTriad extends StatefulWidget {
  final int selectedIndex;
  final List<FeatureHighlightItem> items;
  final ValueChanged<int> onSelected;

  const FeatureAvatarTriad({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onSelected,
  }) : assert(items.length == 3, 'FeatureAvatarTriad requires exactly 3 items');

  @override
  State<FeatureAvatarTriad> createState() => _FeatureAvatarTriadState();
}

class _FeatureAvatarTriadState extends State<FeatureAvatarTriad> {
  static const Duration _orbitDuration = Duration(milliseconds: 500);
  static const Curve _orbitCurve = Curves.easeInOutCubic;

  static const double _width = 160;
  static const double _height = 148;
  static const double _orbitCenterY = 74;
  static const double _orbitRadius = 32;
  static const double _badgeBox = 80;

  late double _turns;

  @override
  void initState() {
    super.initState();
    _turns = -widget.selectedIndex / 3;
  }

  @override
  void didUpdateWidget(FeatureAvatarTriad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;

    final diff = (widget.selectedIndex - oldWidget.selectedIndex) % 3;
    _turns += diff == 1 ? -1 / 3 : 1 / 3;
  }

  Offset _slotCenter(int index) {
    final angle = -math.pi / 2 + index * 2 * math.pi / 3;
    return Offset(
      _width / 2 + _orbitRadius * math.cos(angle),
      _orbitCenterY + _orbitRadius * math.sin(angle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = [
      (widget.selectedIndex + 2) % 3,
      (widget.selectedIndex + 1) % 3,
      widget.selectedIndex,
    ];

    return SizedBox(
      width: _width,
      height: _height,
      child: AnimatedRotation(
        turns: _turns,
        duration: _orbitDuration,
        curve: _orbitCurve,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final index in order)
              TriadBadgeItem(
                index: index,
                item: widget.items[index],
                isSelected: widget.selectedIndex == index,
                turns: _turns,
                orbitDuration: _orbitDuration,
                orbitCurve: _orbitCurve,
                center: _slotCenter(index),
                badgeBox: _badgeBox,
                onSelected: widget.onSelected,
              ),
          ],
        ),
      ),
    );
  }
}
