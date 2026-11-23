import 'package:akar/core/di/injection_container.dart' as di;
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/bloc/ronda_bloc/ronda_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/create_complaint_bloc/create_complaint_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await di.sl.reset();
    SharedPreferences.setMockInitialValues({});
    await di.init();
  });

  tearDown(() async {
    await di.sl.reset();
  });

  test('di.init() registers all 5 feature sync handlers into OfflineSyncCoordinator', () {
    final coordinator = di.sl<OfflineSyncCoordinator>();

    expect(coordinator.handlers.length, equals(5));
    expect(coordinator.hasHandlerFor(OfflineFeatureType.ronda), isTrue);
    expect(coordinator.hasHandlerFor(OfflineFeatureType.jagaTanah), isTrue);
    expect(coordinator.hasHandlerFor(OfflineFeatureType.complaint), isTrue);
    expect(coordinator.hasHandlerFor(OfflineFeatureType.bankSampah), isTrue);
    expect(coordinator.hasHandlerFor(OfflineFeatureType.activation), isTrue);
  });

  test('di.init() wires offline-capable BLoCs without errors', () async {
    final rondaBloc = di.sl<RondaBloc>();
    final jagaTanahBloc = di.sl<CreateJagaTanahBloc>();
    final complaintBloc = di.sl<CreateComplaintBloc>();
    final bankSampahBloc = di.sl<BankSampahBloc>();
    final activationBloc = di.sl<ActivationBloc>();

    expect(rondaBloc, isNotNull);
    expect(jagaTanahBloc, isNotNull);
    expect(complaintBloc, isNotNull);
    expect(bankSampahBloc, isNotNull);
    expect(activationBloc, isNotNull);

    await rondaBloc.close();
    await jagaTanahBloc.close();
    await complaintBloc.close();
    await bankSampahBloc.close();
    await activationBloc.close();
  });
}
