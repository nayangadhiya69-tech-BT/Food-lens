import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/core/models/health_flag.dart';
import 'package:foodlens/features/scan/model/scan_mode.dart';
import 'package:foodlens/features/scan/repository/mock_scan_repository.dart';

void main() {
  group('MockScanRepository', () {
    test('friendly flags are the selected flags the product suits', () async {
      final repo = MockScanRepository(latency: Duration.zero);

      final jainResult = await repo.analyze(
        mode: ScanMode.barcode,
        flags: const <HealthFlag>{HealthFlag.jain},
      );

      expect(jainResult.friendlyFlags, contains(HealthFlag.jain));
    });

    test('health flags the product does not suit are not friendly', () async {
      final repo = MockScanRepository(latency: Duration.zero);

      final diabetesResult = await repo.analyze(
        mode: ScanMode.barcode,
        flags: const <HealthFlag>{HealthFlag.diabetes},
      );

      expect(diabetesResult.friendlyFlags, isEmpty);
    });
  });
}
