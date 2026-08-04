import 'package:akar/features/analisis/presentation/provider/analisis_provider.dart';
import 'package:akar/features/analisis/presentation/widgets/analisis_metric_cards.dart';
import 'package:akar/features/analisis/presentation/widgets/category_distribution_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalisisScreen extends StatelessWidget {
  const AnalisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalisisProvider(),
      child: Consumer<AnalisisProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: SingleChildScrollView(
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
                  const SizedBox(height: 20),

                  // UpcomingDeadlineActivitiesCard(
                  //   items: provider.upcomingDeadlines,
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
