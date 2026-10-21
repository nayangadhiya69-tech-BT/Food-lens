import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_locales.dart';
import 'core/di/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/language/view_model/locale_provider.dart';
import 'l10n/generated/app_localizations.dart';

class FoodLensApp extends StatelessWidget {
  const FoodLensApp({super.key, this.router});

  /// Optional router override for tests; production uses the shared
  /// [AppRouter.router] instance.
  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp.router(
            title: 'FoodLens',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.light,
            locale: localeProvider.locale,
            supportedLocales: AppLocales.supported,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            // Cross-fades all on-screen text when the language changes so
            // the whole tree doesn't visibly "jump" in a single frame.
            // Navigation state is untouched — only opacity animates.
            builder: (context, child) => _LocaleFade(
              localeCode: localeProvider.effectiveCode,
              child: child ?? const SizedBox.shrink(),
            ),
            routerConfig: router ?? AppRouter.router,
          );
        },
      ),
    );
  }
}

/// Fades the app content in once whenever [localeCode] changes.
///
/// The widget subtree (including the Navigator) is *not* recreated — only a
/// short opacity animation runs — so routes, scroll positions and form state
/// all survive a language switch. Respects the system reduced-motion setting.
class _LocaleFade extends StatefulWidget {
  const _LocaleFade({required this.localeCode, required this.child});

  final String localeCode;
  final Widget child;

  @override
  State<_LocaleFade> createState() => _LocaleFadeState();
}

class _LocaleFadeState extends State<_LocaleFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1,
    );
  }

  @override
  void didUpdateWidget(covariant _LocaleFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.localeCode != widget.localeCode) {
      final reduceMotion = MediaQuery.disableAnimationsOf(context);
      if (reduceMotion) {
        _controller.value = 1;
      } else {
        // Run to the end from 0: the frame where every string swaps renders
        // at opacity 0 and then eases in — no visible pop.
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: widget.child,
    );
  }
}
