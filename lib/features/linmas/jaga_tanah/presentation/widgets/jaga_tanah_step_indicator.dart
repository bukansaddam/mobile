import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Indikator progres 5 langkah form Jaga Tanahku dengan slide horizontal pada layar sempit.
class JagaTanahStepIndicator extends StatefulWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTap;

  const JagaTanahStepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTap,
  });

  static const int totalSteps = 5;

  static const List<String> stepTitles = [
    'Informasi',
    'Lokasi',
    'Kondisi',
    'Penguasaan',
    'Review',
  ];

  @override
  State<JagaTanahStepIndicator> createState() => _JagaTanahStepIndicatorState();
}

class _JagaTanahStepIndicatorState extends State<JagaTanahStepIndicator> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollKey = GlobalKey();
  late final List<GlobalKey> _itemKeys = List.generate(
    JagaTanahStepIndicator.totalSteps,
    (_) => GlobalKey(),
  );

  @override
  void didUpdateWidget(covariant JagaTanahStepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollActiveIntoView(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollActiveIntoView() {
    if (!mounted || !_scrollController.hasClients) return;
    final safeStep = widget.currentStep.clamp(
      0,
      JagaTanahStepIndicator.totalSteps - 1,
    );
    final itemContext = _itemKeys[safeStep].currentContext;
    final scrollContext = _scrollKey.currentContext;
    if (itemContext == null || scrollContext == null) return;

    final itemBox = itemContext.findRenderObject() as RenderBox?;
    final scrollBox = scrollContext.findRenderObject() as RenderBox?;
    if (itemBox == null ||
        scrollBox == null ||
        !itemBox.attached ||
        !scrollBox.attached) {
      return;
    }

    final itemOffset = itemBox.localToGlobal(Offset.zero, ancestor: scrollBox);
    final desiredOffset =
        _scrollController.offset +
        itemOffset.dx -
        (scrollBox.size.width - itemBox.size.width) / 2;
    final clampedOffset = desiredOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    if ((clampedOffset - _scrollController.offset).abs() < 1.0) return;

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeStep = widget.currentStep.clamp(
      0,
      JagaTanahStepIndicator.totalSteps - 1,
    );

    final pills = List<Widget>.generate(JagaTanahStepIndicator.totalSteps, (
      index,
    ) {
      final isActive = index == safeStep;
      final isCompleted = index < safeStep;

      final Color bgColor;
      final Color borderColor;
      final Color textColor;
      if (isActive) {
        bgColor = AppColors.primaryDark;
        borderColor = AppColors.primaryDark;
        textColor = AppColors.white;
      } else if (isCompleted) {
        bgColor = AppColors.primaryLight;
        borderColor = AppColors.primaryDark.withValues(alpha: 0.35);
        textColor = AppColors.primaryDark;
      } else {
        bgColor = AppColors.white;
        borderColor = AppColors.grey300;
        textColor = AppColors.textSecondary;
      }

      return Material(
        key: _itemKeys[index],
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: isCompleted && widget.onStepTap != null
              ? () => widget.onStepTap!(index)
              : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(minWidth: 86, minHeight: 48),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${index + 1}',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  JagaTanahStepIndicator.stepTitles[index],
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: isActive || isCompleted
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: textColor,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (safeStep + 1) / JagaTanahStepIndicator.totalSteps,
            minHeight: 6,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1.0);
            final expandAll = constraints.maxWidth >= 540 && textScale <= 1.2;

            if (expandAll) {
              return Row(
                children: [
                  for (var i = 0; i < pills.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: pills[i]),
                  ],
                ],
              );
            }

            return Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                key: _scrollKey,
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (var i = 0; i < pills.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      pills[i],
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
