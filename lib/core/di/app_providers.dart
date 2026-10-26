import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/authentication/repository/auth_repository.dart';
import '../../features/authentication/repository/mock_auth_repository.dart';
import '../../features/authentication/view_model/auth_view_model.dart';
import '../../features/history/repository/history_repository.dart';
import '../../features/history/repository/mock_history_repository.dart';
import '../../features/home/repository/home_repository.dart';
import '../../features/home/repository/mock_home_repository.dart';
import '../../features/language/repository/language_repository.dart';
import '../../features/language/view_model/locale_provider.dart';
import '../../features/my_day/repository/my_day_repository.dart';
import '../../features/my_day/repository/prefs_my_day_repository.dart';
import '../../features/my_day/view_model/my_day_view_model.dart';
import '../../features/profile/repository/mock_profile_repository.dart';
import '../../features/profile/repository/profile_repository.dart';
import '../../features/scan/repository/mock_scan_repository.dart';
import '../../features/scan/repository/scan_repository.dart';
import '../../features/scan/view_model/scan_view_model.dart';

/// Single place where every repository and application-scope view model is
/// wired. To move from demo data to a real API later:
///
/// 1. Implement the `*Repository` interface against the backend
///    (using `ApiClient` + `AppConfig.apiBaseUrl`);
/// 2. Swap the corresponding `Mock*Repository` below for the new class.
///
/// No screen or tab view model ever constructs a repository directly, so
/// this is the only file that changes when the data source switches.
List<SingleChildWidget> appProviders() => [
  // --- Data sources (demo implementations) ---
  Provider<LanguageRepository>(create: (_) => const PrefsLanguageRepository()),
  Provider<AuthRepository>(create: (_) => MockAuthRepository()),
  Provider<HomeRepository>(create: (_) => MockHomeRepository()),
  Provider<HistoryRepository>(create: (_) => MockHistoryRepository()),
  Provider<ProfileRepository>(create: (_) => MockProfileRepository()),
  Provider<ScanRepository>(create: (_) => MockScanRepository()),
  // My Day persists per-date entries locally; swap for an API-backed
  // implementation when a backend exists (same interface).
  Provider<MyDayRepository>(create: (_) => const PrefsMyDayRepository()),

  // --- Application-scope state ---
  ChangeNotifierProvider<LocaleProvider>(
    create: (context) => LocaleProvider(context.read<LanguageRepository>()),
  ),
  ChangeNotifierProvider<AuthViewModel>(
    create: (context) => AuthViewModel(context.read<AuthRepository>()),
  ),
  // My Day is app-scope: the Home dashboard shows the same totals,
  // so both tabs share one view model and can never disagree.
  ChangeNotifierProvider<MyDayViewModel>(
    create: (context) =>
        MyDayViewModel(context.read<MyDayRepository>())..load(),
  ),
  // The scan flow's session lives across its separate routes
  // (capture → flags → processing → result), so it is app-scope too;
  // opening the scan-mode screen resets it via startSession.
  ChangeNotifierProvider<ScanViewModel>(
    create: (context) => ScanViewModel(context.read<ScanRepository>()),
  ),
];
