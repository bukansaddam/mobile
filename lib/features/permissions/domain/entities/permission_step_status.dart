/// Evaluated state of an OS permission step in the onboarding wizard.
enum PermissionStepStatus {
  notRequested,
  granted,
  denied,
  permanentlyDenied,
  needsSettings;

  bool get isGranted => this == PermissionStepStatus.granted;

  bool get requiresSettings =>
      this == PermissionStepStatus.permanentlyDenied ||
      this == PermissionStepStatus.needsSettings;
}
