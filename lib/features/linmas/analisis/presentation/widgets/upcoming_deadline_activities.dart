import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/linmas/analisis/presentation/bloc/analisis_bloc/analisis_bloc.dart';
import 'package:material_ui/material_ui.dart';

class UpcomingDeadlineActivitiesCard extends StatelessWidget {
  final List<ActivityDeadlineItem> items;

  const UpcomingDeadlineActivitiesCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.alarm_on_rounded,
                  color: colors.error,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Kegiatan Deadline Terdekat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kegiatan mendesak yang membutuhkan perhatian',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: colors.divider),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                Divider(height: 20, color: colors.divider),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildDeadlineTile(colors, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineTile(AppColorScheme colors, ActivityDeadlineItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          final catColor = _getCategoryColor(
                            item.category,
                            colors,
                          );
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: catColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: catColor,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.location,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: item.statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: item.statusColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    item.daysLeftText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: item.statusColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.deadlineText,
                    style: TextStyle(fontSize: 9, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: item.progress,
                  minHeight: 6,
                  backgroundColor: colors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(item.statusColor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${(item.progress * 100).toInt()}% Selesai',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCategoryColor(String category, AppColorScheme colors) {
    switch (category) {
      case 'Pemasangan APK':
        return colors.emerald;
      case 'Door to Door':
        return colors.indigo;
      case 'Keamanan & Sosial':
      case 'Keamanan':
      case 'Sosial':
        return colors.info;
      case 'Lingkungan':
        return colors.success;
      case 'Bencana Alam':
        return colors.error;
      default:
        return colors.primary;
    }
  }
}
