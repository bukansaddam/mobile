import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';

class ComplaintDetailPage extends StatelessWidget {
  final ComplaintItem item;

  const ComplaintDetailPage({super.key, required this.item});

  static Future<void> show(BuildContext context, ComplaintItem item) {
    return AppRouter.toComplaintDetail(context, item);
  }

  static Future<void> showAsBottomSheet(
    BuildContext context,
    ComplaintItem item,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 38,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Expanded(child: ComplaintDetailPage(item: item)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.topHeaderGradient),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF0F172A),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Detail Pengaduan',
              style: AppTextStyles.headlineMedium.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item.status.bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: item.status.textColor.withAlpha(50),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.status.textColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.status.icon,
                      color: item.status.textColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Pengaduan',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.status.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: item.status.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.tag_rounded,
                              size: 14,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.id,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              ComplaintCategory.getIconFor(item.category),
                              size: 14,
                              color: const Color(0xFF15803D),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF15803D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.formattedDateTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: Color(0xFFE11D48),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lokasi Kejadian',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.location,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 14),

                  const Text(
                    'Deskripsi Pengaduan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF334155),
                      height: 1.45,
                    ),
                  ),

                  if (item.attachments.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lampiran Foto',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${item.attachments.length} foto',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: item.attachments.length,
                        itemBuilder: (context, index) {
                          final imgPath = item.attachments[index];
                          return GestureDetector(
                            onTap: () {
                              FullscreenImageViewer.show(
                                context,
                                imagePathOrUrl: imgPath,
                                images: item.attachments,
                                initialIndex: index,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      imgPath,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.broken_image_rounded,
                                                color: Colors.black38,
                                              ),
                                    ),
                                    Positioned(
                                      right: 6,
                                      bottom: 6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withAlpha(140),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.fullscreen_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Perkembangan Status Pengaduan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildStatusProgressStepper(item.status),

                  Builder(
                    builder: (context) {
                      final reversedHistory = item.statusHistory.reversed
                          .toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reversedHistory.length,
                        itemBuilder: (context, index) {
                          final history = reversedHistory[index];
                          final isLast = index == reversedHistory.length - 1;
                          final isLatest = index == 0;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 85,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      history.dateString,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isLatest
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                        color: isLatest
                                            ? const Color(0xFF0F172A)
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      history.timeString,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: isLatest
                                            ? const Color(0xFF16A34A)
                                            : const Color(0xFFCBD5E1),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.5,
                                        ),
                                        boxShadow: isLatest
                                            ? [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF16A34A,
                                                  ).withAlpha(100),
                                                  blurRadius: 6,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 56,
                                        color: const Color(0xFFE2E8F0),
                                      ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    (history.note != null &&
                                            history.note!.isNotEmpty)
                                        ? history.note!
                                        : history.status.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isLatest
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFF475569),
                                      height: 1.4,
                                      fontWeight: isLatest
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusProgressStepper(ComplaintStatus status) {
    int activeStep = 0;
    bool isCancelledOrRejected = false;

    if (status == ComplaintStatus.received) {
      activeStep = 0;
    } else if (status == ComplaintStatus.pending ||
        status == ComplaintStatus.verified) {
      activeStep = 1;
    } else if (status == ComplaintStatus.inProgress) {
      activeStep = 2;
    } else if (status == ComplaintStatus.completed) {
      activeStep = 3;
    } else if (status == ComplaintStatus.rejected ||
        status == ComplaintStatus.cancelled) {
      activeStep = 1;
      isCancelledOrRejected = true;
    }

    String verifikasiText = 'Verifikasi';
    if (status == ComplaintStatus.pending) {
      verifikasiText = 'Menunggu\nVerifikasi';
    } else if (status == ComplaintStatus.verified || activeStep > 1) {
      verifikasiText = 'Diverifikasi';
    } else if (status == ComplaintStatus.rejected) {
      verifikasiText = 'Ditolak';
    } else if (status == ComplaintStatus.cancelled) {
      verifikasiText = 'Dibatalkan';
    }

    final steps = ['Laporan\nMasuk', verifikasiText, 'Diproses', 'Selesai'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: List.generate(4, (index) {
          final isCompleted = index < activeStep;
          final isCurrent = index == activeStep;

          Color circleColor;
          Color iconColor;
          IconData stepIcon;

          if (isCompleted) {
            circleColor = const Color(0xFF16A34A);
            iconColor = Colors.white;
            stepIcon = Icons.check_rounded;
          } else if (isCurrent) {
            if (isCancelledOrRejected) {
              circleColor = const Color(0xFFDC2626);
              iconColor = Colors.white;
              stepIcon = Icons.close_rounded;
            } else {
              circleColor = status.textColor;
              iconColor = Colors.white;
              stepIcon = status.icon;
            }
          } else {
            circleColor = const Color(0xFFE2E8F0);
            iconColor = const Color(0xFF94A3B8);
            stepIcon = index == 0
                ? Icons.inbox_rounded
                : index == 1
                ? Icons.verified_user_rounded
                : index == 2
                ? Icons.engineering_rounded
                : Icons.check_circle_rounded;
          }

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: circleColor.withAlpha(80),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(stepIcon, size: 15, color: iconColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        steps[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: (isCurrent || isCompleted)
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: (isCurrent || isCompleted)
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < 3)
                  Container(
                    width: 12,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: index < activeStep
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFE2E8F0),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
