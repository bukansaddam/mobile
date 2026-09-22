import 'package:flutter/material.dart';
import 'package:akar/core/theme/app_colors.dart';

/// Provider for synchronized Shimmer animations across child widgets.
class Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(
      0xFFCBD5E1,
    ), // Slate-300: High contrast on white cards
    this.highlightColor = const Color(
      0xFFF8FAFC,
    ), // Slate-50: Crisp bright shimmer sweep
    this.duration = const Duration(milliseconds: 1400),
  });

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Listenable get listenable => _controller;
  double get value => _controller.value;
  Color get baseColor => widget.baseColor;
  Color get highlightColor => widget.highlightColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerScope(shimmerState: this, child: widget.child);
  }
}

class _ShimmerScope extends InheritedWidget {
  final ShimmerState shimmerState;

  const _ShimmerScope({required this.shimmerState, required super.child});

  @override
  bool updateShouldNotify(_ShimmerScope oldWidget) => false;
}

/// Shimmer effect applied only to its immediate child elements.
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? _localController;

  @override
  void dispose() {
    _localController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmer = Shimmer.of(context);
    final Listenable animation;
    final double Function() getValue;
    final Color base;
    final Color highlight;

    if (shimmer != null) {
      animation = shimmer.listenable;
      getValue = () => shimmer.value;
      base = widget.baseColor ?? shimmer.baseColor;
      highlight = widget.highlightColor ?? shimmer.highlightColor;
    } else {
      _localController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      )..repeat();
      animation = _localController!;
      getValue = () => _localController!.value;
      base = widget.baseColor ?? const Color(0xFFCBD5E1);
      highlight = widget.highlightColor ?? const Color(0xFFF8FAFC);
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, highlight, base],
              stops: const [0.1, 0.5, 0.9],
              transform: _SlidingGradientTransform(slidePercent: getValue()),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * (slidePercent * 2 - 1),
      0.0,
      0.0,
    );
  }
}

/// Placeholder box for shimmer skeletons with crisp contrast.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final ShapeBorder? shape;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: const Color(0xFFCBD5E1), // Slate-300
        shape:
            shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
      ),
    );
  }
}

/// Placeholder circle for shimmer skeletons with crisp contrast.
class ShimmerCircle extends StatelessWidget {
  final double radius;

  const ShimmerCircle({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: Color(0xFFCBD5E1), // Slate-300
        shape: BoxShape.circle,
      ),
    );
  }
}

/// White card container preserving card boundary and shadow, applying shimmer only to internal placeholders.
class _ShimmerCard extends StatelessWidget {
  final Widget child;

  const _ShimmerCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ShimmerLoading(child: child),
    );
  }
}

/// Prebuilt Shimmer Skeletons for Demografi screens (Tokoh, Institusi, Organisasi).
class DemografiShimmerList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext) itemBuilder;

  const DemografiShimmerList._({
    super.key,
    this.itemCount = 6,
    required this.itemBuilder,
  });

  factory DemografiShimmerList.tokoh({Key? key, int itemCount = 6}) {
    return DemografiShimmerList._(
      key: key,
      itemCount: itemCount,
      itemBuilder: (context) => const _TokohCardSkeleton(),
    );
  }

  factory DemografiShimmerList.institusi({Key? key, int itemCount = 6}) {
    return DemografiShimmerList._(
      key: key,
      itemCount: itemCount,
      itemBuilder: (context) => const _InstitusiCardSkeleton(),
    );
  }

  factory DemografiShimmerList.organisasi({Key? key, int itemCount = 6}) {
    return DemografiShimmerList._(
      key: key,
      itemCount: itemCount,
      itemBuilder: (context) => const _OrganisasiCardSkeleton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      baseColor: const Color(0xFFCBD5E1), // Clear Slate-300 placeholder
      highlightColor: const Color(0xFFF8FAFC), // Radiant white highlight
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: itemCount,
        itemBuilder: (context, index) => itemBuilder(context),
      ),
    );
  }
}

class _TokohCardSkeleton extends StatelessWidget {
  const _TokohCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _ShimmerCard(
      child: Row(
        children: [
          ShimmerCircle(radius: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 140, height: 16, borderRadius: 4),
                SizedBox(height: 6),
                ShimmerBox(width: 90, height: 12, borderRadius: 4),
              ],
            ),
          ),
          SizedBox(width: 8),
          ShimmerBox(width: 64, height: 24, borderRadius: 12),
        ],
      ),
    );
  }
}

class _InstitusiCardSkeleton extends StatelessWidget {
  const _InstitusiCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _ShimmerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 70, height: 18, borderRadius: 6),
                  SizedBox(height: 8),
                  ShimmerBox(width: 160, height: 16, borderRadius: 4),
                ],
              ),
              ShimmerBox(width: 70, height: 24, borderRadius: 12),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              ShimmerBox(width: 14, height: 14, borderRadius: 3),
              SizedBox(width: 6),
              ShimmerBox(width: 200, height: 12, borderRadius: 4),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              ShimmerBox(width: 14, height: 14, borderRadius: 3),
              SizedBox(width: 6),
              ShimmerBox(width: 130, height: 12, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrganisasiCardSkeleton extends StatelessWidget {
  const _OrganisasiCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _ShimmerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 70, height: 18, borderRadius: 6),
                  SizedBox(height: 8),
                  ShimmerBox(width: 160, height: 16, borderRadius: 4),
                ],
              ),
              ShimmerBox(width: 64, height: 24, borderRadius: 12),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              ShimmerBox(width: 14, height: 14, borderRadius: 3),
              SizedBox(width: 6),
              ShimmerBox(width: 190, height: 12, borderRadius: 4),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              ShimmerBox(width: 14, height: 14, borderRadius: 3),
              SizedBox(width: 6),
              ShimmerBox(width: 120, height: 12, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}
