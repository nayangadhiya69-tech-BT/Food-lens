import 'package:flutter/foundation.dart';

import '../../../core/models/load_state.dart';
import '../domain/nutrition_calculator.dart';
import '../model/daily_limit.dart';
import '../model/food_product.dart';
import '../model/my_day_entry.dart';
import '../model/nutrient_totals.dart';
import '../repository/my_day_repository.dart';

/// Where the user is inside the My Day flow.
///
/// The steps swap inside the tab (the shell keeps the branch alive), so
/// selections, amounts and totals survive tab switches and back
/// navigation exactly like the HTML reference's view state machine.
enum MyDayStep { pick, amounts, summary }

/// Owns the whole My Day flow: catalog, selection, draft amounts, saved
/// entries for today, and navigation between the three steps.
///
/// State rules (mirroring the reference):
/// * Saved entries are the source of truth for the summary and Home.
/// * Confirming a selection merges today's saved entries (grams kept)
///   with newly picked products (default grams) — never duplicated.
/// * Calculating replaces the day atomically through the repository.
class MyDayViewModel extends ChangeNotifier {
  MyDayViewModel(this._repository, {DateTime? now})
    : _now = now ?? DateTime.now();

  final MyDayRepository _repository;

  /// The calendar day being edited. Injectable for deterministic tests.
  final DateTime _now;

  LoadState _state = LoadState.loading;
  MyDayStep _step = MyDayStep.pick;
  List<FoodProduct> _catalog = const [];
  List<MyDayEntry> _entries = const [];
  final Set<String> _pickedIds = <String>{};
  final Map<String, double> _amounts = <String, double>{};
  bool _saving = false;
  bool _loaded = false;

  LoadState get state => _state;
  MyDayStep get step => _step;
  bool get isSaving => _saving;
  List<FoodProduct> get catalog => _catalog;
  List<MyDayEntry> get entries => List.unmodifiable(_entries);
  Set<String> get pickedIds => Set.unmodifiable(_pickedIds);
  int get pickedCount => _pickedIds.length;

  /// Draft grams on the amount step, in insertion order
  /// (today's saved entries first, then newly picked products).
  Map<String, double> get amounts => Map.unmodifiable(_amounts);

  bool get hasEntries => _entries.isNotEmpty;

  FoodProduct? productById(String id) {
    for (final product in _catalog) {
      if (product.id == id) return product;
    }
    return null;
  }

  double? amountOf(String productId) => _amounts[productId];

  /// Today's saved totals — the single figure set shared with Home.
  NutrientTotals get dayTotals => NutritionCalculator.aggregateEntries(
    entries: _entries,
    productsById: {for (final product in _catalog) product.id: product},
  );

  /// Home-dashboard view of [dayTotals]: null while nothing is logged
  /// today, so the dashboard hides its nutrition section entirely.
  NutrientTotals? get todayTotals => _entries.isEmpty ? null : dayTotals;

  /// Limit progress for [todayTotals]; empty while nothing is logged.
  List<LimitProgress> get todayLimits => hasEntries ? limitProgress : const [];

  /// Progress of today's totals against each WHO reference limit.
  List<LimitProgress> get limitProgress =>
      NutritionCalculator.limitsFor(dayTotals);

  /// True when a saved entry is a corrected free-sugar product (honey),
  /// so the summary can explain the correction instead of hiding it.
  bool get hasFreeSugarCorrection => _entries.any(
    (entry) => productById(entry.productId)?.freeSugarCorrected ?? false,
  );

  Future<void> load() async {
    if (_loaded && _state == LoadState.success) return;
    _state = LoadState.loading;
    notifyListeners();
    try {
      final results = await Future.wait<Object>([
        _repository.fetchCatalog(),
        _repository.fetchEntries(_now),
      ]);
      _catalog = results[0] as List<FoodProduct>;
      _entries = results[1] as List<MyDayEntry>;
      _state = LoadState.success;
      _loaded = true;
      // Every open lands on "Add to today" (the flow's default step);
      // today's saved items come pre-checked with their grams so Parse
      // and Add to List keeps them verbatim.
      _step = MyDayStep.pick;
      if (_entries.isNotEmpty) {
        _pickedIds
          ..clear()
          ..addAll(_entries.map((entry) => entry.productId));
        _amounts
          ..clear()
          ..addAll({
            for (final entry in _entries) entry.productId: entry.amountG,
          });
      }
      notifyListeners();
    } catch (_) {
      _state = LoadState.error;
      notifyListeners();
    }
  }

