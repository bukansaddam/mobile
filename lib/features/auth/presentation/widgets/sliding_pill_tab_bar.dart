import 'package:material_ui/material_ui.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/auth/presentation/widgets/pill_tab_button.dart';
import 'package:akar/features/auth/presentation/widgets/pill_tab_item.dart';

export 'package:akar/features/auth/presentation/widgets/pill_tab_item.dart';

/// A modern pill-shaped segmented tab bar with a sliding indicator.
///
/// Features fully rounded stadium borders, smooth animated sliding indicator,
/// and responsive layout adaptation.
class SlidingPillTabBar extends StatelessWidget {
  final int selectedIndex;
  final List<PillTabItem> tabs;
  final ValueChanged<int> onTabSelected;
  final double height;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;

  const SlidingPillTabBar({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onTabSelected,
    this.height = 48.0,
    this.backgroundColor,
    this.activeColor,
    this.activeTextColor,
    this.inactiveTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final resolvedBg = backgroundColor ?? colors.surfaceElevated;
    final resolvedActive = activeColor ?? colors.primary;
    final resolvedActiveText = activeTextColor ?? colors.onPrimary;
    final resolvedInactiveText = inactiveTextColor ?? colors.textSecondary;
    const padding = 4.0;
    final innerHeight = height - (padding * 2);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      padding: const EdgeInsets.all(padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / tabs.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutCubic,
                left: selectedIndex * tabWidth,
                top: 0,
                width: tabWidth,
                height: innerHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: resolvedActive,
                    borderRadius: BorderRadius.circular(innerHeight / 2),
                    boxShadow: [
                      BoxShadow(
                        color: resolvedActive.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                children: [
                  for (int i = 0; i < tabs.length; i++)
                    Expanded(
                      child: PillTabButton(
                        index: i,
                        tab: tabs[i],
                        isSelected: selectedIndex == i,
                        activeTextColor: resolvedActiveText,
                        inactiveTextColor: resolvedInactiveText,
                        onTabSelected: onTabSelected,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
