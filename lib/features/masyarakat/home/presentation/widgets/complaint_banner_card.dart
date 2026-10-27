import 'package:flutter/material.dart';

import 'package:akar/core/theme/app_colors.dart';

class ComplaintBannerCard extends StatelessWidget {
  final VoidCallback onCreateComplaint;

  const ComplaintBannerCard({
    super.key,
    required this.onCreateComplaint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: const Alignment(1.5, 1.0),
              child: Image.asset(
                'assets/placeholder_feature.jpeg',
                fit: BoxFit.cover,
                cacheHeight: 450,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: AppColors.primaryDark);
                },
              ),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primaryDark.withAlpha(245),
                      AppColors.primaryDark.withAlpha(180),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PENGADUAN\nMASYARAKAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sampaikan keluhan anda untuk\nlingkungan yang lebih baik.',
                        style: TextStyle(
                          color: Colors.white.withAlpha(230),
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.5,
                        child: ElevatedButton(
                          onPressed: onCreateComplaint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'BUAT PENGADUAN',
                              style: TextStyle(
                                color: AppColors.primaryDark,
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
