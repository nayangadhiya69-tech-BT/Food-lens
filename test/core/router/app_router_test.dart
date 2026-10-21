import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/core/router/app_router.dart';

void main() {
  group('AppRouter.resolveStartLocation', () {
    test('unauthenticated always starts at login', () {
      expect(
        AppRouter.resolveStartLocation(
          isAuthenticated: false,
          onboardingComplete: false,
        ),
        AppRoutes.login,
      );
      expect(
        AppRouter.resolveStartLocation(
          isAuthenticated: false,
          onboardingComplete: true,
        ),
        AppRoutes.login,
      );
    });

    test('authenticated without onboarding starts at setup', () {
      expect(
        AppRouter.resolveStartLocation(
          isAuthenticated: true,
          onboardingComplete: false,
        ),
        AppRoutes.setup,
      );
    });

    test('authenticated with onboarding starts at home', () {
      expect(
        AppRouter.resolveStartLocation(
          isAuthenticated: true,
          onboardingComplete: true,
        ),
        AppRoutes.home,
      );
    });
  });

  group('AppRouter.redirect', () {
    test('shell routes require authentication', () {
      for (final location in [
        AppRoutes.home,
        AppRoutes.history,
        AppRoutes.profile,
      ]) {
        expect(
          AppRouter.redirect(
            location,
            isAuthenticated: false,
            onboardingComplete: true,
          ),
          AppRoutes.login,
          reason: '$location must bounce unauthenticated users to login',
        );
      }
    });

    test('authenticated shell access is allowed only after onboarding', () {
      // Guard does not block shell entry mid-onboarding (OTP just completed
      // and setup has not run yet — the OTP screen itself navigates to setup).
      expect(
        AppRouter.redirect(
          AppRoutes.home,
          isAuthenticated: true,
          onboardingComplete: true,
        ),
        isNull,
      );
    });

    test('login/OTP bounce to home only when authed AND onboarded', () {
      for (final location in [AppRoutes.login, AppRoutes.otp]) {
        expect(
          AppRouter.redirect(
            location,
            isAuthenticated: true,
            onboardingComplete: true,
          ),
          AppRoutes.home,
        );
        expect(
          AppRouter.redirect(
            location,
            isAuthenticated: true,
            onboardingComplete: false,
          ),
          isNull,
          reason: '$location must stay reachable before onboarding completes',
        );
        expect(
          AppRouter.redirect(
            location,
            isAuthenticated: false,
            onboardingComplete: false,
          ),
          isNull,
        );
      }
    });

    test('setup bounces to home only once onboarding is complete', () {
      expect(
        AppRouter.redirect(
          AppRoutes.setup,
          isAuthenticated: true,
          onboardingComplete: true,
        ),
        AppRoutes.home,
      );
      expect(
        AppRouter.redirect(
          AppRoutes.setup,
          isAuthenticated: true,
          onboardingComplete: false,
        ),
        isNull,
      );
    });

    test('splash and language are never redirected', () {
      expect(
        AppRouter.redirect(
          AppRoutes.splash,
          isAuthenticated: false,
          onboardingComplete: false,
        ),
        isNull,
      );
      expect(
        AppRouter.redirect(
          AppRoutes.language,
          isAuthenticated: false,
          onboardingComplete: false,
        ),
        isNull,
      );
    });
  });
}
