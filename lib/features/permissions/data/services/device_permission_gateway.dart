import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Platform-backed [PermissionGateway] using `permission_handler` and [FirebaseNotificationService].
class DevicePermissionGateway implements PermissionGateway {
  final FirebaseNotificationService _notificationService;
  final Future<PermissionStatus> Function(Permission permission)
      _checkPlatformPermission;
  final Future<PermissionStatus> Function(Permission permission)
      _requestPlatformPermission;
  final Future<bool> Function() _openPlatformSettings;
  final Future<bool> Function(Permission permission) _shouldShowRationale;
  final bool _isAndroid;

  DevicePermissionGateway({
    required this._notificationService,
    Future<PermissionStatus> Function(Permission permission)?
        checkPlatformPermission,
    Future<PermissionStatus> Function(Permission permission)?
        requestPlatformPermission,
    Future<bool> Function()? openPlatformSettings,
    Future<bool> Function(Permission permission)? shouldShowRationale,
    bool? isAndroidOverride,
  }) : _checkPlatformPermission =
           checkPlatformPermission ?? ((permission) => permission.status),
       _requestPlatformPermission =
           requestPlatformPermission ?? ((permission) => permission.request()),
       _openPlatformSettings = openPlatformSettings ?? openAppSettings,
       _shouldShowRationale =
           shouldShowRationale ??
           ((permission) => permission.shouldShowRequestRationale),
       _isAndroid =
           isAndroidOverride ??
           (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);

  @override
  Future<PermissionStepStatus> checkStatus(AppPermissionType type) async {
    final status = await _checkPlatformPermission(_toPlatformPermission(type));
    return _mapStatus(status, isRequest: false);
  }

  @override
  Future<PermissionStepStatus> request(AppPermissionType type) async {
    if (type == AppPermissionType.notification) {
      if (_isAndroid) {
        return _requestAndroidNotification();
      }
      final authorized =
          await _notificationService.requestNotificationPermission();
      final osStatus = await _checkPlatformPermission(Permission.notification);
      if (_isPermanentlyDenied(osStatus)) {
        return PermissionStepStatus.permanentlyDenied;
      }
      if (authorized || _isGranted(osStatus)) {
        return PermissionStepStatus.granted;
      }
      return PermissionStepStatus.denied;
    }

    final status = await _requestPlatformPermission(
      _toPlatformPermission(type),
    );
    return _mapStatus(status, isRequest: true);
  }

  Future<PermissionStepStatus> _requestAndroidNotification() async {
    final status = await _requestPlatformPermission(Permission.notification);
    if (status.isGranted || status.isLimited || status.isProvisional) {
      await _notificationService.ensureTokenCached();
      return PermissionStepStatus.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return PermissionStepStatus.permanentlyDenied;
    }
    if (status.isDenied) {
      final canAskAgain = await _safeShouldShowRationale(
        Permission.notification,
      );
      return canAskAgain
          ? PermissionStepStatus.denied
          : PermissionStepStatus.needsSettings;
    }
    return PermissionStepStatus.denied;
  }

  Future<bool> _safeShouldShowRationale(Permission permission) async {
    try {
      return await _shouldShowRationale(permission);
    } catch (_) {
      return true;
    }
  }

  @override
  Future<bool> openSettings() {
    return _openPlatformSettings();
  }

  Permission _toPlatformPermission(AppPermissionType type) {
    switch (type) {
      case AppPermissionType.locationWhenInUse:
        return Permission.locationWhenInUse;
      case AppPermissionType.locationAlways:
        return Permission.locationAlways;
      case AppPermissionType.camera:
        return Permission.camera;
      case AppPermissionType.microphone:
        return Permission.microphone;
      case AppPermissionType.notification:
        return Permission.notification;
    }
  }

  PermissionStepStatus _mapStatus(
    PermissionStatus status, {
    required bool isRequest,
  }) {
    if (_isGranted(status)) {
      return PermissionStepStatus.granted;
    }
    if (_isPermanentlyDenied(status)) {
      return PermissionStepStatus.permanentlyDenied;
    }
    return isRequest
        ? PermissionStepStatus.denied
        : PermissionStepStatus.notRequested;
  }

  bool _isGranted(PermissionStatus status) {
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited ||
        status == PermissionStatus.provisional;
  }

  bool _isPermanentlyDenied(PermissionStatus status) {
    return status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.restricted;
  }
}
