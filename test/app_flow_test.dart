import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/app.dart';
import 'package:foodlens/core/router/app_router.dart';
import 'package:foodlens/core/storage/app_prefs.dart';
import 'package:foodlens/features/authentication/view/login_screen.dart';
import 'package:foodlens/features/authentication/view/otp_screen.dart';
import 'package:foodlens/features/onboarding/view/profile_setup_screen.dart';
import 'package:foodlens/features/shell/view/main_shell.dart';
import 'package:foodlens/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Boots the full app with a fresh router on a given persisted state.
Future<void> pumpApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  await AppPrefs.init();
  await tester.pumpWidget(FoodLensApp(router: AppRouter.create()));
  // Splash is the initial route; let its minimum duration elapse.
  await tester.pump(const Duration(milliseconds: 1600));
  await tester.pumpAndSettle();
}

/// Waits for mock repository latency to finish.
Future<void> settleMocks(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

String l10nFor(WidgetTester tester, String Function(AppLocalizations) pick) {
  // Look up from a descendant of MaterialApp — the MaterialApp element itself
  // sits above the Localizations widget, so AppLocalizations.of would be null.
  final context = tester.element(find.byType(Scaffold).first);
  return pick(AppLocalizations.of(context));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('initial route rules', () {
    testWidgets('unauthenticated cold start lands on login', (tester) async {
      await pumpApp(tester);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('authed without onboarding lands on setup', (tester) async {
      await pumpApp(tester, prefs: {'demo_authenticated': true});
      expect(find.byType(ProfileSetupScreen), findsOneWidget);
    });

    testWidgets('authed with onboarding lands on home shell', (tester) async {
      await pumpApp(
        tester,
        prefs: {'demo_authenticated': true, 'onboarding_complete': true},
      );
      expect(find.byType(MainShell), findsOneWidget);
      expect(find.textContaining('Mahesh'), findsOneWidget);
    });
  });

  group('demo sign-in flow', () {
    testWidgets('phone → OTP → setup → home', (tester) async {
      await pumpApp(tester);
      expect(find.byType(LoginScreen), findsOneWidget);

      // Enter a valid mobile and request the demo code.
      await tester.enterText(find.byType(TextField).first, '9876543210');
      await tester.tap(find.text(l10nFor(tester, (l) => l.sendOtp)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.byType(OtpScreen), findsOneWidget);
      // Demo notice shows the code — no SMS is claimed.
      expect(find.textContaining('123456'), findsWidgets);

      // Type the demo code into the six boxes.
      final boxes = find.byType(TextField);
      expect(boxes, findsNWidgets(6));
      const code = '123456';
      for (var i = 0; i < 6; i++) {
        await tester.enterText(boxes.at(i), code[i]);
        await tester.pump();
      }
      await tester.tap(find.text(l10nFor(tester, (l) => l.otpVerify)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Onboarding has not been completed yet → setup screen.
      expect(find.byType(ProfileSetupScreen), findsOneWidget);
      expect(AppPrefs.demoAuthenticated, isTrue);
      expect(AppPrefs.onboardingComplete, isFalse);

      // Skip setup → shell.
      await tester
          .tap(find.text(l10nFor(tester, (l) => l.actionSkipForNow)));
      await tester.pumpAndSettle();
      expect(find.byType(MainShell), findsOneWidget);
      expect(AppPrefs.onboardingComplete, isTrue);
    });
  });

  group('shell tabs', () {
    Future<void> openShell(WidgetTester tester) async {
      await pumpApp(
        tester,
        prefs: {'demo_authenticated': true, 'onboarding_complete': true},
      );
      await settleMocks(tester);
      expect(find.byType(MainShell), findsOneWidget);
    }

    testWidgets('switching tabs keeps shell navigation', (tester) async {
      await openShell(tester);
      expect(find.textContaining('Mahesh'), findsOneWidget);

      await tester.tap(find.text(l10nFor(tester, (l) => l.navHistory)));
      await tester.pumpAndSettle();
      await settleMocks(tester);
      // Both the nav label and the screen title say "History"; the loaded
      // content proves the tab actually switched.
      expect(find.text('Patanjali Doodh Biscuits'), findsOneWidget);
      expect(find.text('Dahi — Plain Curd'), findsOneWidget);

      await tester.tap(find.text(l10nFor(tester, (l) => l.navProfile)));
      await tester.pumpAndSettle();
      await settleMocks(tester);
      // Profile tab: the demo badge on the user card.
      expect(
        find.text(l10nFor(tester, (l) => l.profileDemoBadge)),
        findsOneWidget,
      );

      await tester.tap(find.text(l10nFor(tester, (l) => l.navHome)));
      await tester.pumpAndSettle();
      await settleMocks(tester);
      expect(find.textContaining('Mahesh'), findsOneWidget);
    });

    testWidgets('scan CTA shows an honest unavailable notice', (tester) async {
      await openShell(tester);
      await tester.tap(find.text(l10nFor(tester, (l) => l.scanCtaTitle)));
      await tester.pump();
      expect(
        find.text(l10nFor(tester, (l) => l.scanUnavailable)),
        findsOneWidget,
      );
    });

    testWidgets(
        'sign-out from profile returns to login and keeps non-auth prefs',
        (tester) async {
      await openShell(tester);
      await tester.tap(find.text(l10nFor(tester, (l) => l.navProfile)));
      await tester.pumpAndSettle();
      await settleMocks(tester);

      // The red sign-out button on the profile screen (the dialog uses an
      // ElevatedButton, so widgetWithText disambiguates the two "Sign out"
      // labels that exist while the dialog is open).
      await tester.tap(
        find.widgetWithText(
          FilledButton,
          l10nFor(tester, (l) => l.actionSignOut),
        ),
      );
      await tester.pumpAndSettle();
      // Confirmation dialog.
      expect(find.text(l10nFor(tester, (l) => l.signOutTitle)), findsOneWidget);
      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          l10nFor(tester, (l) => l.actionSignOut),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(AppPrefs.demoAuthenticated, isFalse);
      // Onboarding flag survives sign-out (locale and flags are kept too).
      expect(AppPrefs.onboardingComplete, isTrue);
    });
  });

  group('language persistence', () {
    testWidgets('changing language on login applies immediately and persists',
        (tester) async {
      await pumpApp(tester);

      // The compact switcher on login: tap "हि".
      await tester.tap(find.text('हि'));
      await tester.pumpAndSettle();

      expect(AppPrefs.localeCode, 'hi');
      // Hindi login title confirms the live locale switch.
      expect(find.text('अपना मोबाइल नंबर दर्ज करें'), findsOneWidget);
    });
  });
}
