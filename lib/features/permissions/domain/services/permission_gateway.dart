import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';

/// Platform abstraction for checking, requesting, and opening OS permission settings.
abstract class PermissionGateway {
  Future<PermissionStepStatus> checkStatus(AppPermissionType type);

  Future<PermissionStepStatus> request(AppPermissionType type);

  Future<bool> openSettings();
}
