import 'dart:async';

import 'package:akar/core/services/gps_calibration_helper.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

typedef AddressResolver = Future<String?> Function(
  double latitude,
  double longitude,
);

/// Bottom sheet interaktif untuk mengunci ulang sinyal satelit GPS dan mengirim posisi akurat.
class GpsCalibrationSheet extends StatefulWidget {
  final Stream<GpsCalibrationProgress> Function()? calibrationStreamFactory;
  final Future<bool> Function()? openLocationSettings;
  final Future<bool> Function()? openAppSettings;
  final AddressResolver? addressResolver;

  const GpsCalibrationSheet({
    super.key,
    this.calibrationStreamFactory,
    this.openLocationSettings,
    this.openAppSettings,
    this.addressResolver,
  });

  static Future<void> show(
    BuildContext context, {
    Stream<GpsCalibrationProgress> Function()? calibrationStreamFactory,
    AddressResolver? addressResolver,
  }) {
    final colors = context.appColors;
    TrackingBloc? trackingBloc;
    try {
      trackingBloc = context.read<TrackingBloc>();
    } catch (_) {}

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final sheet = GpsCalibrationSheet(
          calibrationStreamFactory: calibrationStreamFactory,
          addressResolver: addressResolver,
        );
        if (trackingBloc != null) {
          return BlocProvider<TrackingBloc>.value(
            value: trackingBloc,
            child: sheet,
          );
        }
        return sheet;
      },
    );
  }

  @override
  State<GpsCalibrationSheet> createState() => _GpsCalibrationSheetState();
}

class _GpsCalibrationSheetState extends State<GpsCalibrationSheet> {
  StreamSubscription<GpsCalibrationProgress>? _subscription;
  bool _isCalibrating = false;
  GpsCalibrationProgress? _progress;
  String? _lastAddress;
  bool _isResolvingLastAddress = false;
  String? _resolvedLastKey;
  String? _calibratedAddress;
  bool _isResolvingCalibratedAddress = false;
  String? _resolvedCalibratedKey;

