import '../model/food_product.dart';

/// The My Day food catalog from the HTML reference — ten demo products
/// with per-100 g nutrition derived from the label extraction figures.
///
/// Swapping this for a real API later means implementing
/// `MyDayRepository.fetchCatalog()` against the backend; nothing else
/// in the feature reads this file directly.
class FoodCatalogFixtures {
  FoodCatalogFixtures._();

  static List<FoodProduct> all() => const [
    FoodProduct(
      id: 'chana',
      name: 'Real Bites Chana Jor Garam',
      icon: '🥜',
      form: FoodForm.snack,
      packG: 400,
      serveG: 28.34,
      per100: NutritionPer100(
        sugarG: 0.0,
        sodiumMg: 555.0,
        saturatedFatG: 10.10,
      ),
    ),
    FoodProduct(
      id: 'nutella',
      name: 'Nutella Hazelnut Spread',
      icon: '🍫',
      form: FoodForm.spread,
      packG: 350,
      serveG: 15,
      density: 1.25,
      per100: NutritionPer100(
        sugarG: 49.83,
        sodiumMg: 42.29,
        saturatedFatG: 10.63,
      ),
    ),
    FoodProduct(
      id: 'honey',
      name: 'Dabur Honey',
      icon: '🍯',
      form: FoodForm.spread,
      packG: 100,
      serveG: 21,
      density: 1.42,
      freeSugarCorrected: true,
      per100: NutritionPer100(
        sugarG: 82.0,
        sodiumMg: 16.67,
        saturatedFatG: 0.0,
      ),
    ),
    FoodProduct(
      id: 'kurkure',
      name: 'Kurkure Green Chutney',
      icon: '🌶️',
      form: FoodForm.snack,
      packG: 78.9,
      serveG: 20,
      per100: NutritionPer100(
        sugarG: 1.14,
        sodiumMg: 839.04,
        saturatedFatG: 15.84,
      ),
    ),
    FoodProduct(
      id: 'thumsup',
      name: 'Thums Up',
      icon: '🥤',
      form: FoodForm.drink,
      packMl: 5000,
      serveG: 260,
      density: 1.04,
      per100: NutritionPer100(sugarG: 11.2, sodiumMg: 8.0, saturatedFatG: 0.0),
    ),
    FoodProduct(
      id: 'curd',
      name: 'Amul Masti Dahi',
      icon: '🥣',
      form: FoodForm.scoop,
      packG: 400,
      serveG: 100,
      density: 1.03,
      per100: NutritionPer100(sugarG: 3.2, sodiumMg: 46.0, saturatedFatG: 2.1),
    ),
    FoodProduct(
      id: 'maggi',
      name: 'Maggi 2-Minute Noodles',
      icon: '🍜',
      form: FoodForm.cook,
      packetG: 70,
      serveG: 70,
      per100: NutritionPer100(
        sugarG: 3.5,
        sodiumMg: 1230.0,
        saturatedFatG: 6.9,
      ),
    ),
    FoodProduct(
      id: 'biscuit',
      name: 'Patanjali Doodh Biscuits',
      icon: '🍪',
      form: FoodForm.piece,
      packG: 800,
      pieceG: 8,
      piecesPerPack: 100,
      serveG: 8,
      per100: NutritionPer100(
        sugarG: 24.1,
        sodiumMg: 352.6,
        saturatedFatG: 8.08,
      ),
    ),
    FoodProduct(
      id: 'ketchup',
      name: 'Kissan Ketchup sachet',
      icon: '🥫',
      form: FoodForm.sachet,
      sachetG: 8,
      sachets: 20,
      serveG: 8,
      per100: NutritionPer100(
        sugarG: 23.0,
        sodiumMg: 850.0,
        saturatedFatG: 0.1,
      ),
    ),
    FoodProduct(
      id: 'roohafza',
      name: 'Rooh Afza syrup',
      icon: '🧃',
      form: FoodForm.concentrate,
      packMl: 750,
      doseMl: 30,
      makesMl: 200,
      serveG: 39,
      density: 1.30,
      per100: NutritionPer100(sugarG: 68.0, sodiumMg: 22.0, saturatedFatG: 0.0),
    ),
  ];
}
