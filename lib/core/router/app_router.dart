import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/view/login_screen.dart';
import '../../features/authentication/view/otp_screen.dart';
import '../../features/history/view/history_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/language/view/language_screen.dart';
import '../../features/my_day/view/my_day_screen.dart';
import '../../features/onboarding/view/name_screen.dart';
import '../../features/onboarding/view/profile_setup_screen.dart';
import '../../features/onboarding/view/terms_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/scan/view/scan_barcode_screen.dart';
import '../../features/scan/view/scan_flags_screen.dart';
import '../../features/scan/view/scan_mode_screen.dart';
import '../../features/scan/view/scan_photo_screen.dart';
import '../../features/scan/view/scan_processing_screen.dart';
import '../../features/scan/view/scan_result_screen.dart';
import '../../features/shell/view/main_shell.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../l10n/generated/app_localizations.dart';
import '../storage/app_prefs.dart';
import 'route_transitions.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String setup = '/setup';
  static const String language = '/language';

  // Post-OTP onboarding: terms acceptance, then the name, then the app.
  static const String terms = '/terms';
  static const String name = '/name';

  // Shell (bottom navigation) branches.
  static const String home = '/home';
  static const String myDay = '/my-day';
  static const String history = '/history';
  static const String profile = '/profile';

  // Scan flow, pushed on top of the shell: mode picker → capture →
  // flags → processing → result.
  static const String scan = '/scan';
  static const String scanBarcode = '/scan/barcode';
  static const String scanPhoto = '/scan/photo';
  static const String scanFlags = '/scan/flags';
  static const String scanProcessing = '/scan/processing';
  static const String scanResult = '/scan/result';

  /// Query parameter carrying the phone number to the OTP screen.
  static const String phoneParam = 'phone';

  static String otpLocation(String phone) =>
      '$otp?$phoneParam=${Uri.encodeComponent(phone)}';
}

class AppRouter {
  AppRouter._();

  /// Chooses the first meaningful screen after the splash, based only on
  /// restored preferences. Selecting a language never counts as
  /// authentication, and authentication never completes onboarding.
  /// Mid-onboarding it resumes at the last unfinished step: the terms,
  /// then the name.
  static String resolveStartLocation({
    required bool isAuthenticated,
    required bool onboardingComplete,
    bool termsAccepted = false,
  }) {
    if (!isAuthenticated) return AppRoutes.login;
    if (onboardingComplete) return AppRoutes.home;
    return termsAccepted ? AppRoutes.name : AppRoutes.terms;
  }

  /// Navigation guard evaluated on every route change. See Stage A plan:
  /// * shell requires a (demo) session;
  /// * login/OTP bounce to the shell only once the session *and* onboarding
  ///   are complete (so the post-OTP onboarding steps are never skipped);
  /// * onboarding steps (terms, name, setup) bounce away only after
  ///   onboarding has been completed, and require a session otherwise.
  static String? redirect(
    String location, {
    required bool isAuthenticated,
    required bool onboardingComplete,
  }) {
    final isShell =
        location == AppRoutes.home ||
        location == AppRoutes.myDay ||
        location == AppRoutes.history ||
        location == AppRoutes.profile;
    // The scan flow lives outside the shell but needs the same session.
    final isScan = location.startsWith(AppRoutes.scan);
    if ((isShell || isScan) && !isAuthenticated) return AppRoutes.login;

    final isAuthScreen =
        location == AppRoutes.login || location == AppRoutes.otp;
    if (isAuthScreen && isAuthenticated && onboardingComplete) {
      return AppRoutes.home;
    }
    final isOnboarding =
        location == AppRoutes.terms ||
        location == AppRoutes.name ||
        location == AppRoutes.setup;
    if (isOnboarding && !isAuthenticated) return AppRoutes.login;
    if (isOnboarding && isAuthenticated && onboardingComplete) {
      return AppRoutes.home;
    }
    return null;
  }

  static String? _guard(BuildContext context, GoRouterState state) {
    return redirect(
      state.matchedLocation,
      isAuthenticated: AppPrefs.demoAuthenticated,
      onboardingComplete: AppPrefs.onboardingComplete,
    );
  }

  /// Creates a fresh [GoRouter]. Widgets use the shared [router] instance;
  /// tests create their own so navigation state never leaks between cases.
  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      redirect: _guard,
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text(AppLocalizations.of(context).notFoundTitle)),
      ),
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (context, state) => AppTransitions.slide(
            key: state.pageKey,
            context: context,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.otp,
          name: 'otp',
          pageBuilder: (context, state) => AppTransitions.slide(
            key: state.pageKey,
            context: context,
            child: const OtpScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.setup,
          name: 'setup',
          pageBuilder: (context, state) => AppTransitions.slide(
            key: state.pageKey,
            context: context,
            child: const ProfileSetupScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.terms,
          name: 'terms',
          pageBuilder: (context, state) => AppTransitions.slide(
            key: state.pageKey,
            context: context,
            child: const TermsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.name,
          name: 'name',
          pageBuilder: (context, state) => AppTransitions.slide(
            key: state.pageKey,
            context: context,
            child: const NameScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.language,
          name: 'language',
          pageBuilder: (context, state) => AppTransitions.slide(
            key: state.pageKey,
            context: context,
            child: const LanguageScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.scan,
          name: 'scan',
          pageBuilder: (context, state) => AppTransitions.slide(
            key: state.pageKey,
            context: context,
            child: const ScanModeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'barcode',
              name: 'scanBarcode',
              pageBuilder: (context, state) => AppTransitions.slide(
                key: state.pageKey,
                context: context,
                child: const ScanBarcodeScreen(),
              ),
            ),
            GoRoute(
              path: 'photo',
              name: 'scanPhoto',
              pageBuilder: (context, state) => AppTransitions.slide(
                key: state.pageKey,
                context: context,
                child: const ScanPhotoScreen(),
              ),
            ),
            GoRoute(
              path: 'flags',
              name: 'scanFlags',
              pageBuilder: (context, state) => AppTransitions.slide(
                key: state.pageKey,
                context: context,
                child: const ScanFlagsScreen(),
              ),
            ),
            GoRoute(
              path: 'processing',
              name: 'scanProcessing',
              pageBuilder: (context, state) => AppTransitions.slide(
                key: state.pageKey,
                context: context,
                child: const ScanProcessingScreen(),
              ),
            ),
            GoRoute(
              path: 'result',
              name: 'scanResult',
              pageBuilder: (context, state) => AppTransitions.slide(
                key: state.pageKey,
                context: context,
                child: const ScanResultScreen(),
              ),
            ),
          ],
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.myDay,
                  name: 'myDay',
                  builder: (context, state) => const MyDayScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.history,
                  name: 'history',
                  builder: (context, state) => const HistoryScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  name: 'profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// The app's single shared [GoRouter]. Preferences are restored by
  /// `AppPrefs.init()` in `main()` before the first frame, so the splash
  /// route can resolve the start location safely.
  static final GoRouter router = create();
}
