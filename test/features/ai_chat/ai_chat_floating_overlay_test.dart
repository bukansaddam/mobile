import 'package:akar/core/di/injection_container.dart' as di;
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_floating_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('di.init() resolves AiChatBloc cleanly', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await di.sl.reset();
    await di.init();

    expect(di.sl.isRegistered<AiChatBloc>(), isTrue);
    final bloc = di.sl<AiChatBloc>();
    expect(bloc, isA<AiChatBloc>());
    await bloc.close();
    await di.sl.reset();
  });

  testWidgets(
    'AiChatFloatingOverlay snaps to left edge when dragged across midpoint and preserves bottom clearance >= 36px',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      var tapped = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: AiChatFloatingOverlay(
              onTap: () => tapped++,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final fabFinder = find.byKey(const Key('ai_chat_floating_fab'));
      expect(fabFinder, findsOneWidget);

      final opacityFinder = find.byKey(
        const Key('ai_chat_floating_fab_opacity'),
      );
      expect(opacityFinder, findsOneWidget);
      expect(tester.widget<AnimatedOpacity>(opacityFinder).opacity, 0.5);

      final initialRect = tester.getRect(fabFinder);
      // Starts docked on right edge
      expect(initialRect.left, greaterThan(160));
      // Clearance from bottom edge of container >= 36px
      expect(640 - initialRect.bottom, greaterThanOrEqualTo(36));

      // Tap invokes onTap
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();
      expect(tapped, 1);

      // While dragging, FAB becomes 100% opaque
      final gesture = await tester.startGesture(tester.getCenter(fabFinder));
      await gesture.moveBy(const Offset(-30, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(-190, 40));
      await tester.pump();
      expect(tester.widget<AnimatedOpacity>(opacityFinder).opacity, 1.0);

      // Release drag -> snaps left, then returns to 50% opacity when idle
      await gesture.up();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(tester.widget<AnimatedOpacity>(opacityFinder).opacity, 0.5);

      final snappedRect = tester.getRect(fabFinder);
      expect(snappedRect.left, lessThan(40));
      // Still respects >= 36px bottom clearance even after downward drag
      expect(640 - snappedRect.bottom, greaterThanOrEqualTo(36));
    },
  );
}
