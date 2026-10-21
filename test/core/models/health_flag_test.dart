import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/core/models/health_flag.dart';

void main() {
  group('HealthFlag.toggle', () {
    test('selecting a normal flag adds it and clears "none"', () {
      final next = HealthFlag.toggle(
        {HealthFlag.none},
        HealthFlag.diabetes,
      );
      expect(next, {HealthFlag.diabetes});
    });

    test('deselecting a normal flag removes it', () {
      final next = HealthFlag.toggle(
        {HealthFlag.diabetes, HealthFlag.cholesterol},
        HealthFlag.diabetes,
      );
      expect(next, {HealthFlag.cholesterol});
    });

    test('selecting "none" clears every other flag', () {
      final next = HealthFlag.toggle(
        {HealthFlag.diabetes, HealthFlag.pregnancy},
        HealthFlag.none,
      );
      expect(next, {HealthFlag.none});
    });

    test('deselecting "none" leaves an empty set', () {
      final next = HealthFlag.toggle({HealthFlag.none}, HealthFlag.none);
      expect(next, isEmpty);
    });

    test('toggling the same normal flag twice returns to the start', () {
      var selected = <HealthFlag>{};
      selected = HealthFlag.toggle(selected, HealthFlag.bloodPressure);
      selected = HealthFlag.toggle(selected, HealthFlag.bloodPressure);
      expect(selected, isEmpty);
    });
  });

  group('HealthFlag key round-trip', () {
    test('toKeys/fromKeys preserve membership', () {
      const flags = {HealthFlag.diabetes, HealthFlag.none};
      expect(HealthFlag.fromKeys(HealthFlag.toKeys(flags)), flags);
    });

    test('unknown keys are ignored', () {
      final flags = HealthFlag.fromKeys(['diabetes', 'not_a_flag']);
      expect(flags, {HealthFlag.diabetes});
    });
  });
}
