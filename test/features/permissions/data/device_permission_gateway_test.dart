import 'dart:async';
import 'dart:io';

import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/features/permissions/data/services/device_permission_gateway.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeFirebaseNotificationService extends Fake
    implements FirebaseNotificationService {
  bool requestNotificationResult = true;
  int requestNotificationCalls = 0;
  int ensureTokenCachedCalls = 0;

  @override
  Future<void> ensureTokenCached() async {
    ensureTokenCachedCalls += 1;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    requestNotificationCalls += 1;
    return requestNotificationResult;
  }
}

class _FakeFirebaseMessaging extends Fake implements FirebaseMessaging {
  int requestPermissionCalls = 0;
  int getTokenCalls = 0;
  int onTokenRefreshGetterCalls = 0;
  AuthorizationStatus authorizationStatus = AuthorizationStatus.authorized;
  String? tokenToReturn = 'test-fcm-token';
  final StreamController<String> _tokenRefreshController =
      StreamController<String>.broadcast();

  @override
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  }) async {
    requestPermissionCalls += 1;
    return NotificationSettings(
      alert: AppleNotificationSetting.enabled,
      announcement: AppleNotificationSetting.disabled,
      authorizationStatus: authorizationStatus,
      badge: AppleNotificationSetting.enabled,
      carPlay: AppleNotificationSetting.disabled,
      lockScreen: AppleNotificationSetting.enabled,
      notificationCenter: AppleNotificationSetting.enabled,
      showPreviews: AppleShowPreviewSetting.always,
      timeSensitive: AppleNotificationSetting.disabled,
      criticalAlert: AppleNotificationSetting.enabled,
      sound: AppleNotificationSetting.enabled,
      providesAppNotificationSettings: AppleNotificationSetting.disabled,
    );
  }

  @override
  Future<void> setForegroundNotificationPresentationOptions({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  }) async {}

  @override
  Future<String?> getToken({
    String? vapidKey,
    String? serviceWorkerScriptPath,
  }) async {
    getTokenCalls += 1;
    return tokenToReturn;
  }

  @override
  Stream<String> get onTokenRefresh {
    onTokenRefreshGetterCalls += 1;
    return _tokenRefreshController.stream;
  }

  void emitTokenRefresh(String token) {
    _tokenRefreshController.add(token);
  }

  @override
  Future<RemoteMessage?> getInitialMessage() async => null;

  void dispose() {
    _tokenRefreshController.close();
  }
}

class _FakeAndroidLocalNotificationsPlugin extends Fake
    implements AndroidFlutterLocalNotificationsPlugin {
  int createChannelCalls = 0;
  int requestNotificationsCalls = 0;

  @override
  Future<void> createNotificationChannel(
    AndroidNotificationChannel notificationChannel,
  ) async {
    createChannelCalls += 1;
  }

  @override
  Future<bool?> requestNotificationsPermission() async {
    requestNotificationsCalls += 1;
    return true;
  }
}

