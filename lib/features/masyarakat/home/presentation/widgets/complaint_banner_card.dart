import 'package:flutter/material.dart';

import 'package:akar/core/theme/app_color_scheme.dart';

class ComplaintBannerCard extends StatelessWidget {
  final VoidCallback onCreateComplaint;

  const ComplaintBannerCard({super.key, required this.onCreateComplaint});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bannerColor = colors.primaryGradient.colors.last;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: const Alignment(1.5, 1.0),
                child: Image.asset(
                  'assets/placeholder_feature.jpeg',
                  fit: BoxFit.cover,
                  cacheHeight: 450,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: bannerColor);
                  },
                ),
              ),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      bannerColor,
                      bannerColor.withAlpha(245),
                      bannerColor.withAlpha(180),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 0.65, 0.95],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DUMAS',
                    style: TextStyle(
                      color: Colors.white, // media-overlay
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dukungan masyarakat untuk\nlingkungan yang lebih baik',
                    style: TextStyle(
                      color: Colors.white.withAlpha(230), // media-overlay
                      fontSize: 12.5,
                      height: 1.35,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.5,
                        child: ElevatedButton(
                          onPressed: onCreateComplaint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.surface,
                            foregroundColor: colors.primaryDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'BUAT PENGADUAN',
                              style: TextStyle(
                                color: colors.primaryDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
