/// How a product is naturally measured by the person eating it.
///
/// The My Day reference design groups every product into one of eight
/// forms, each with its own preset amounts, +/- step size and way of
/// saying the amount out loud ("2 tbsp", "1 packet", "6 biscuits").
enum FoodForm {
  /// Loose snacks measured by label serving / pack fractions.
  snack,

  /// Spoonable spreads (honey, Nutella) measured in tsp / tbsp.
  spread,

  /// Bottled drinks measured in glasses.
  drink,

  /// Scooped foods (dahi) measured in katoris.
  scoop,

  /// Dry foods cooked from packets (Maggi).
  cook,

  /// Counted pieces (biscuits).
  piece,

  /// Single-serve sachets (ketchup).
  sachet,

  /// Syrups counted by the concentrate poured, not the finished glass.
  concentrate,
}

/// One of the display strings the reference design localizes per product
/// form ("measured in spoons", "counted in biscuits (~8g each)", …).
enum FormWord {
  spoons,
  glasses,
  katoris,
  packetsDry,
  biscuits,
  sachets,
  concentrate,
  serving,
}

/// One of the amber caveats shown under the amount card for product
/// forms whose label would otherwise mislead (dry-weight noodles,
/// syrup concentrates, piece counting).
enum PortionCaveat { cook, concentrate, piece }

/// Nutrition declared per 100 g of the product (label basis).
class NutritionPer100 {
  const NutritionPer100({
    required this.sugarG,
    required this.sodiumMg,
    required this.saturatedFatG,
  });

  /// Total (or tracked free) sugar, grams per 100 g.
  final double sugarG;

  /// Sodium, milligrams per 100 g.
  ///
  /// Stored as sodium — never as salt. The UI labels it "Salt (sodium)"
  /// and compares it against the WHO sodium limit, so no salt-equivalent
  /// conversion is applied to these figures.
  final double sodiumMg;

  /// Saturated fat ("heavy fat" in the reference UI), grams per 100 g.
  final double saturatedFatG;

