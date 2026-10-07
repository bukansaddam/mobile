import 'package:flutter/material.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/linmas/ronda_malam/core/constants/ronda_constants.dart';

class RondaStepIndicator extends StatelessWidget {
  final int currentStep;

  const RondaStepIndicator({super.key, required this.currentStep});

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.cleaning_services_rounded;
      case 1:
        return Icons.security_rounded;
      case 2:
        return Icons.eco_rounded;
      case 3:
      default:
        return Icons.edit_note_rounded;
    }
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 0:
        return 'Step 1 dari 4: Evaluasi kebersihan, penumpukan sampah & pengolahan limbah.';
      case 1:
        return 'Step 2 dari 4: Identifikasi situasi ketertiban & potensi ancaman keamanan.';
      case 2:
        return 'Step 3 dari 4: Pemantauan kondisi fasilitas umum, saluran air & lingkungan sekitar.';
      case 3:
      default:
        return 'Step 4 dari 4: Catatan temuan khusus & pengiriman laporan harian.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Banner Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStepIcon(currentStep),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Form Laporan Harian (${currentStep + 1}/${RondaConstants.totalSteps})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStepDescription(currentStep),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Stepper Linear Indicator
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (currentStep + 1) / RondaConstants.totalSteps,
            minHeight: 6,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 12),

        // Stepper Steps Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(RondaConstants.totalSteps, (index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : (isCompleted
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.white),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : (isCompleted
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : AppColors.grey300),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? Colors.white
                            : (isCompleted
                                  ? AppColors.primary
                                  : AppColors.grey500),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      RondaConstants.stepTitles[index],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : (isCompleted
                                  ? AppColors.primary
                                  : AppColors.grey600),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