class _FakeLocalNotificationsPlugin extends Fake
    implements FlutterLocalNotificationsPlugin {
  InitializationSettings? lastInitSettings;
  final _FakeAndroidLocalNotificationsPlugin androidPlugin =
      _FakeAndroidLocalNotificationsPlugin();

  @override
  Future<bool?> initialize({
    required InitializationSettings settings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
    onDidReceiveBackgroundNotificationResponse,
  }) async {
    lastInitSettings = settings;
    return true;
  }

  @override
  T? resolvePlatformSpecificImplementation<
    T extends FlutterLocalNotificationsPlatform
  >() {
    if (T == AndroidFlutterLocalNotificationsPlugin) {
      return androidPlugin as T;
    }
    return null;
  }

  @override
  Future<NotificationAppLaunchDetails?>
  getNotificationAppLaunchDetails() async {
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DevicePermissionGateway', () {
    late _FakeFirebaseNotificationService notificationService;
    late Map<Permission, PermissionStatus> statusByPermission;
    late Map<Permission, PermissionStatus> requestResultByPermission;
    late Map<Permission, bool> shouldShowRationaleByPermission;
    late bool shouldShowRationaleThrows;
    late List<Permission> checkedPermissions;
    late List<Permission> requestedPermissions;
    late List<Permission> rationaleCheckedPermissions;
    late int openSettingsCalls;
    late bool openSettingsResult;
    late DevicePermissionGateway gateway;

    DevicePermissionGateway createGateway({bool? isAndroidOverride}) {
      return DevicePermissionGateway(
        notificationService: notificationService,
        isAndroidOverride: isAndroidOverride,
        checkPlatformPermission: (permission) async {
          checkedPermissions.add(permission);
          return statusByPermission[permission] ?? PermissionStatus.denied;
        },
        requestPlatformPermission: (permission) async {
          requestedPermissions.add(permission);
          final result =
              requestResultByPermission[permission] ?? PermissionStatus.denied;
          statusByPermission[permission] = result;
          return result;
        },
        openPlatformSettings: () async {
          openSettingsCalls += 1;
          return openSettingsResult;
        },
        shouldShowRationale: (permission) async {
          rationaleCheckedPermissions.add(permission);
          if (shouldShowRationaleThrows) {
            throw UnimplementedError('Not supported on this platform');
          }
          return shouldShowRationaleByPermission[permission] ?? true;
        },
      );
    }

    setUp(() {
      notificationService = _FakeFirebaseNotificationService();
      statusByPermission = {};
      requestResultByPermission = {};
      shouldShowRationaleByPermission = {};
      shouldShowRationaleThrows = false;
      checkedPermissions = [];
      requestedPermissions = [];
      rationaleCheckedPermissions = [];
      openSettingsCalls = 0;
      openSettingsResult = true;

      gateway = createGateway();
    });

    test('maps every AppPermissionType to the expected OS Permission', () async {
      await gateway.checkStatus(AppPermissionType.locationWhenInUse);
      await gateway.checkStatus(AppPermissionType.locationAlways);
      await gateway.checkStatus(AppPermissionType.camera);
      await gateway.checkStatus(AppPermissionType.microphone);
      await gateway.checkStatus(AppPermissionType.notification);

      expect(
        checkedPermissions,
        equals([
          Permission.locationWhenInUse,
          Permission.locationAlways,
          Permission.camera,
          Permission.microphone,
          Permission.notification,
        ]),
      );
    });

    test('checkStatus maps PermissionStatus values accurately', () async {
      final expectedByStatus = <PermissionStatus, PermissionStepStatus>{
        PermissionStatus.granted: PermissionStepStatus.granted,
        PermissionStatus.limited: PermissionStepStatus.granted,
        PermissionStatus.provisional: PermissionStepStatus.granted,
        PermissionStatus.denied: PermissionStepStatus.notRequested,
        PermissionStatus.permanentlyDenied:
            PermissionStepStatus.permanentlyDenied,
        PermissionStatus.restricted: PermissionStepStatus.permanentlyDenied,
      };

      for (final entry in expectedByStatus.entries) {
        statusByPermission[Permission.camera] = entry.key;
        final mapped = await gateway.checkStatus(AppPermissionType.camera);
        expect(mapped, equals(entry.value), reason: 'checkStatus ${entry.key}');
      }
    });

    test('request maps PermissionStatus values for standard permissions', () async {
      final expectedByStatus = <PermissionStatus, PermissionStepStatus>{
        PermissionStatus.granted: PermissionStepStatus.granted,
        PermissionStatus.limited: PermissionStepStatus.granted,
        PermissionStatus.provisional: PermissionStepStatus.granted,
        PermissionStatus.denied: PermissionStepStatus.denied,
        PermissionStatus.permanentlyDenied:
            PermissionStepStatus.permanentlyDenied,
        PermissionStatus.restricted: PermissionStepStatus.permanentlyDenied,
      };

      for (final entry in expectedByStatus.entries) {
        requestResultByPermission[Permission.microphone] = entry.key;
        final mapped = await gateway.request(AppPermissionType.microphone);
        expect(mapped, equals(entry.value), reason: 'request ${entry.key}');
      }

      expect(requestedPermissions, hasLength(expectedByStatus.length));
      expect(notificationService.requestNotificationCalls, equals(0));
    });

    test(
      'Android request(notification) uses Permission.notification.request(), calls ensureTokenCached() when granted, and skips requestNotificationPermission()',
      () async {
        final androidGateway = createGateway(isAndroidOverride: true);
        requestResultByPermission[Permission.notification] =
            PermissionStatus.granted;

        final result = await androidGateway.request(
          AppPermissionType.notification,
        );

        expect(result, equals(PermissionStepStatus.granted));
        expect(requestedPermissions, equals([Permission.notification]));
        expect(notificationService.ensureTokenCachedCalls, equals(1));
        expect(notificationService.requestNotificationCalls, equals(0));
      },
    );

    test(
      'Android request(notification) returns permanentlyDenied when OS status is permanentlyDenied or restricted',
      () async {
        final androidGateway = createGateway(isAndroidOverride: true);

        requestResultByPermission[Permission.notification] =
            PermissionStatus.permanentlyDenied;
        expect(
          await androidGateway.request(AppPermissionType.notification),
          equals(PermissionStepStatus.permanentlyDenied),
        );

        requestResultByPermission[Permission.notification] =
            PermissionStatus.restricted;
        expect(
          await androidGateway.request(AppPermissionType.notification),
          equals(PermissionStepStatus.permanentlyDenied),
        );

        expect(notificationService.ensureTokenCachedCalls, equals(0));
        expect(notificationService.requestNotificationCalls, equals(0));
      },
    );

    test(
      'Android request(notification) returns denied when denied with shouldShowRationale == true',
      () async {
        final androidGateway = createGateway(isAndroidOverride: true);
        requestResultByPermission[Permission.notification] =
            PermissionStatus.denied;
        shouldShowRationaleByPermission[Permission.notification] = true;

        final result = await androidGateway.request(
          AppPermissionType.notification,
        );

        expect(result, equals(PermissionStepStatus.denied));
        expect(rationaleCheckedPermissions, equals([Permission.notification]));
        expect(notificationService.ensureTokenCachedCalls, equals(0));
        expect(notificationService.requestNotificationCalls, equals(0));
      },
    );

    test(
      'Android request(notification) returns needsSettings when denied with shouldShowRationale == false (Android < 13 disabled notifications)',
      () async {
        final androidGateway = createGateway(isAndroidOverride: true);
        requestResultByPermission[Permission.notification] =
            PermissionStatus.denied;
        shouldShowRationaleByPermission[Permission.notification] = false;

        final result = await androidGateway.request(
          AppPermissionType.notification,
        );

        expect(result, equals(PermissionStepStatus.needsSettings));
        expect(rationaleCheckedPermissions, equals([Permission.notification]));
        expect(notificationService.ensureTokenCachedCalls, equals(0));
        expect(notificationService.requestNotificationCalls, equals(0));
      },
    );

    test(
      'Android request(notification) falls back to denied when shouldShowRationale throws',
      () async {
        final androidGateway = createGateway(isAndroidOverride: true);
        requestResultByPermission[Permission.notification] =
            PermissionStatus.denied;
        shouldShowRationaleThrows = true;

        final result = await androidGateway.request(
          AppPermissionType.notification,
        );

        expect(result, equals(PermissionStepStatus.denied));
        expect(rationaleCheckedPermissions, equals([Permission.notification]));
      },
    );

    test(
      'iOS request(notification) delegates to FirebaseNotificationService and returns granted when authorized',
      () async {
        final iosGateway = createGateway(isAndroidOverride: false);
        notificationService.requestNotificationResult = true;
        statusByPermission[Permission.notification] = PermissionStatus.granted;

        final result = await iosGateway.request(AppPermissionType.notification);

        expect(result, equals(PermissionStepStatus.granted));
        expect(notificationService.requestNotificationCalls, equals(1));
        expect(requestedPermissions, isEmpty);
        expect(checkedPermissions, equals([Permission.notification]));
      },
    );

    test(
      'iOS request(notification) returns granted when authorized provisionally',
      () async {
        final iosGateway = createGateway(isAndroidOverride: false);
        notificationService.requestNotificationResult = true;
        statusByPermission[Permission.notification] =
            PermissionStatus.provisional;

        final result = await iosGateway.request(AppPermissionType.notification);

        expect(result, equals(PermissionStepStatus.granted));
        expect(notificationService.requestNotificationCalls, equals(1));
        expect(checkedPermissions, equals([Permission.notification]));
      },
    );

    test(
      'iOS request(notification) returns permanentlyDenied when OS status is permanentlyDenied',
      () async {
        final iosGateway = createGateway(isAndroidOverride: false);
        notificationService.requestNotificationResult = false;
        statusByPermission[Permission.notification] =
            PermissionStatus.permanentlyDenied;

        final result = await iosGateway.request(AppPermissionType.notification);

        expect(result, equals(PermissionStepStatus.permanentlyDenied));
        expect(notificationService.requestNotificationCalls, equals(1));
        expect(requestedPermissions, isEmpty);
        expect(checkedPermissions, equals([Permission.notification]));
      },
    );

    test(
      'iOS request(notification) returns denied when unauthorized and OS status is denied',
      () async {
        final iosGateway = createGateway(isAndroidOverride: false);
        notificationService.requestNotificationResult = false;
        statusByPermission[Permission.notification] = PermissionStatus.denied;

        final result = await iosGateway.request(AppPermissionType.notification);

        expect(result, equals(PermissionStepStatus.denied));
        expect(notificationService.requestNotificationCalls, equals(1));
        expect(checkedPermissions, equals([Permission.notification]));
      },
    );

    test('openSettings delegates to openPlatformSettings callback', () async {
      openSettingsResult = true;
      expect(await gateway.openSettings(), isTrue);

      openSettingsResult = false;
      expect(await gateway.openSettings(), isFalse);
      expect(openSettingsCalls, equals(2));
    });
  });

  group('Cold-start notification prompt decoupling', () {
    test(
      'FirebaseNotificationService.initialize does not prompt permissions while keeping channels',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final fcm = _FakeFirebaseMessaging();
        final localNotifications = _FakeLocalNotificationsPlugin();
        addTearDown(fcm.dispose);

        final service = FirebaseNotificationService(
          prefs: prefs,
          fcm: fcm,
          localNotifications: localNotifications,
        );

        await service.initialize();

        expect(fcm.requestPermissionCalls, equals(0));
        expect(localNotifications.androidPlugin.requestNotificationsCalls, 0);
        expect(localNotifications.androidPlugin.createChannelCalls, equals(2));

        final darwinSettings = localNotifications.lastInitSettings?.iOS;
        expect(darwinSettings, isNotNull);
        expect(darwinSettings!.requestAlertPermission, isFalse);
        expect(darwinSettings.requestBadgePermission, isFalse);
        expect(darwinSettings.requestSoundPermission, isFalse);
        expect(darwinSettings.requestCriticalPermission, isFalse);
      },
    );

    test(
      'FirebaseNotificationService.requestNotificationPermission requests FCM permissions without calling androidPlugin.requestNotificationsPermission() and caches missing token locally',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final fcm = _FakeFirebaseMessaging()
          ..authorizationStatus = AuthorizationStatus.authorized
          ..tokenToReturn = 'fresh-local-token';
        final localNotifications = _FakeLocalNotificationsPlugin();
        addTearDown(fcm.dispose);

        final service = FirebaseNotificationService(
          prefs: prefs,
          fcm: fcm,
          localNotifications: localNotifications,
        );

        final granted = await service.requestNotificationPermission();

        expect(granted, isTrue);
        expect(fcm.requestPermissionCalls, equals(1));
        expect(
          localNotifications.androidPlugin.requestNotificationsCalls,
          equals(0),
        );
        expect(fcm.getTokenCalls, equals(1));
        expect(service.cachedToken, equals('fresh-local-token'));
      },
    );

    test(
      'FirebaseNotificationService.requestNotificationPermission returns false when denied and skips token refresh and androidPlugin prompt when already cached',
      () async {
        SharedPreferences.setMockInitialValues({'FCM_TOKEN': 'existing-token'});
        final prefs = await SharedPreferences.getInstance();
        final fcm = _FakeFirebaseMessaging()
          ..authorizationStatus = AuthorizationStatus.denied;
        final localNotifications = _FakeLocalNotificationsPlugin();
        addTearDown(fcm.dispose);

        final service = FirebaseNotificationService(
          prefs: prefs,
          fcm: fcm,
          localNotifications: localNotifications,
        );

        final granted = await service.requestNotificationPermission();

        expect(granted, isFalse);
        expect(fcm.requestPermissionCalls, equals(1));
        expect(
          localNotifications.androidPlugin.requestNotificationsCalls,
          equals(0),
        );
        expect(fcm.getTokenCalls, equals(0));
        expect(service.cachedToken, equals('existing-token'));
      },
    );

    test(
      'FirebaseNotificationService.ensureTokenCached fetches token only when cachedToken is null or empty',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final fcm = _FakeFirebaseMessaging()..tokenToReturn = 'cached-via-helper';
        final localNotifications = _FakeLocalNotificationsPlugin();
        addTearDown(fcm.dispose);

        final service = FirebaseNotificationService(
          prefs: prefs,
          fcm: fcm,
          localNotifications: localNotifications,
        );
        addTearDown(service.dispose);

        await service.ensureTokenCached();
        expect(fcm.getTokenCalls, equals(1));
        expect(service.cachedToken, equals('cached-via-helper'));

        await service.ensureTokenCached();
        expect(fcm.getTokenCalls, equals(1));
      },
    );

    test(
      'initialize followed by requestNotificationPermission subscribes to onTokenRefresh only once',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final fcm = _FakeFirebaseMessaging()..tokenToReturn = null;
        final localNotifications = _FakeLocalNotificationsPlugin();
        addTearDown(fcm.dispose);

        final service = FirebaseNotificationService(
          prefs: prefs,
          fcm: fcm,
          localNotifications: localNotifications,
        );
        addTearDown(service.dispose);

        final emittedTokens = <String>[];
        final sub = service.onTokenRefresh.listen(emittedTokens.add);
        addTearDown(sub.cancel);

        await service.initialize();
        expect(service.cachedToken, isNull);
        expect(fcm.onTokenRefreshGetterCalls, equals(1));

        fcm
          ..authorizationStatus = AuthorizationStatus.authorized
          ..tokenToReturn = 'post-permission-token';

        final granted = await service.requestNotificationPermission();
        expect(granted, isTrue);
        expect(service.cachedToken, equals('post-permission-token'));
        expect(fcm.onTokenRefreshGetterCalls, equals(1));

        fcm.emitTokenRefresh('refreshed-token-1');
        await Future<void>.delayed(Duration.zero);

        expect(emittedTokens, equals(['refreshed-token-1']));
        expect(service.cachedToken, equals('refreshed-token-1'));
      },
    );
  });

  group('Static configuration guards', () {
    test('ios/Podfile enables all required permission macros', () {
      final podfile = File('ios/Podfile').readAsStringSync();

      expect(podfile, contains('PERMISSION_LOCATION=1'));
      expect(podfile, contains('PERMISSION_CAMERA=1'));
      expect(podfile, contains('PERMISSION_MICROPHONE=1'));
      expect(podfile, contains('PERMISSION_NOTIFICATIONS=1'));
    });

    test(
      'DisasterAlertService does not request permissions during initialization while keeping notification channel',
      () {
        final source = File(
          'lib/core/services/disaster_alert_service.dart',
        ).readAsStringSync();

        expect(source, contains('createNotificationChannel(androidChannel)'));
        expect(source, isNot(contains('requestAlertPermission: true')));
        expect(source, isNot(contains('requestBadgePermission: true')));
        expect(source, isNot(contains('requestSoundPermission: true')));
        expect(source, isNot(contains('requestCriticalPermission: true')));
        expect(source, isNot(contains('requestNotificationsPermission()')));
        expect(source, isNot(contains('requestExactAlarmsPermission()')));
        expect(source, isNot(contains('iosPlugin.requestPermissions')));
      },
    );
  });
}
