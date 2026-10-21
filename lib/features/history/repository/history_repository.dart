import '../model/scan_record.dart';

/// Contract for reading scan history.
///
/// The demo uses [MockHistoryRepository]; a future API implementation only
/// needs to implement this interface and be registered in
/// `core/di/app_providers.dart`.
abstract class HistoryRepository {
  Future<List<ScanRecord>> fetchHistory();
}
