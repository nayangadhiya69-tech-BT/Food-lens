import 'package:flutter/foundation.dart';

import '../../../core/models/load_state.dart';
import '../model/scan_record.dart';
import '../repository/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel(this._repository);

  final HistoryRepository _repository;

  LoadState _state = LoadState.loading;
  List<ScanRecord> _records = const [];
  bool _loaded = false;

  LoadState get state => _state;
  List<ScanRecord> get records => _records;
  bool get isEmpty => _state == LoadState.success && _records.isEmpty;

  Future<void> load() async {
    // First load → loading state (skeleton shimmer). Later calls
    // (pull-to-refresh) keep the current list on screen and update it in
    // the background; only a failure replaces the screen with the error
    // view. `_loaded` (not `isEmpty`) distinguishes the two: an empty list
    // is valid loaded data.
    if (!_loaded) {
      _state = LoadState.loading;
      notifyListeners();
    }
    try {
      _records = await _repository.fetchHistory();
      _state = LoadState.success;
      _loaded = true;
    } catch (_) {
      _state = LoadState.error;
    }
    notifyListeners();
  }
}
