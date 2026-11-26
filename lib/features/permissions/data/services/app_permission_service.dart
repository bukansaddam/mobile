import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Single source of truth for role-based permission steps and cached OS statuses.
class AppPermissionService extends ChangeNotifier {
  final PermissionGateway _gateway;
  final bool _isIos;
  final Map<AppPermissionType, PermissionStepStatus> _statuses = {};
  final Set<AppPermissionType> _attemptedTypes = {};
  bool _hasRefreshed = false;

  AppPermissionService({required this._gateway, bool? isIosOverride})
    : _isIos =
          isIosOverride ??
          (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS);

  List<PermissionStepSpec> stepsForRole({required bool isOfficer}) {
    return PermissionStepCatalog.stepsForRole(isOfficer: isOfficer);
  }

  Map<AppPermissionType, PermissionStepStatus> get cachedStatuses {
    return Map<AppPermissionType, PermissionStepStatus>.unmodifiable(_statuses);
  }

  bool hasAllRequiredPermissionsSync({required bool isOfficer}) {
    if (!_hasRefreshed) return false;

    final requiredSteps = stepsForRole(isOfficer: isOfficer);
    return requiredSteps.every(
      (step) => _statuses[step.type]?.isGranted == true,
    );
  }

  /// Membaca status izin OS secara langsung tanpa mengubah cache atau memicu notifyListeners(),
  /// agar pengecekan di layar Profil tidak menyebabkan GoRouter mengalihkan user ke /permission-setup.
  Future<Map<AppPermissionType, PermissionStepStatus>> inspectLiveStatuses({
    required bool isOfficer,
  }) async {
    final steps = stepsForRole(isOfficer: isOfficer);
    final live = <AppPermissionType, PermissionStepStatus>{};
    for (final step in steps) {
      live[step.type] = await _checkNormalizedStatus(
        step.type,
        knownStatuses: live,
      );
    }
    return Map<AppPermissionType, PermissionStepStatus>.unmodifiable(live);
  }

  Future<Map<AppPermissionType, PermissionStepStatus>> refreshStatuses({
    required bool isOfficer,
  }) async {
    final steps = stepsForRole(isOfficer: isOfficer);
    final updated = <AppPermissionType, PermissionStepStatus>{};
    for (final step in steps) {
      updated[step.type] = await _checkNormalizedStatus(
        step.type,
        knownStatuses: updated,
      );
    }
    _statuses
      ..clear()
      ..addAll(updated);
    _hasRefreshed = true;
    notifyListeners();
    return cachedStatuses;
  }

  Future<PermissionStepStatus> requestPermission(
    AppPermissionType type, {
    required bool isOfficer,
    bool notify = true,
  }) async {
    // Enforce Android 11+ and iOS 2-step background location prerequisite.
    if (type == AppPermissionType.locationAlways) {
      final cachedWhenInUse = notify
          ? _statuses[AppPermissionType.locationWhenInUse]
          : null;
      if (cachedWhenInUse != PermissionStepStatus.granted) {
        final whenInUseStatus = await _checkNormalizedStatus(
          AppPermissionType.locationWhenInUse,
        );
        if (notify) {
          _statuses[AppPermissionType.locationWhenInUse] = whenInUseStatus;
        }
        if (!whenInUseStatus.isGranted) {
          if (notify) {
            _statuses[AppPermissionType.locationAlways] =
                PermissionStepStatus.denied;
            notifyListeners();
          }
          return PermissionStepStatus.denied;
        }
      }
    }

    final resolvedStatus = await _executeRequest(type);
    if (notify) {
      _statuses[type] = resolvedStatus;
      notifyListeners();
    }
    return resolvedStatus;
  }

  Future<bool> openAppSettings() async {
    try {
      return await _gateway.openSettings();
    } catch (e, st) {
      AppLogger.w('Failed to open app settings', e, st);
      return false;
    }
  }

  void resetCache() {
    _statuses.clear();
    _attemptedTypes.clear();
    _hasRefreshed = false;
    notifyListeners();
  }

  Future<PermissionStepStatus> _checkNormalizedStatus(
    AppPermissionType type, {
    Map<AppPermissionType, PermissionStepStatus>? knownStatuses,
  }) async {
    try {
      final osStatus = await _gateway.checkStatus(type);
      return _normalizeCheckStatus(
        type,
        osStatus,
        knownStatuses: knownStatuses,
      );
    } catch (e, st) {
      AppLogger.w('Failed to check permission status for $type', e, st);
      return PermissionStepStatus.denied;
    }
  }

  // OS APIs report unprompted permissions as denied; _attemptedTypes separates
  // initial unprompted steps from prior denials or background-location settings hops.
  PermissionStepStatus _normalizeCheckStatus(
    AppPermissionType type,
    PermissionStepStatus osStatus, {
    Map<AppPermissionType, PermissionStepStatus>? knownStatuses,
  }) {
    final referenceStatuses = knownStatuses ?? _statuses;
    // On iOS, permission_handler reports locationAlways as permanentlyDenied
    // as soon as locationWhenInUse is granted, even before requesting Always.
    if (_isIos &&
        type == AppPermissionType.locationAlways &&
        osStatus == PermissionStepStatus.permanentlyDenied &&
        referenceStatuses[AppPermissionType.locationWhenInUse] ==
            PermissionStepStatus.granted) {
      return _attemptedTypes.contains(AppPermissionType.locationAlways)
          ? PermissionStepStatus.needsSettings
          : PermissionStepStatus.notRequested;
    }
    if (osStatus == PermissionStepStatus.granted ||
        osStatus == PermissionStepStatus.permanentlyDenied ||
        osStatus == PermissionStepStatus.needsSettings) {
      return osStatus;
    }
    if (_attemptedTypes.contains(type)) {
      return type == AppPermissionType.locationAlways
          ? PermissionStepStatus.needsSettings
          : PermissionStepStatus.denied;
    }
    return PermissionStepStatus.notRequested;
  }

  Future<PermissionStepStatus> _executeRequest(AppPermissionType type) async {
    try {
      final rawStatus = await _gateway.request(type);
      _attemptedTypes.add(type);
      if (type == AppPermissionType.locationAlways && !rawStatus.isGranted) {
        return PermissionStepStatus.needsSettings;
      }
      if (rawStatus == PermissionStepStatus.notRequested) {
        return PermissionStepStatus.denied;
      }
      return rawStatus;
    } catch (e, st) {
      AppLogger.w('Failed to request permission $type', e, st);
      return PermissionStepStatus.denied;
    }
  }
}
