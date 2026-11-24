import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Single source of truth for role-based permission steps and cached OS statuses.
class AppPermissionService extends ChangeNotifier {
  final PermissionGateway _gateway;
  final Map<AppPermissionType, PermissionStepStatus> _statuses = {};
  final Set<AppPermissionType> _attemptedTypes = {};
  bool _hasRefreshed = false;

  AppPermissionService({required this._gateway});

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

  Future<Map<AppPermissionType, PermissionStepStatus>> refreshStatuses({
    required bool isOfficer,
  }) async {
    final steps = stepsForRole(isOfficer: isOfficer);
    for (final step in steps) {
      _statuses[step.type] = await _checkNormalizedStatus(step.type);
    }
    _hasRefreshed = true;
    notifyListeners();
    return cachedStatuses;
  }

  Future<PermissionStepStatus> requestPermission(
    AppPermissionType type, {
    required bool isOfficer,
  }) async {
    // Enforce Android 11+ and iOS 2-step background location prerequisite.
    if (type == AppPermissionType.locationAlways &&
        _statuses[AppPermissionType.locationWhenInUse] !=
            PermissionStepStatus.granted) {
      final whenInUseStatus = await _checkNormalizedStatus(
        AppPermissionType.locationWhenInUse,
      );
      _statuses[AppPermissionType.locationWhenInUse] = whenInUseStatus;
      if (!whenInUseStatus.isGranted) {
        _statuses[AppPermissionType.locationAlways] =
            PermissionStepStatus.denied;
        notifyListeners();
        return PermissionStepStatus.denied;
      }
    }

    _attemptedTypes.add(type);
    final resolvedStatus = await _executeRequest(type);
    _statuses[type] = resolvedStatus;
    notifyListeners();
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
    AppPermissionType type,
  ) async {
    try {
      final osStatus = await _gateway.checkStatus(type);
      return _normalizeCheckStatus(type, osStatus);
    } catch (e, st) {
      AppLogger.w('Failed to check permission status for $type', e, st);
      return PermissionStepStatus.denied;
    }
  }

  // OS APIs report unprompted permissions as denied; _attemptedTypes separates
  // initial unprompted steps from prior denials or background-location settings hops.
  PermissionStepStatus _normalizeCheckStatus(
    AppPermissionType type,
    PermissionStepStatus osStatus,
  ) {
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
