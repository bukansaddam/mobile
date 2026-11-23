import 'package:flutter/material.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';

class PanicShimmerLoading extends StatelessWidget {
  const PanicShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      color: colors.background,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Shimmer(
                child: Column(
                  children: [
                    ShimmerCircle(radius: 30),
                    SizedBox(height: 16),
                    ShimmerBox(width: 180, height: 18, borderRadius: 6),
                    SizedBox(height: 10),
                    ShimmerBox(width: 220, height: 14, borderRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
