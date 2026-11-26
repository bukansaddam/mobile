import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Bottom sheet daftar status izin aplikasi dan kesehatan GPS perangkat di layar Profil.
class ProfilePermissionsSheet extends StatefulWidget {
  final bool isOfficer;
  final AppPermissionService? permissionService;
  final Future<bool> Function()? isLocationServiceEnabled;
  final Future<LocationAccuracyStatus> Function()? getLocationAccuracy;
  final Future<bool> Function()? openLocationSettings;
  final bool? isAndroidOverride;

  const ProfilePermissionsSheet({
    super.key,
    required this.isOfficer,
    this.permissionService,
    this.isLocationServiceEnabled,
    this.getLocationAccuracy,
    this.openLocationSettings,
    this.isAndroidOverride,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isOfficer,
    AppPermissionService? permissionService,
  }) {
    final colors = context.appColors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ProfilePermissionsSheet(
        isOfficer: isOfficer,
        permissionService: permissionService,
      ),
    );
  }

  @override
  State<ProfilePermissionsSheet> createState() =>
      _ProfilePermissionsSheetState();
}

class _ProfilePermissionsSheetState extends State<ProfilePermissionsSheet>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  String? _errorMessage;
  Map<AppPermissionType, PermissionStepStatus> _statuses = {};
  bool _locationServiceEnabled = true;
  LocationAccuracyStatus? _locationAccuracy;
  AppPermissionType? _requestingType;

  AppPermissionService? get _service {
    if (widget.permissionService != null) return widget.permissionService;
    if (sl.isRegistered<AppPermissionService>()) {
      return sl<AppPermissionService>();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStatuses();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _loadStatuses(showSpinner: false);
    }
  }

  Future<void> _loadStatuses({bool showSpinner = true}) async {
    if (showSpinner && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final service = _service;
      final Map<AppPermissionType, PermissionStepStatus> statuses;
      if (service != null) {
        statuses = await service.inspectLiveStatuses(
          isOfficer: widget.isOfficer,
        );
      } else {
        statuses = {
          for (final step in PermissionStepCatalog.stepsForRole(
            isOfficer: widget.isOfficer,
          ))
            step.type: PermissionStepStatus.notRequested,
        };
      }

      bool serviceEnabled = true;
      try {
        serviceEnabled =
            await (widget.isLocationServiceEnabled ??
                Geolocator.isLocationServiceEnabled)();
      } catch (_) {}

      LocationAccuracyStatus? accuracy;
      try {
        accuracy =
            await (widget.getLocationAccuracy ??
                Geolocator.getLocationAccuracy)();
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _statuses = statuses;
        _locationServiceEnabled = serviceEnabled;
        _locationAccuracy = accuracy;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memeriksa status izin perangkat.';
      });
    }
  }

  Future<void> _handlePermissionAction(
    PermissionStepSpec spec,
    PermissionStepStatus status,
  ) async {
    final service = _service;
    if (service == null) {
      await Geolocator.openAppSettings();
      return;
    }

    if (status.requiresSettings) {
      await service.openAppSettings();
      return;
    }

    setState(() => _requestingType = spec.type);
    try {
      await service.requestPermission(
        spec.type,
        isOfficer: widget.isOfficer,
        notify: false,
      );
    } finally {
      if (mounted) {
        setState(() => _requestingType = null);
        await _loadStatuses(showSpinner: false);
      }
    }
  }

  Future<void> _handleUpgradePreciseLocation() async {
    final isAndroid =
        widget.isAndroidOverride ??
        (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);
    final service = _service;

    if (isAndroid && service != null) {
      await service.requestPermission(
        AppPermissionType.locationWhenInUse,
        isOfficer: widget.isOfficer,
        notify: false,
      );
      LocationAccuracyStatus? refreshedAccuracy;
      try {
        refreshedAccuracy =
            await (widget.getLocationAccuracy ??
                Geolocator.getLocationAccuracy)();
      } catch (_) {}

      if (refreshedAccuracy == LocationAccuracyStatus.precise) {
        await _loadStatuses(showSpinner: false);
        return;
      }
    }

    await _openAppSettings();
  }

  Future<void> _openAppSettings() async {
    final service = _service;
    if (service != null) {
      await service.openAppSettings();
    } else {
      await Geolocator.openAppSettings();
    }
  }

  Future<void> _openLocationSettings() async {
    await (widget.openLocationSettings ?? Geolocator.openLocationSettings)();
  }

  IconData _iconFor(AppPermissionType type) {
    switch (type) {
      case AppPermissionType.locationWhenInUse:
        return Icons.location_on_outlined;
      case AppPermissionType.locationAlways:
        return Icons.my_location_rounded;
      case AppPermissionType.camera:
        return Icons.camera_alt_outlined;
      case AppPermissionType.microphone:
        return Icons.mic_none_rounded;
      case AppPermissionType.notification:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final steps = PermissionStepCatalog.stepsForRole(
      isOfficer: widget.isOfficer,
    );
    final grantedCount = steps
        .where((step) => _statuses[step.type]?.isGranted == true)
        .length;
    final missingCount = steps.length - grantedCount;
    final hasReducedAccuracy =
        _locationAccuracy == LocationAccuracyStatus.reduced;
    final allHealthy =
        missingCount == 0 && _locationServiceEnabled && !hasReducedAccuracy;

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
                        Icons.verified_user_outlined,
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
                            'Izin Aplikasi',
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isLoading
                                ? 'Memeriksa status izin...'
                                : '$grantedCount dari ${steps.length} izin wajib aktif',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!_isLoading && _errorMessage == null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: allHealthy
                              ? colors.successLight
                              : colors.warningLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: allHealthy
                                ? colors.success.withValues(alpha: 0.35)
                                : colors.warningBorder,
                          ),
                        ),
                        child: Text(
                          allHealthy ? 'Lengkap' : 'Perlu Cek',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: allHealthy
                                ? colors.success
                                : colors.warningDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: colors.primary),
                        const SizedBox(height: 12),
                        Text(
                          'Memeriksa status izin perangkat...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.errorLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.errorBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _errorMessage!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.errorDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _loadStatuses,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.errorDark,
                            side: BorderSide(color: colors.errorBorder),
                            minimumSize: const Size(double.infinity, 44),
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    'Status GPS Perangkat',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: [
                        _buildDeviceRow(
                          context,
                          icon: _locationServiceEnabled
                              ? Icons.gps_fixed_rounded
                              : Icons.gps_off_rounded,
                          title: 'Layanan Lokasi (GPS)',
                          subtitle: _locationServiceEnabled
                              ? 'Aktif di perangkat'
                              : 'GPS nonaktif, aktifkan agar posisi terdeteksi',
                          isHealthy: _locationServiceEnabled,
                          statusLabel: _locationServiceEnabled
                              ? 'Aktif'
                              : 'Nonaktif',
                          actionLabel: _locationServiceEnabled
                              ? null
                              : 'Aktifkan',
                          onAction: _openLocationSettings,
                        ),
                        if (_locationAccuracy != null) ...[
                          Divider(height: 20, color: colors.border),
                          _buildDeviceRow(
                            context,
                            icon: hasReducedAccuracy
                                ? Icons.blur_on_rounded
                                : Icons.track_changes_rounded,
                            title: 'Akurasi Lokasi',
                            subtitle: hasReducedAccuracy
                                ? 'Mode Lokasi Perkiraan aktif. Ubah ke Lokasi Presisi di Pengaturan Aplikasi.'
                                : 'Lokasi Presisi aktif',
                            isHealthy: !hasReducedAccuracy,
                            statusLabel: hasReducedAccuracy
                                ? 'Perkiraan'
                                : 'Presisi',
                            actionLabel: hasReducedAccuracy ? 'Atur' : null,
                            onAction: _handleUpgradePreciseLocation,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Daftar Izin Wajib',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < steps.length; i++) ...[
                          _buildPermissionRow(
                            context,
                            steps[i],
                            _statuses[steps[i].type] ??
                                PermissionStepStatus.notRequested,
                          ),
                          if (i < steps.length - 1)
                            Divider(
                              height: 1,
                              indent: 14,
                              endIndent: 14,
                              color: colors.border,
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.textPrimary,
                    side: BorderSide(color: colors.borderStrong),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isHealthy,
    required String statusLabel,
    required String? actionLabel,
    required VoidCallback onAction,
  }) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: isHealthy ? colors.success : colors.warningDark,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (actionLabel != null)
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              elevation: 0,
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(actionLabel),
          )
        else
          _buildStatusPill(context, label: statusLabel, isHealthy: isHealthy),
      ],
    );
  }

  Widget _buildPermissionRow(
    BuildContext context,
    PermissionStepSpec spec,
    PermissionStepStatus status,
  ) {
    final colors = context.appColors;
    final isGranted = status.isGranted;
    final isBusy = _requestingType == spec.type;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isGranted ? colors.successLight : colors.warningLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _iconFor(spec.type),
              size: 18,
              color: isGranted ? colors.success : colors.warningDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spec.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isGranted
                      ? 'Diizinkan'
                      : (status.requiresSettings
                            ? 'Perlu diaktifkan di Pengaturan'
                            : 'Belum diatur'),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isGranted ? colors.success : colors.warningDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isGranted)
            _buildStatusPill(context, label: 'Aktif', isHealthy: true)
          else
            ElevatedButton(
              onPressed: isBusy
                  ? null
                  : () => _handlePermissionAction(spec, status),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                elevation: 0,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isBusy
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.onPrimary,
                      ),
                    )
                  : Text(status.requiresSettings ? 'Pengaturan' : 'Izinkan'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(
    BuildContext context, {
    required String label,
    required bool isHealthy,
  }) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isHealthy ? colors.successLight : colors.warningLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: isHealthy ? colors.success : colors.warningDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
