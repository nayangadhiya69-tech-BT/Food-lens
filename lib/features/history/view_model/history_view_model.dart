import 'package:flutter/foundation.dart';

import '../../../core/models/load_state.dart';
import '../model/scan_record.dart';
import '../repository/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel(this._repository);

  final HistoryRepository _repository;

  LoadState _state = LoadState.loading;
  List<ScanRecord> _records = const [];

  LoadState get state => _state;
  List<ScanRecord> get records => _records;
  bool get isEmpty => _state == LoadState.success && _records.isEmpty;

  Future<void> load() async {
    _state = LoadState.loading;
    notifyListeners();
    try {
      _records = await _repository.fetchHistory();
      _state = LoadState.success;
    } catch (_) {
      _state = LoadState.error;
    }
    notifyListeners();
  }
}
