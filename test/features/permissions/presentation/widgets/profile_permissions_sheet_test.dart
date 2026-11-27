import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:akar/features/permissions/presentation/widgets/profile_permissions_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

class _FakePermissionGateway implements PermissionGateway {
  final Map<AppPermissionType, PermissionStepStatus> statuses;
  int openSettingsCalls = 0;
  final List<AppPermissionType> requestedTypes = [];

  _FakePermissionGateway(this.statuses);

  @override
  Future<PermissionStepStatus> checkStatus(AppPermissionType type) async {
    return statuses[type] ?? PermissionStepStatus.denied;
  }

  @override
  Future<PermissionStepStatus> request(AppPermissionType type) async {
    requestedTypes.add(type);
    statuses[type] = PermissionStepStatus.granted;
    return PermissionStepStatus.granted;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCalls++;
    return true;
  }
}

void main() {
  test('inspectLiveStatuses tidak memicu notifyListeners agar GoRouter tidak redirect keluar dari Profil', () async {
    final gateway = _FakePermissionGateway({
      AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
      AppPermissionType.locationAlways: PermissionStepStatus.denied,
      AppPermissionType.camera: PermissionStepStatus.granted,
      AppPermissionType.microphone: PermissionStepStatus.granted,
      AppPermissionType.notification: PermissionStepStatus.granted,
    });
    final service = AppPermissionService(
      gateway: gateway,
      isIosOverride: false,
    );
    addTearDown(service.dispose);

    int notifications = 0;
    service.addListener(() => notifications++);

    final live = await service.inspectLiveStatuses(isOfficer: true);

    expect(notifications, 0);
    expect(
      live[AppPermissionType.locationWhenInUse],
      PermissionStepStatus.granted,
    );
    expect(
      live[AppPermissionType.locationAlways],
      PermissionStepStatus.notRequested,
    );
  });

  testWidgets(
    'ProfilePermissionsSheet menampilkan 5 izin Aslinmas dan peringatan Lokasi Perkiraan di Light & Dark Mode',
    (tester) async {
      final gateway = _FakePermissionGateway({
        AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
        AppPermissionType.locationAlways: PermissionStepStatus.needsSettings,
        AppPermissionType.camera: PermissionStepStatus.granted,
        AppPermissionType.microphone: PermissionStepStatus.denied,
        AppPermissionType.notification: PermissionStepStatus.granted,
      });
      final service = AppPermissionService(
        gateway: gateway,
        isIosOverride: false,
      );
      addTearDown(service.dispose);

      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        await tester.pumpWidget(
          MaterialApp(
            key: ValueKey(theme.brightness),
            theme: theme,
            home: Scaffold(
              body: ProfilePermissionsSheet(
                isOfficer: true,
                permissionService: service,
                isLocationServiceEnabled: () async => true,
                getLocationAccuracy: () async => LocationAccuracyStatus.reduced,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Izin Aplikasi'), findsOneWidget);
        expect(find.text('3 dari 5 izin wajib aktif'), findsOneWidget);
        expect(find.text('Perlu Cek'), findsOneWidget);
        expect(find.text('Lokasi Latar Belakang'), findsOneWidget);
        expect(find.text('Akses Mikrofon'), findsOneWidget);
        expect(
          find.textContaining('Mode Lokasi Perkiraan aktif'),
          findsOneWidget,
        );
      }
    },
  );

  testWidgets(
    'ProfilePermissionsSheet menampilkan 3 izin Masyarakat dan status Lengkap saat semua aktif',
    (tester) async {
      final gateway = _FakePermissionGateway({
        AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
        AppPermissionType.camera: PermissionStepStatus.granted,
        AppPermissionType.notification: PermissionStepStatus.granted,
      });
      final service = AppPermissionService(
        gateway: gateway,
        isIosOverride: false,
      );
      addTearDown(service.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfilePermissionsSheet(
              isOfficer: false,
              permissionService: service,
              isLocationServiceEnabled: () async => true,
              getLocationAccuracy: () async => LocationAccuracyStatus.precise,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3 dari 3 izin wajib aktif'), findsOneWidget);
      expect(find.text('Lengkap'), findsOneWidget);
      expect(find.text('Presisi'), findsOneWidget);
      expect(find.text('Lokasi Latar Belakang'), findsNothing);
      expect(find.text('Akses Mikrofon'), findsNothing);
    },
  );

  testWidgets(
    'tap Izinkan di Profil meminta izin langsung tanpa memicu notifyListeners (tanpa redirect GoRouter)',
    (tester) async {
      final gateway = _FakePermissionGateway({
        AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
        AppPermissionType.locationAlways: PermissionStepStatus.granted,
        AppPermissionType.camera: PermissionStepStatus.granted,
        AppPermissionType.microphone: PermissionStepStatus.denied,
        AppPermissionType.notification: PermissionStepStatus.granted,
      });
      final service = AppPermissionService(
        gateway: gateway,
        isIosOverride: false,
      );
      addTearDown(service.dispose);

      int notifications = 0;
      service.addListener(() => notifications++);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfilePermissionsSheet(
              isOfficer: true,
              permissionService: service,
              isLocationServiceEnabled: () async => true,
              getLocationAccuracy: () async => LocationAccuracyStatus.precise,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4 dari 5 izin wajib aktif'), findsOneWidget);
      await tester.ensureVisible(find.text('Izinkan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Izinkan'));
      await tester.pumpAndSettle();

      expect(gateway.requestedTypes, equals([AppPermissionType.microphone]));
      expect(notifications, 0);
      expect(find.text('5 dari 5 izin wajib aktif'), findsOneWidget);
      expect(find.text('Lengkap'), findsOneWidget);
    },
  );

  testWidgets(
    'tap Atur pada Lokasi Perkiraan di Android mencoba popup lokasi presisi dulu sebelum Pengaturan',
    (tester) async {
      final gateway = _FakePermissionGateway({
        AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
        AppPermissionType.camera: PermissionStepStatus.granted,
        AppPermissionType.notification: PermissionStepStatus.granted,
      });
      final service = AppPermissionService(
        gateway: gateway,
        isIosOverride: false,
      );
      addTearDown(service.dispose);

      LocationAccuracyStatus currentAccuracy = LocationAccuracyStatus.reduced;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfilePermissionsSheet(
              isOfficer: false,
              isAndroidOverride: true,
              permissionService: service,
              isLocationServiceEnabled: () async => true,
              getLocationAccuracy: () async {
                if (gateway.requestedTypes.contains(
                  AppPermissionType.locationWhenInUse,
                )) {
                  currentAccuracy = LocationAccuracyStatus.precise;
                }
                return currentAccuracy;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Atur'), findsOneWidget);
      await tester.tap(find.text('Atur'));
      await tester.pumpAndSettle();

      expect(
        gateway.requestedTypes,
        equals([AppPermissionType.locationWhenInUse]),
      );
      expect(gateway.openSettingsCalls, 0);
      expect(find.text('Presisi'), findsOneWidget);
      expect(find.text('Lengkap'), findsOneWidget);
    },
  );
}
