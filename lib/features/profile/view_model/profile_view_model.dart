import 'package:flutter/foundation.dart';

import '../../../core/models/health_flag.dart';
import '../../../core/models/load_state.dart';
import '../../../core/storage/app_prefs.dart';
import '../model/app_user.dart';
import '../repository/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository)
    : healthFlags = HealthFlag.fromKeys(AppPrefs.healthFlags);

  final ProfileRepository _repository;

  LoadState _state = LoadState.loading;
  AppUser? _user;

  LoadState get state => _state;
  AppUser? get user => _user;

  /// Local-only health flags, persisted immediately on change.
  Set<HealthFlag> healthFlags;

  Future<void> load() async {
    // First load → loading state (skeleton shimmer); retry after an error
    // shimmers again because there is still no data to show.
    if (_user == null) {
      _state = LoadState.loading;
      notifyListeners();
    }
    try {
      _user = await _repository.fetchProfile();
      _state = LoadState.success;
    } catch (_) {
      _state = LoadState.error;
    }
    notifyListeners();
  }

  void toggleFlag(HealthFlag flag) {
    healthFlags = HealthFlag.toggle(healthFlags, flag);
    notifyListeners();
    // Fire-and-forget local persistence; the UI state is already updated.
    AppPrefs.setHealthFlags(HealthFlag.toKeys(healthFlags));
  }
}
