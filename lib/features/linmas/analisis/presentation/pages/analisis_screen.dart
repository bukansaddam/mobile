import 'package:akar/features/linmas/analisis/presentation/widgets/bank_sampah_analisis_card.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/analisis/presentation/bloc/analisis_bloc/analisis_bloc.dart';
import 'package:akar/features/linmas/analisis/presentation/widgets/analisis_metric_cards.dart';
import 'package:akar/features/linmas/analisis/presentation/widgets/category_distribution_chart.dart';

class AnalisisScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const AnalisisScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivationBloc, ActivationState>(
      listener: (context, activationState) {
        context.read<AnalisisBloc>().add(
          UpdateAnalisisActivitiesEvent(activationState.activities),
        );
      },
      builder: (context, activationState) {
        return BlocBuilder<AnalisisBloc, AnalisisState>(
          builder: (context, analisisState) {
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
                        totalTasks: analisisState.totalTasks,
                        totalAgendas: analisisState.totalAgendas,
                        totalReports: analisisState.totalReports,
                        onStatusCardTap: (status) {
                          context.read<ActivationBloc>().add(
                            SetActivationStatusFilterEvent(status),
                          );
                          onNavigateToTab?.call(2);
                        },
                      ),
                      const SizedBox(height: 20),

                      CategoryDistributionChartCard(
                        categoryData: analisisState.categoryDistribution,
                        onCategoryTap: (category) {
                          context.read<ActivationBloc>().add(
                            SetActivationCategoryFilterEvent(category),
                          );
                          onNavigateToTab?.call(2);
                        },
                      ),
                      const SizedBox(height: 20),

                      BlocBuilder<BankSampahBloc, BankSampahState>(
                        builder: (context, bankState) {
                          return BankSampahAnalisisCard(
                            reports: bankState.reports,
                          );
                        },
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