  bool isPicked(String productId) => _pickedIds.contains(productId);

  void togglePick(String productId) {
    if (!_pickedIds.remove(productId)) {
      _pickedIds.add(productId);
    }
    notifyListeners();
  }

  /// "Parse and Add to List": validates the selection and moves to the
  /// amount step. Only items still checked on Add to today take part —
  /// an unchecked (removed) item never reappears with a stale quantity,
  /// even when it has a saved amount for today. Returns false when
  /// nothing is selected.
  bool confirmSelection() {
    if (_pickedIds.isEmpty) return false;
    final savedGrams = {
      for (final entry in _entries) entry.productId: entry.amountG,
    };
    final merged = <String, double>{};
    for (final id in _pickedIds) {
      final product = productById(id);
      if (product == null) continue;
      merged[id] = savedGrams[id] ?? product.defaultAmount;
    }
    _amounts
      ..clear()
      ..addAll(merged);
    _step = MyDayStep.amounts;
    notifyListeners();
    return true;
  }

  /// Updates one product's grams independently of every other card.
  /// Returns false when the value is invalid for that product.
  bool setAmount(String productId, double grams) {
    final product = productById(productId);
    if (product == null) return false;
    if (!grams.isFinite || grams <= 0 || grams > product.maxAmount) {
      return false;
    }
    _amounts[productId] = double.parse(grams.toStringAsFixed(1));
    notifyListeners();
    return true;
  }

  /// One +/- tap: clamps between zero and the product's pack maximum,
  /// exactly like the reference's `bump`.
  void bumpAmount(String productId, double delta) {
    final current = _amounts[productId];
    final product = productById(productId);
    if (current == null || product == null) return;
    var next = current + delta;
    if (next < 0) next = 0;
    if (next > product.maxAmount) next = product.maxAmount;
    _amounts[productId] = double.parse(next.toStringAsFixed(1));
    notifyListeners();
  }

  /// "Calculate My Day": validates every amount, persists the day
  /// atomically and moves to the summary. Returns false on validation
  /// or persistence failure (the view shows the right message).
  Future<bool> calculateDay() async {
    if (_amounts.isEmpty) return false;
    for (final productId in _amounts.keys) {
      final grams = _amounts[productId]!;
      if (!grams.isFinite || grams <= 0) return false;
    }
    _saving = true;
    notifyListeners();
    final nextEntries = [
      for (final amount in _amounts.entries)
        MyDayEntry(productId: amount.key, amountG: amount.value),
    ];
    final saved = await _repository.saveEntries(_now, nextEntries);
    if (saved) {
      _entries = nextEntries;
      _step = MyDayStep.summary;
    }
    _saving = false;
    notifyListeners();
    return saved;
  }

  /// Removes one line from the day (and the pick selection), persisting
  /// immediately so Home never shows stale totals. Returns false when
  /// persistence failed (the in-memory day is still updated).
  Future<bool> removeEntry(String productId) async {
    _entries = [
      for (final entry in _entries)
        if (entry.productId != productId) entry,
    ];
    _amounts.remove(productId);
    _pickedIds.remove(productId);
    final saved = await _repository.saveEntries(_now, _entries);
    notifyListeners();
    return saved;
  }

  /// "Add Another Item" (summary and empty states): back to the pick
  /// step with today's items still checked and everything saved.
  void goToPick() {
    _step = MyDayStep.pick;
    notifyListeners();
  }

  /// Header back on the amount step.
  void backToPick() {
    _step = MyDayStep.pick;
    notifyListeners();
  }

  /// Header back on the summary: reload saved grams into the draft so
  /// editing after a calculation starts from the persisted values.
  void backToAmounts() {
    _amounts
      ..clear()
      ..addAll({for (final entry in _entries) entry.productId: entry.amountG});
    _step = MyDayStep.amounts;
    notifyListeners();
  }
}
