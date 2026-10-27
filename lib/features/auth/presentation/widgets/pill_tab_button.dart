import 'package:flutter/material.dart';

import 'package:akar/features/auth/presentation/widgets/pill_tab_item.dart';

class PillTabButton extends StatelessWidget {
  final int index;
  final PillTabItem tab;
  final bool isSelected;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final ValueChanged<int> onTabSelected;

  const PillTabButton({
    super.key,
    required this.index,
    required this.tab,
    required this.isSelected,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: tab.label,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? activeTextColor : inactiveTextColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (tab.icon != null) ...[
                  Icon(
                    tab.icon,
                    size: 16,
                    color: isSelected ? activeTextColor : inactiveTextColor,
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
