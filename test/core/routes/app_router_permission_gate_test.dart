import 'package:akar/core/routes/app_router.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  const memberUser = UserEntity(
    id: 10,
    name: 'Warga',
    role: 'member',
  );
  const officerUser = UserEntity(
    id: 20,
    name: 'Linmas',
    role: 'officer',
  );

  const authenticatedMember = AuthAuthenticated(
    user: memberUser,
    token: 'member-token',
  );
  const authenticatedOfficer = AuthAuthenticated(
    user: officerUser,
    token: 'officer-token',
  );

  group('AppRouter.resolveRedirect permission gate', () {
    test(
      'authenticated Masyarakat with missing permissions on /login or /masyarakat/main redirects to /permission-setup',
      () {
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedMember,
            location: AppRouter.loginPath,
            hasAllPermissions: false,
            hasCompletedSurvey: false,
          ),
          AppRouter.permissionSetupPath,
        );
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedMember,
            location: AppRouter.masyarakatMainPath,
            hasAllPermissions: false,
            hasCompletedSurvey: false,
          ),
          AppRouter.permissionSetupPath,
        );
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedMember,
            location: AppRouter.permissionSetupPath,
            hasAllPermissions: false,
            hasCompletedSurvey: false,
          ),
          isNull,
        );
      },
    );

    test(
      'authenticated Masyarakat with all permissions granted on /permission-setup redirects to /masyarakat/main',
      () {
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedMember,
            location: AppRouter.permissionSetupPath,
            hasAllPermissions: true,
            hasCompletedSurvey: false,
          ),
          AppRouter.masyarakatMainPath,
        );
      },
    );

    test(
      'authenticated Linmas with missing permissions on /main or /initial-survey redirects to /permission-setup',
      () {
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedOfficer,
            location: AppRouter.mainPath,
            hasAllPermissions: false,
            hasCompletedSurvey: true,
          ),
          AppRouter.permissionSetupPath,
        );
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedOfficer,
            location: AppRouter.initialSurveyPath,
            hasAllPermissions: false,
            hasCompletedSurvey: false,
          ),
          AppRouter.permissionSetupPath,
        );
      },
    );

    test(
      'authenticated Linmas with all permissions granted and hasCompletedSurvey == false on /permission-setup redirects to /initial-survey',
      () {
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedOfficer,
            location: AppRouter.permissionSetupPath,
            hasAllPermissions: true,
            hasCompletedSurvey: false,
          ),
          AppRouter.initialSurveyPath,
        );
      },
    );

    test(
      'authenticated Linmas with all permissions granted and hasCompletedSurvey == true on /permission-setup redirects to /main',
      () {
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedOfficer,
            location: AppRouter.permissionSetupPath,
            hasAllPermissions: true,
            hasCompletedSurvey: true,
          ),
          AppRouter.mainPath,
        );
      },
    );

    test(
      'unauthenticated user on /permission-setup redirects to /welcome',
      () {
        expect(
          AppRouter.resolveRedirect(
            authState: const AuthUnauthenticated(),
            location: AppRouter.permissionSetupPath,
            hasAllPermissions: false,
            hasCompletedSurvey: false,
          ),
          AppRouter.welcomePath,
        );
      },
    );

    test(
      '/emergency-call and / (splashPath) remain exempt from /permission-setup redirect',
      () {
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedMember,
            location: AppRouter.emergencyCallPath,
            hasAllPermissions: false,
            hasCompletedSurvey: false,
          ),
          isNull,
        );
        expect(
          AppRouter.resolveRedirect(
            authState: authenticatedOfficer,
            location: AppRouter.splashPath,
            hasAllPermissions: false,
            hasCompletedSurvey: false,
          ),
          isNull,
        );
      },
    );
  });

  group('AppRouter.toEditProfile & authRoutingKey', () {
    test('authRoutingKey tetap sama saat nama/profil berubah tanpa ganti role/quiz', () {
      const before = AuthAuthenticated(
        user: UserEntity(id: 10, name: 'Lama', role: 'member'),
        token: 'tok',
      );
      const after = AuthAuthenticated(
        user: UserEntity(id: 10, name: 'Baru', role: 'member'),
        token: 'tok',
      );
      const loggedOut = AuthUnauthenticated();

      expect(
        AppRouter.authRoutingKey(before),
        equals(AppRouter.authRoutingKey(after)),
      );
      expect(
        AppRouter.authRoutingKey(before),
        isNot(equals(AppRouter.authRoutingKey(loggedOut))),
      );
    });

    testWidgets(
      'toEditProfile tetap bisa dibuka ulang setelah pop meski router sempat refresh',
      (tester) async {
        final router = GoRouter(
          initialLocation: AppRouter.masyarakatMainPath,
          routes: [
            GoRoute(
              path: AppRouter.masyarakatMainPath,
              builder: (context, state) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => AppRouter.toEditProfile(context),
                  child: const Text('Edit Profil Saya'),
                ),
              ),
            ),
            GoRoute(
              path: AppRouter.editProfilePath,
              name: AppRouter.editProfile,
              builder: (context, state) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.pop(true),
                  child: const Text('Selesai Edit'),
                ),
              ),
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit Profil Saya'));
        await tester.pumpAndSettle();
        expect(find.text('Selesai Edit'), findsOneWidget);

        // Simulasikan router.refresh() saat EditProfile terbuka (seperti efek UpdateAuthUserEvent).
        router.refresh();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Selesai Edit'));
        await tester.pumpAndSettle();
        expect(find.text('Edit Profil Saya'), findsOneWidget);

        // Buka ulang Edit Profil: sebelumnya terkunci permanen oleh _isNavigatingToEditProfile.
        await tester.tap(find.text('Edit Profil Saya'));
        await tester.pumpAndSettle();
        expect(find.text('Selesai Edit'), findsOneWidget);
      },
    );
  });
}
