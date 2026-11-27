import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/utils/report_point_policy.dart';
import 'package:akar/core/widgets/report_point_badge.dart';
import 'package:material_ui/material_ui.dart';

/// Ringkasan perolehan poin petugas Linmas per jenis laporan terverifikasi.
class OfficerPointsBreakdownCard extends StatelessWidget {
  const OfficerPointsBreakdownCard({super.key});

  static const _jagaTanahInfo = ReportPointInfo(
    category: ReportPointCategory.jagaTanah,
    state: ReportPointState.earned,
    points: 10,
  );

  static const _insidentilInfo = ReportPointInfo(
    category: ReportPointCategory.laporanInsidentil,
    state: ReportPointState.earned,
    points: 1,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Laporan Jaga Tanah',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const ReportPointBadge(info: _jagaTanahInfo),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Didapat setelah laporan diverifikasi',
            style: TextStyle(fontSize: 11.5, color: colors.textMuted),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: colors.divider),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Laporan Insidentil',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const ReportPointBadge(info: _insidentilInfo),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Didapat setelah laporan diverifikasi',
            style: TextStyle(fontSize: 11.5, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
