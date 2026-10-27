import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/auth/presentation/widgets/map_pin_badge.dart';
import 'package:akar/features/auth/presentation/widgets/map_pin_data.dart';

export 'package:akar/features/auth/presentation/widgets/map_pin_data.dart';

/// A stylized dot-matrix map of Indonesia with floating animated pins.
///
/// Uses the transparent dot-matrix map asset with floating badge pins.
class IndonesiaDottedMap extends StatefulWidget {
  final double? height;
  final Color? mapColor;
  final List<MapPinData>? pins;

  const IndonesiaDottedMap({super.key, this.height, this.mapColor, this.pins});

  @override
  State<IndonesiaDottedMap> createState() => _IndonesiaDottedMapState();
}

class _IndonesiaDottedMapState extends State<IndonesiaDottedMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  static const List<MapPinData> _defaultPins = [
    MapPinData(
      x: 0.147,
      y: 0.390,
      color: Color(0xFF0284C7), // Sky Blue (Sumatra)
      icon: Icons.security_rounded,
      phase: 0.0,
    ),
    MapPinData(
      x: 0.358,
      y: 0.795,
      color: AppColors.primary, // Brand Green (Jawa)
      icon: Icons.shield_rounded,
      phase: 1.2,
    ),
    MapPinData(
      x: 0.416,
      y: 0.372,
      color: Color(0xFFEA580C), // Vibrant Orange (Kalimantan)
      icon: Icons.radar_rounded,
      phase: 2.4,
    ),
    MapPinData(
      x: 0.574,
      y: 0.485,
      color: Color(0xFF7C3AED), // Violet (Sulawesi)
      icon: Icons.people_alt_rounded,
      phase: 3.6,
    ),
    MapPinData(
      x: 0.600,
      y: 0.874,
      color: Color(0xFF0D9488), // Teal (Bali / NTB)
      icon: Icons.location_on_rounded,
      phase: 4.5,
    ),
    MapPinData(
      x: 0.909,
      y: 0.594,
      color: Color(0xFFE11D48), // Rose Red (Papua)
      icon: Icons.notifications_active_rounded,
      phase: 5.4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pins = widget.pins ?? _defaultPins;

    final content = AspectRatio(
      aspectRatio: 968 / 384,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/indonesia_map_dotted.webp',
                fit: BoxFit.contain,
                color: widget.mapColor,
                colorBlendMode: widget.mapColor != null
                    ? BlendMode.srcIn
                    : null,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/indonesia_map_dotted.png',
                    fit: BoxFit.contain,
                    color: widget.mapColor,
                    colorBlendMode: widget.mapColor != null
                        ? BlendMode.srcIn
                        : null,
                  );
                },
              ),

              AnimatedBuilder(
                animation: _floatController,
                builder: (context, _) {
                  final animVal = _floatController.value * 2 * math.pi;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (final pin in pins)
                        MapPinBadge(
                          pin: pin,
                          mapWidth: width,
                          mapHeight: height,
                          animVal: animVal,
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    if (widget.height != null) {
      return SizedBox(
        height: widget.height,
        child: Center(child: content),
      );
    }

    return content;
  }
}
