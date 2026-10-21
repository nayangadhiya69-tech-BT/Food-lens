import 'package:flutter/foundation.dart';

import '../../../core/models/load_state.dart';
import '../model/home_overview.dart';
import '../repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository);

  final HomeRepository _repository;

  LoadState _state = LoadState.loading;
  HomeOverview? _overview;

  LoadState get state => _state;
  HomeOverview? get overview => _overview;
  bool get isEmpty =>
      _state == LoadState.success &&
      (_overview == null || _overview!.recentScans.isEmpty);

  Future<void> load() async {
    _state = LoadState.loading;
    notifyListeners();
    try {
      _overview = await _repository.fetchOverview();
      _state = LoadState.success;
    } catch (_) {
      _state = LoadState.error;
    }
    notifyListeners();
  }
}