  factory NutritionPer100.fromJson(Map<String, dynamic> json) {
    return NutritionPer100(
      sugarG: (json['sugar_g'] as num?)?.toDouble() ?? 0,
      sodiumMg: (json['sodium_mg'] as num?)?.toDouble() ?? 0,
      saturatedFatG: (json['saturated_fat_g'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'sugar_g': sugarG,
    'sodium_mg': sodiumMg,
    'saturated_fat_g': saturatedFatG,
  };
}

/// A quick-pick portion preset shown as a chip on the amount screen.
///
/// Labels are technical unit expressions ("1 tbsp", "250ml", "2 pcs")
/// kept in English like the product names themselves; [grams] is the
/// density-converted truth used for nutrition maths.
class FoodPreset {
  const FoodPreset({
    required this.label,
    required this.sub,
    required this.grams,
  });

  final String label;
  final String sub;
  final double grams;
}

/// Household millilitre measures used by the reference design.
class HouseholdMeasures {
  HouseholdMeasures._();

  static const double tspMl = 5;
  static const double tbspMl = 15;
  static const double smallGlassMl = 150;
  static const double glassMl = 250;
  static const double katoriMl = 150;
  static const double halfKatoriMl = 75;
}

/// A catalog product with per-100 g nutrition and the portion logic for
/// its [form] (presets, step size, maximum, human-readable amount).
///
/// Portion maths is ported 1:1 from the HTML reference's `presetsFor`,
/// `stepFor`, `sayAmount`, `packSizeLabel`, `maxFor` and `defaultAmt`.
class FoodProduct {
  const FoodProduct({
    required this.id,
    required this.name,
    required this.icon,
    required this.form,
    required this.serveG,
    required this.per100,
    this.packG,
    this.packMl,
    this.density,
    this.doseMl,
    this.makesMl,
    this.packetG,
    this.pieceG,
    this.piecesPerPack,
    this.sachetG,
    this.sachets,
    this.freeSugarCorrected = false,
  });

  final String id;
  final String name;
  final String icon;
  final FoodForm form;

  /// Label single-serving size in grams (snack form's "1 serving").
  final double serveG;

  final NutritionPer100 per100;

  /// Pack net weight in grams (snack/spread/scoop/piece/sachet forms).
  final double? packG;

  /// Pack net volume in millilitres (drink/concentrate forms).
  final double? packMl;

  /// Grams per millilitre for volume-measured products.
  final double? density;

  /// Concentrate: millilitres of syrup per glass made.
  final double? doseMl;

  /// Concentrate: millilitres of finished drink one dose makes.
  final double? makesMl;

  /// Cook: dry weight of one packet in grams.
  final double? packetG;

  /// Piece: approximate weight of one piece in grams.
  final double? pieceG;

  /// Piece: how many pieces come in the pack.
  final int? piecesPerPack;

  /// Sachet: weight of one sachet in grams.
  final double? sachetG;

  /// Sachet: how many sachets come in the box.
  final int? sachets;

  /// True when the tracked sugar figure is total sugar because the
  /// product is a free sugar (honey, syrup, juice) whose label may
  /// declare 0 g *added* sugar. Mirrors the reference's corrected honey.
  final bool freeSugarCorrected;

  double get _d => density ?? 1;

  /// Which localized form-word line describes this product.
  FormWord get formWord => switch (form) {
    FoodForm.spread => FormWord.spoons,
    FoodForm.drink => FormWord.glasses,
    FoodForm.scoop => FormWord.katoris,
    FoodForm.cook => FormWord.packetsDry,
    FoodForm.piece => FormWord.biscuits,
    FoodForm.sachet => FormWord.sachets,
    FoodForm.concentrate => FormWord.concentrate,
    FoodForm.snack => FormWord.serving,
  };

  /// Amber caveat for forms whose raw label would mislead, else null.
  PortionCaveat? get caveat => switch (form) {
    FoodForm.cook => PortionCaveat.cook,
    FoodForm.concentrate => PortionCaveat.concentrate,
    FoodForm.piece => PortionCaveat.piece,
    _ => null,
  };

  /// Quick-pick presets: four chips per form, exactly as the reference.
  List<FoodPreset> get presets {
    final d = _d;
    switch (form) {
      case FoodForm.spread:
        final tbsp = HouseholdMeasures.tbspMl * d;
        final tsp = HouseholdMeasures.tspMl * d;
        return [
          FoodPreset(label: '1 tsp', sub: '${tsp.round()}g', grams: _f1(tsp)),
          FoodPreset(
            label: '1 tbsp',
            sub: '${tbsp.round()}g',
            grams: _f1(tbsp),
          ),
          FoodPreset(
            label: '2 tbsp',
            sub: '${(tbsp * 2).round()}g',
            grams: _f1(tbsp * 2),
          ),
          FoodPreset(
            label: '3 tbsp',
            sub: '${(tbsp * 3).round()}g',
            grams: _f1(tbsp * 3),
          ),
        ];
      case FoodForm.drink:
        return [
          FoodPreset(
            label: 'Small glass',
            sub: '150ml',
            grams: _f1(HouseholdMeasures.smallGlassMl * d),
          ),
          FoodPreset(
            label: '1 glass',
            sub: '250ml',
            grams: _f1(HouseholdMeasures.glassMl * d),
          ),
          FoodPreset(label: 'Can', sub: '330ml', grams: _f1(330 * d)),
          FoodPreset(label: '½ litre', sub: '500ml', grams: _f1(500 * d)),
        ];
      case FoodForm.cook:
        final packet = packetG ?? serveG;
        return [
          FoodPreset(
            label: '½ packet',
            sub: '${formatSize(packet * 0.5)}g',
            grams: _f1(packet * 0.5),
          ),
          FoodPreset(
            label: '1 packet',
            sub: '${formatSize(packet)}g',
            grams: _f1(packet),
          ),
          FoodPreset(
            label: '1½ packet',
            sub: '${formatSize(packet * 1.5)}g',
            grams: _f1(packet * 1.5),
          ),
          FoodPreset(
            label: '2 packets',
            sub: '${formatSize(packet * 2)}g',
            grams: _f1(packet * 2),
          ),
        ];
      case FoodForm.piece:
        final piece = pieceG ?? 1;
        return [
          FoodPreset(
            label: '2 pcs',
            sub: '${formatSize(piece * 2)}g',
            grams: _f1(piece * 2),
          ),
          FoodPreset(
            label: '4 pcs',
            sub: '${formatSize(piece * 4)}g',
            grams: _f1(piece * 4),
          ),
          FoodPreset(
            label: '6 pcs',
            sub: '${formatSize(piece * 6)}g',
            grams: _f1(piece * 6),
          ),
          FoodPreset(
            label: '10 pcs',
            sub: '${formatSize(piece * 10)}g',
            grams: _f1(piece * 10),
          ),
        ];
      case FoodForm.sachet:
        final sachet = sachetG ?? serveG;
        return [
          FoodPreset(
            label: '1 sachet',
            sub: '${formatSize(sachet)}g',
            grams: _f1(sachet),
          ),
          FoodPreset(
            label: '2 sachets',
            sub: '${formatSize(sachet * 2)}g',
            grams: _f1(sachet * 2),
          ),
          FoodPreset(
            label: '3 sachets',
            sub: '${formatSize(sachet * 3)}g',
            grams: _f1(sachet * 3),
          ),
          FoodPreset(
            label: '5 sachets',
            sub: '${formatSize(sachet * 5)}g',
            grams: _f1(sachet * 5),
          ),
        ];
      case FoodForm.concentrate:
        final dose = doseMl ?? serveG;
        return [
          FoodPreset(
            label: '1 glass',
            sub: '${formatSize(dose)}ml syrup',
            grams: _f1(dose * d),
          ),
          FoodPreset(
            label: '2 glasses',
            sub: '${formatSize(dose * 2)}ml',
            grams: _f1(dose * 2 * d),
          ),
          FoodPreset(
            label: '3 glasses',
            sub: '${formatSize(dose * 3)}ml',
            grams: _f1(dose * 3 * d),
          ),
          FoodPreset(
            label: 'Jug (1L)',
            sub: '150ml syrup',
            grams: _f1(150 * d),
          ),
        ];
      case FoodForm.scoop:
        return [
          FoodPreset(
            label: '½ katori',
            sub: '75ml',
            grams: _f1(HouseholdMeasures.halfKatoriMl * d),
          ),
          FoodPreset(
            label: '1 katori',
            sub: '150ml',
            grams: _f1(HouseholdMeasures.katoriMl * d),
          ),
          FoodPreset(
            label: '2 katori',
            sub: '300ml',
            grams: _f1(HouseholdMeasures.katoriMl * 2 * d),
          ),
          FoodPreset(
            label: 'Full pack',
            sub: '${formatSize(packG ?? serveG)}g',
            grams: _f1(packG ?? serveG),
          ),
        ];
      case FoodForm.snack:
        final pack = packG ?? serveG;
        return [
          FoodPreset(
            label: '1 serving',
            sub: '${formatSize(serveG)}g',
            grams: _f1(serveG),
          ),
          FoodPreset(
            label: '¼ pack',
            sub: '${(pack * 0.25).round()}g',
            grams: _f1(pack * 0.25),
          ),
          FoodPreset(
            label: '½ pack',
            sub: '${(pack * 0.5).round()}g',
            grams: _f1(pack * 0.5),
          ),
          FoodPreset(
            label: 'Full pack',
            sub: '${formatSize(pack)}g',
            grams: _f1(pack),
          ),
        ];
    }
  }

  /// Grams added or removed by one +/- tap.
  double get step {
    switch (form) {
      case FoodForm.spread:
        return _f1(_d * HouseholdMeasures.tspMl);
      case FoodForm.drink:
        return _f1(_d * 50);
      case FoodForm.cook:
        return _f1((packetG ?? serveG) * 0.5);
      case FoodForm.piece:
        return pieceG ?? 1;
      case FoodForm.sachet:
        return sachetG ?? serveG;
      case FoodForm.concentrate:
        return _f1(_d * (doseMl ?? serveG));
      case FoodForm.scoop:
        return _f1(_d * HouseholdMeasures.halfKatoriMl);
      case FoodForm.snack:
        return 5;
    }
  }

  /// Upper bound: one full pack (or five packets for cook products).
  double get maxAmount {
    switch (form) {
      case FoodForm.drink:
      case FoodForm.concentrate:
        return _f1((packMl ?? 0) * _d);
      case FoodForm.cook:
        return (packetG ?? serveG) * 5;
      case FoodForm.sachet:
        return (sachetG ?? serveG) * (sachets ?? 1);
      default:
        return packG ?? serveG;
    }
  }

  /// The amount a first-time user lands on (second preset chip).
  double get defaultAmount => presets[1].grams;

  /// Says the amount the way a person would, plus the gram truth
  /// shown underneath ("2.5 tbsp" / "39 g counted").
  String sayAmount(double g) {
    switch (form) {
      case FoodForm.spread:
        final tbsp = g / (HouseholdMeasures.tbspMl * _d);
        return tbsp >= 0.95
            ? '${_half(tbsp)} tbsp'
            : '${_half(g / (HouseholdMeasures.tspMl * _d))} tsp';
      case FoodForm.drink:
        return '${(g / _d).round()} ml';
      case FoodForm.cook:
        final pk = g / (packetG ?? serveG);
        return '${_half(pk)} packet${pk > 1 ? 's' : ''}';
      case FoodForm.piece:
        return '${(g / (pieceG ?? 1)).round()} biscuits';
      case FoodForm.sachet:
        final sc = (g / (sachetG ?? serveG)).round();
        return '$sc sachet${sc > 1 ? 's' : ''}';
      case FoodForm.concentrate:
        final gl = g / ((doseMl ?? serveG) * _d);
        return '${_half(gl)} glass${gl > 1 ? 'es' : ''} made';
      case FoodForm.scoop:
        return '${_half(g / (HouseholdMeasures.katoriMl * _d))} katori';
      case FoodForm.snack:
        return '${formatSize((g / serveG * 10).roundToDouble() / 10)} servings';
    }
  }

  /// Pack-size line shown in the card meta ("400g pack", "5L bottle").
  String get packSizeLabel {
    switch (form) {
      case FoodForm.drink:
        final ml = packMl ?? 0;
        final size = ml >= 1000
            ? '${formatSize(ml / 1000)}L'
            : '${formatSize(ml)}ml';
        return '$size bottle';
      case FoodForm.concentrate:
        return '${formatSize((packMl ?? 0) / 1000)}L syrup bottle';
      case FoodForm.cook:
        return '${formatSize(packetG ?? serveG)}g packet';
      case FoodForm.sachet:
        return '${sachets ?? 1} sachets in box';
      case FoodForm.piece:
        return '${formatSize(packG ?? serveG)}g pack · ~${piecesPerPack ?? 1} pcs';
      default:
        return '${formatSize(packG ?? serveG)}g pack';
    }
  }

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    return FoodProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '📦',
      form: FoodForm.values.firstWhere(
        (f) => f.name == json['form'],
        orElse: () => FoodForm.snack,
      ),
      serveG: (json['serve_g'] as num?)?.toDouble() ?? 100,
      per100: NutritionPer100.fromJson(
        (json['per_100'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      packG: (json['pack_g'] as num?)?.toDouble(),
      packMl: (json['pack_ml'] as num?)?.toDouble(),
      density: (json['density'] as num?)?.toDouble(),
      doseMl: (json['dose_ml'] as num?)?.toDouble(),
      makesMl: (json['makes_ml'] as num?)?.toDouble(),
      packetG: (json['packet_g'] as num?)?.toDouble(),
      pieceG: (json['piece_g'] as num?)?.toDouble(),
      piecesPerPack: (json['pieces_per_pack'] as num?)?.toInt(),
      sachetG: (json['sachet_g'] as num?)?.toDouble(),
      sachets: (json['sachets'] as num?)?.toInt(),
      freeSugarCorrected: json['free_sugar_corrected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'form': form.name,
    'serve_g': serveG,
    'per_100': per100.toJson(),
    if (packG != null) 'pack_g': packG,
    if (packMl != null) 'pack_ml': packMl,
    if (density != null) 'density': density,
    if (doseMl != null) 'dose_ml': doseMl,
    if (makesMl != null) 'makes_ml': makesMl,
    if (packetG != null) 'packet_g': packetG,
    if (pieceG != null) 'piece_g': pieceG,
    if (piecesPerPack != null) 'pieces_per_pack': piecesPerPack,
    if (sachetG != null) 'sachet_g': sachetG,
    if (sachets != null) 'sachets': sachets,
    if (freeSugarCorrected) 'free_sugar_corrected': freeSugarCorrected,
  };

  /// Rounds to one decimal like the reference's `toFixed(1)`.
  static double _f1(double v) => double.parse(v.toStringAsFixed(1));

  /// Formats a size without a trailing ".0" ("400" not "400.0").
  static String formatSize(double v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toString();

  /// Rounds to the nearest half ("1.5 packet") without a trailing ".0".
  static String _half(double v) => formatSize(((v * 2).round() / 2));
}
