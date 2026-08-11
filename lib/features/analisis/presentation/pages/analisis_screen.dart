import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:akar/features/analisis/presentation/provider/analisis_provider.dart';
import 'package:akar/features/analisis/presentation/widgets/analisis_metric_cards.dart';
import 'package:akar/features/analisis/presentation/widgets/category_distribution_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalisisScreen extends StatelessWidget {
  const AnalisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivationProvider>(
      builder: (context, activationProvider, child) {
        final activities = activationProvider.activities;

        return ChangeNotifierProvider(
          create: (_) => AnalisisProvider(activities: activities),
          builder: (context, child) {
            final provider = context.watch<AnalisisProvider>();
            provider.updateActivities(activities);

            return Scaffold(
              backgroundColor: AppColors.background,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.15],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnalisisSummaryChartCard(
                        totalTasks: provider.totalTasks,
                        totalAgendas: provider.totalAgendas,
                        totalReports: provider.totalReports,
                      ),
                      const SizedBox(height: 20),

                      CategoryDistributionChartCard(
                        categoryData: provider.categoryDistribution,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
