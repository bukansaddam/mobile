import 'package:akar/features/linmas/tracking/domain/usecases/send_location_usecase.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSendLocationUsecase extends Fake implements SendLocationUsecase {}

class _FakeBackgroundService extends Fake implements FlutterBackgroundService {
  bool running = false;
  int startCalls = 0;

  @override
  Stream<Map<String, dynamic>?> on(String method) => const Stream.empty();

  @override
  Future<bool> isRunning() async => running;

  @override
  Future<bool> startService() async {
    startCalls++;
    running = true;
    return true;
  }

  @override
  void invoke(String method, [Map<String, dynamic>? arg]) {}
}

void main() {
  test(
    'mode debug menjaga background tracking tetap off pada init dan auto-start, tetapi bisa diaktifkan manual',
    () async {
      SharedPreferences.setMockInitialValues({
        'isTrackingActive': true,
        'isTrackingEnabled': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final service = _FakeBackgroundService();

      final bloc = TrackingBloc(
        sendLocationUsecase: _FakeSendLocationUsecase(),
        sharedPreferences: prefs,
        isDebugMode: true,
        backgroundService: service,
      );
      addTearDown(bloc.close);

      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.isTrackingActive, isFalse);
      expect(prefs.getBool('isTrackingActive'), isFalse);

      // Auto-start (splash/login/permission) diabaikan pada mode debug
      bloc.add(const StartTrackingEvent());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.isTrackingActive, isFalse);
      expect(service.startCalls, 0);

      // Toggle manual di modal konfigurasi tetap bisa menyalakan tracking
      bloc.add(const StartTrackingEvent(manual: true));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.isTrackingActive, isTrue);
      expect(service.startCalls, 1);
    },
  );

  test(
    'mode non-debug tetap menyalakan background tracking pada auto-start',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final service = _FakeBackgroundService();

      final bloc = TrackingBloc(
        sendLocationUsecase: _FakeSendLocationUsecase(),
        sharedPreferences: prefs,
        isDebugMode: false,
        backgroundService: service,
      );
      addTearDown(bloc.close);

      bloc.add(const StartTrackingEvent());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.isTrackingActive, isTrue);
      expect(service.startCalls, 1);
    },
  );
}
