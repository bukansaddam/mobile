import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/report_point_policy.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/core/widgets/report_point_banner_strip.dart';
import 'package:akar/features/masyarakat/complaint/presentation/models/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/complaint_detail_bloc/complaint_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintDetailPage extends StatefulWidget {
  final ComplaintItem item;
  final bool showPoints;

  const ComplaintDetailPage({
    super.key,
    required this.item,
    this.showPoints = false,
  });

  static Future<void> show(
    BuildContext context,
    ComplaintItem item, {
    bool showPoints = false,
  }) {
    return AppRouter.toComplaintDetail(context, item, showPoints: showPoints);
  }

  static Future<void> showAsBottomSheet(
    BuildContext context,
    ComplaintItem item, {
    bool showPoints = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final sheetColors = sheetContext.appColors;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.88,
          ),
          decoration: BoxDecoration(
            color: sheetColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 38,
                height: 4.5,
                decoration: BoxDecoration(
                  color: sheetColors.borderStrong,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Expanded(
                child: ComplaintDetailPage(item: item, showPoints: showPoints),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  State<ComplaintDetailPage> createState() => _ComplaintDetailPageState();
}

class _ComplaintDetailPageState extends State<ComplaintDetailPage> {
  ComplaintDetailBloc? _bloc;

  @override
  void initState() {
    super.initState();
    final reportId = widget.item.reportId;
    if (reportId != null && reportId.isNotEmpty) {
      _bloc = sl<ComplaintDetailBloc>()
        ..add(FetchComplaintDetailEvent(reportId));
    }
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  Map<String, String>? _apiAuthHeaders(String url) {
    final uri = Uri.tryParse(url);
    final base = Uri.tryParse(ApiConstants.baseUrl);
    if (uri == null || base == null || uri.host != base.host) return null;
    final auth = DioClient.instance.options.headers['Authorization'];
    return auth is String && auth.isNotEmpty ? {'Authorization': auth} : null;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _bloc;
    if (bloc == null) return _buildBody(context, widget.item);

    return BlocConsumer<ComplaintDetailBloc, ComplaintDetailState>(
      bloc: bloc,
      listenWhen: (previous, current) => current is ComplaintDetailFailure,
      listener: (context, state) {
        if (state is ComplaintDetailFailure) {
          AppToast.showWarning(context, message: state.message);
        }
      },
      builder: (context, state) {
        final item = state is ComplaintDetailLoaded
            ? ComplaintItem.fromReport(state.report)
            : widget.item;
        return _buildBody(context, item);
      },
    );
  }

  Future<void> _refresh() async {
    final bloc = _bloc;
    final reportId = widget.item.reportId;
    if (bloc == null || reportId == null) return;

    bloc.add(FetchComplaintDetailEvent(reportId));
    await bloc.stream.firstWhere(
      (state) =>
          state is ComplaintDetailLoaded || state is ComplaintDetailFailure,
    );
  }

  Widget _buildBody(BuildContext context, ComplaintItem item) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppPageBar(title: 'Detail Pengaduan'),
      body: RefreshIndicator(
        color: colors.primary,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.primary.withAlpha(50),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.primary.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.status.icon,
                            color: colors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status Pengaduan',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.statusLabel.isNotEmpty
                                    ? item.statusLabel
                                    : item.status.label,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.showPoints)
                      ReportPointBannerStrip(
                        info: ReportPointPolicy.resolve(
                          category: ReportPointCategory.laporanInsidentil,
                          statusCode: item.statusCode,
                          fallbackStatus: item.status,
                          apiPoints: item.pointsAwarded,
                          timelineTypes: item.timelineTypes,
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
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colors.border,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tag_rounded,
                                  size: 14,
                                  color: colors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.id,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textSecondary,
                                    ),
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
                              color: colors.successLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  ComplaintCategory.getIconFor(item.category),
                                  size: 14,
                                  color: colors.success,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.category,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.formattedDateTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Divider(height: 1, color: colors.divider),
                    const SizedBox(height: 14),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 20,
                          color: colors.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lokasi Kejadian',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textHint,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.location,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Divider(height: 1, color: colors.divider),
                    const SizedBox(height: 14),

                    Text(
                      'Deskripsi Pengaduan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: colors.textSecondary,
                        height: 1.45,
                      ),
                    ),

                    if (item.attachments.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Divider(height: 1, color: colors.divider),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lampiran Foto / Video',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            '${item.attachments.length} media',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textHint,
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
                            final isVideo = item.isVideoAttachment(imgPath);
                            return GestureDetector(
                              onTap: () {
                                if (isVideo) {
                                  FullscreenVideoViewer.show(
                                    context,
                                    pathOrUrl: imgPath,
                                    title: 'Video Pengaduan',
                                    httpHeaders: _apiAuthHeaders(imgPath),
                                  );
                                  return;
                                }
                                final photos = item.attachments
                                    .where(
                                      (attachment) =>
                                          !item.isVideoAttachment(attachment),
                                    )
                                    .toList();
                                FullscreenImageViewer.show(
                                  context,
                                  imagePathOrUrl: imgPath,
                                  images: photos,
                                  initialIndex: photos.indexOf(imgPath),
                                  httpHeaders: _apiAuthHeaders(imgPath),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: colors.border,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      if (isVideo)
                                        Container(
                                          color: Colors.black, // media-overlay
                                          child: const Icon(
                                            Icons.play_circle_fill_rounded,
                                            color:
                                                Colors.white, // media-overlay
                                            size: 32,
                                          ),
                                        )
                                      else if (imgPath.startsWith('http://') ||
                                          imgPath.startsWith('https://'))
                                        AppNetworkImage(
                                          imageUrl: imgPath,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          httpHeaders: _apiAuthHeaders(imgPath),
                                          errorIcon: Icons.broken_image_rounded,
                                        )
                                      else if (File(imgPath).existsSync())
                                        Image.file(
                                          File(imgPath),
                                          fit: BoxFit.cover,
                                          cacheWidth: 300,
                                          cacheHeight: 300,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.broken_image_rounded,
                                                    color: colors.textMuted,
                                                  ),
                                        )
                                      else
                                        Image.asset(
                                          imgPath,
                                          fit: BoxFit.cover,
                                          cacheWidth: 300,
                                          cacheHeight: 300,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.broken_image_rounded,
                                                    color: colors.textMuted,
                                                  ),
                                        ),
                                      Positioned(
                                        right: 6,
                                        bottom: 6,
                                        child: Builder(
                                          builder: (context) {
                                            const badgeBg =
                                                Colors.black; // media-overlay
                                            const badgeFg =
                                                Colors.white; // media-overlay
                                            return Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: badgeBg.withAlpha(140),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.fullscreen_rounded,
                                                color: badgeFg,
                                                size: 16,
                                              ),
                                            );
                                          },
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
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perkembangan Status Pengaduan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildStatusProgressStepper(item.status, colors),

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
                                              ? colors.textPrimary
                                              : colors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        history.timeString,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: colors.textHint,
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
                                              ? colors.primary
                                              : colors.borderStrong,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: colors.surface,
                                            width: 2.5,
                                          ),
                                          boxShadow: isLatest
                                              ? [
                                                  BoxShadow(
                                                    color: colors.primary
                                                        .withAlpha(100),
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
                                          color: colors.divider,
                                        ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 20.0,
                                    ),
                                    child: Text(
                                      (history.note != null &&
                                              history.note!.isNotEmpty)
                                          ? history.note!
                                          : history.status.label,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isLatest
                                            ? colors.textPrimary
                                            : colors.textSecondary,
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
      ),
    );
  }

  Widget _buildStatusProgressStepper(
    ComplaintStatus status,
    AppColorScheme colors,
  ) {
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
    if (status == ComplaintStatus.verified || activeStep > 1) {
      verifikasiText = 'Diverifikasi';
    } else if (status == ComplaintStatus.rejected) {
      verifikasiText = 'Ditolak';
    } else if (status == ComplaintStatus.cancelled) {
      verifikasiText = 'Dibatalkan';
    }

    final steps = ['Diterima', verifikasiText, 'Diproses', 'Selesai'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primary.withAlpha(40)),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(4, (index) {
              final isCompleted = index < activeStep;
              final isCurrent = index == activeStep;

              Color circleColor;
              Color iconColor;
              IconData stepIcon;

              if (isCompleted) {
                circleColor = colors.primary;
                iconColor = colors.onPrimary;
                stepIcon = Icons.check_rounded;
              } else if (isCurrent) {
                if (isCancelledOrRejected) {
                  circleColor = colors.errorSolid;
                  iconColor = colors.onErrorSolid;
                  stepIcon = Icons.close_rounded;
                } else {
                  circleColor = colors.primary;
                  iconColor = colors.onPrimary;
                  stepIcon = status.icon;
                }
              } else {
                circleColor = colors.borderStrong;
                iconColor = colors.textSecondary;
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
                      child: index == 0
                          ? const SizedBox.shrink()
                          : Container(
                              height: 2,
                              margin: const EdgeInsets.only(right: 6),
                              color: index <= activeStep
                                  ? colors.primary
                                  : colors.borderStrong,
                            ),
                    ),
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
                    Expanded(
                      child: index == 3
                          ? const SizedBox.shrink()
                          : Container(
                              height: 2,
                              margin: const EdgeInsets.only(left: 6),
                              color: index < activeStep
                                  ? colors.primary
                                  : colors.borderStrong,
                            ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (index) {
              final isCompleted = index < activeStep;
              final isCurrent = index == activeStep;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        steps[index],
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          letterSpacing: 0,
                          fontWeight: (isCurrent || isCompleted)
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: (isCurrent || isCompleted)
                              ? colors.textPrimary
                              : colors.textSecondary,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