  TrackingBloc? _maybeTrackingBloc(BuildContext context) {
    try {
      return context.read<TrackingBloc>();
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _defaultResolveAddress(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await Geocoding()
          .placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 5));
      if (placemarks.isEmpty) return null;
      final place = placemarks.first;

      final parts = <String>[];
      final rawStreet = (place.street ?? '').trim();
      final isPlusCodeOrCoords =
          rawStreet.contains('+') ||
          RegExp(r'-?\d+\.\d{3,}').hasMatch(rawStreet);
      if (rawStreet.isNotEmpty && !isPlusCodeOrCoords) {
        parts.add(rawStreet);
      } else if ((place.thoroughfare ?? '').trim().isNotEmpty) {
        parts.add(place.thoroughfare!.trim());
      }

      for (final candidate in [
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
      ]) {
        final trimmed = (candidate ?? '').trim();
        if (trimmed.isNotEmpty && !parts.contains(trimmed)) {
          parts.add(trimmed);
        }
      }
      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  String _coordKey(double lat, double lng) =>
      '${lat.toStringAsFixed(5)},${lng.toStringAsFixed(5)}';

  void _ensureLastAddressResolved(double? lat, double? lng) {
    if (lat == null || lng == null) return;
    final key = _coordKey(lat, lng);
    if (_resolvedLastKey == key) return;
    _resolvedLastKey = key;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _isResolvingLastAddress = true);
      final resolver = widget.addressResolver ?? _defaultResolveAddress;
      final resolved = await resolver(lat, lng);
      if (!mounted || _resolvedLastKey != key) return;
      setState(() {
        _lastAddress = resolved;
        _isResolvingLastAddress = false;
      });
    });
  }

  Future<void> _resolveCalibratedAddress(double lat, double lng) async {
    final key = _coordKey(lat, lng);
    if (_resolvedCalibratedKey == key) return;
    _resolvedCalibratedKey = key;

    if (mounted) {
      setState(() => _isResolvingCalibratedAddress = true);
    }
    final resolver = widget.addressResolver ?? _defaultResolveAddress;
    final resolved = await resolver(lat, lng);
    if (!mounted || _resolvedCalibratedKey != key) return;
    setState(() {
      _calibratedAddress = resolved;
      _isResolvingCalibratedAddress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeTrackingBloc(context)?.add(SyncTrackingStatusEvent());
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _startCalibration() {
    _subscription?.cancel();
    setState(() {
      _isCalibrating = true;
      _calibratedAddress = null;
      _resolvedCalibratedKey = null;
      _isResolvingCalibratedAddress = false;
      _progress = const GpsCalibrationProgress(
        statusMessage: 'Memeriksa layanan GPS dan mengunci satelit...',
      );
    });

    final stream =
        (widget.calibrationStreamFactory ??
        GpsCalibrationHelper.calibrateStream)();

    _subscription = stream.listen(
      (update) {
        if (!mounted) return;
        setState(() {
          _progress = update;
          if (update.isDone) {
            _isCalibrating = false;
          }
        });

        if (update.isDone && update.isSuccess && update.bestPosition != null) {
          final pos = update.bestPosition!;
          _resolveCalibratedAddress(pos.latitude, pos.longitude);
          _maybeTrackingBloc(context)?.add(
            ApplyCalibratedLocationEvent(
              latitude: pos.latitude,
              longitude: pos.longitude,
              accuracyMeters: pos.accuracy,
            ),
          );
        }
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _isCalibrating = false;
          _progress = GpsCalibrationProgress(
            statusMessage: GpsAnomalyReason.timeout.userMessage,
            anomalyReason: GpsAnomalyReason.timeout,
            isDone: true,
          );
        });
      },
      onDone: () {
        if (!mounted || !_isCalibrating) return;
        setState(() => _isCalibrating = false);
      },
    );
  }

  void _cancelCalibration() {
    _subscription?.cancel();
    _subscription = null;
    setState(() {
      _isCalibrating = false;
      _progress = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _maybeTrackingBloc(context);
    if (bloc != null) {
      return BlocBuilder<TrackingBloc, TrackingState>(
        bloc: bloc,
        builder: (context, trackingState) =>
            _buildSheetContent(context, trackingState),
      );
    }
    return _buildSheetContent(context, null);
  }

  Widget _buildSheetContent(BuildContext context, TrackingState? tracking) {
    final colors = context.appColors;
    final progress = _progress;
    final hasAnomaly = tracking?.hasGpsAnomaly ?? false;
    final anomalyReason = GpsAnomalyReason.fromCode(tracking?.lastAnomalyCode);

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.my_location_rounded,
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
                            'Kalibrasi GPS',
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kunci ulang sinyal satelit agar posisi tidak meleset ke luar wilayah.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (hasAnomaly && !_isCalibrating && progress == null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.warningLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.warningBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: colors.warningDark,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            tracking?.lastMessage ?? anomalyReason.userMessage,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.warningDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                _buildLastPositionCard(context, tracking),
                if (progress != null) ...[
                  const SizedBox(height: 14),
                  _buildProgressCard(context, progress),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.infoLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: colors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tips: nonaktifkan VPN dan pindah dekat jendela atau area terbuka sebelum memulai kalibrasi.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (_isCalibrating)
                  OutlinedButton(
                    onPressed: _cancelCalibration,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.borderStrong),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Batalkan Kalibrasi'),
                  )
                else ...[
                  ElevatedButton.icon(
                    onPressed: _startCalibration,
                    icon: const Icon(Icons.gps_fixed_rounded, size: 18),
                    label: Text(
                      progress == null
                          ? 'Mulai Kalibrasi GPS'
                          : (progress.isSuccess
                                ? 'Kalibrasi Ulang'
                                : 'Coba Kalibrasi Ulang'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.borderStrong),
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Tutup'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLastPositionCard(BuildContext context, TrackingState? tracking) {
    final colors = context.appColors;
    final hasCoord =
        tracking?.lastLatitude != null && tracking?.lastLongitude != null;
    if (hasCoord) {
      _ensureLastAddressResolved(
        tracking!.lastLatitude,
        tracking.lastLongitude,
      );
    }

    final String locationText;
    if (!hasCoord) {
      locationText = 'Belum ada posisi terverifikasi';
    } else if (_isResolvingLastAddress) {
      locationText = 'Memuat alamat posisi...';
    } else if (_lastAddress != null && _lastAddress!.trim().isNotEmpty) {
      locationText = _lastAddress!;
    } else {
      locationText = 'Alamat belum dapat dimuat (periksa koneksi internet)';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posisi Terakhir Tercatat',
            style: AppTextStyles.labelMedium.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            locationText,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          if (tracking?.lastAccuracyMeters != null) ...[
            const SizedBox(height: 4),
            Text(
              'Akurasi terakhir: ±${tracking!.lastAccuracyMeters!.round()} m',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          if (tracking?.lastSentTime != null) ...[
            const SizedBox(height: 2),
            Text(
              'Diperbarui: ${DateFormat('dd MMM yyyy, HH:mm').format(tracking!.lastSentTime!)} WIB',
              style: AppTextStyles.bodySmall.copyWith(color: colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    GpsCalibrationProgress progress,
  ) {
    final colors = context.appColors;
    final bool isSuccess = progress.isDone && progress.isSuccess;
    final bool isFailure = progress.isDone && !progress.isSuccess;

    final Color bgColor = isSuccess
        ? colors.successLight
        : (isFailure ? colors.errorLight : colors.primaryLight);
    final Color borderColor = isSuccess
        ? colors.success.withValues(alpha: 0.35)
        : (isFailure
              ? colors.errorBorder
              : colors.primary.withValues(alpha: 0.25));
    final Color fgColor = isSuccess
        ? colors.success
        : (isFailure ? colors.errorDark : colors.primaryDark);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!progress.isDone)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: colors.primary,
                  ),
                )
              else
                Icon(
                  isSuccess
                      ? Icons.check_circle_rounded
                      : Icons.error_outline_rounded,
                  size: 20,
                  color: fgColor,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  progress.statusMessage,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: fgColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (progress.bestPosition != null) ...[
            if (progress.isDone) ...[
              const SizedBox(height: 8),
              Text(
                _isResolvingCalibratedAddress
                    ? 'Alamat: Memuat alamat lokasi...'
                    : (_calibratedAddress != null &&
                              _calibratedAddress!.trim().isNotEmpty
                          ? 'Alamat: $_calibratedAddress'
                          : 'Alamat: Alamat belum dapat dimuat (periksa koneksi internet)'),
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Sumber: ${progress.usedHardwareGps ? 'GPS Satelit Perangkat' : 'Lokasi Gabungan'} • Sampel: ${progress.samplesCollected}',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          if (progress.isReducedAccuracy) ...[
            const SizedBox(height: 10),
            Text(
              'Perangkat memakai Lokasi Perkiraan. Aktifkan "Gunakan lokasi presisi" di Pengaturan Aplikasi.',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.warningDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (isFailure &&
              (progress.anomalyReason == GpsAnomalyReason.serviceDisabled ||
                  progress.anomalyReason == GpsAnomalyReason.permissionDenied ||
                  progress.anomalyReason ==
                      GpsAnomalyReason.reducedAccuracy)) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                if (progress.anomalyReason ==
                    GpsAnomalyReason.serviceDisabled) {
                  (widget.openLocationSettings ??
                      Geolocator.openLocationSettings)();
                } else {
                  (widget.openAppSettings ?? Geolocator.openAppSettings)();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: fgColor,
                side: BorderSide(color: borderColor),
                minimumSize: const Size(double.infinity, 44),
              ),
              child: Text(
                progress.anomalyReason == GpsAnomalyReason.serviceDisabled
                    ? 'Buka Pengaturan Lokasi'
                    : 'Buka Pengaturan Aplikasi',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
