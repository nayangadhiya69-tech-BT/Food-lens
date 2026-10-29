import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_locales.dart';
import 'core/di/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_size.dart';
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
      child: MaterialApp.router(
        title: 'FoodLens',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        // The interface is always English. The language preference is
        // used only to pick the voice for the Listen voiceover.
        locale: const Locale('en'),
        supportedLocales: AppLocales.supported,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router ?? AppRouter.router,
        // Captures the screen width once per size change so every
        // dynamicWidth/dynamicHeight call in the tree is in sync.
        builder: (context, child) {
          AppSize.init(context);
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
