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
            routerConfig: router ?? AppRouter.router,
          );
        },
      ),
    );
  }
}
