import 'package:equatable/equatable.dart';

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeLabel on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }
}

/// One logged food item — contributes to the day's macro totals.
class FoodLogEntry extends Equatable {
  const FoodLogEntry({
    required this.name,
    required this.mealType,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String name;
  final MealType mealType;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  @override
  List<Object?> get props => [name, mealType, calories, proteinG, carbsG, fatG];
}

/// Fixed, ordered list of micronutrients tracked — matches the mockup's
/// exact row order. Kept as a plain ordered list (rather than an
/// unordered Map key set) so the UI never has to guess display order.
const List<String> kMicroNutrientOrder = [
  'Iron',
  'Potassium',
  'Magnesium',
  'Sodium',
  'Calcium',
  'Vitamin D',
  'Vitamin B9',
  'Vitamin B6',
  'Vitamin A',
  'Vitamin C',
  'Vitamin E',
  'Vitamin K',
  'Vitamin B1 (Thiamine)',
  'Vitamin B3 (Niacin)',
];

class NutritionData extends Equatable {
  const NutritionData({
    required this.date,
    required this.foodLog,
    required this.supplements,
    required this.microNutrients,
    this.microNutrientsExpanded = true,
  });

  final DateTime date;
  final List<FoodLogEntry> foodLog;
  final List<String> supplements;

  /// Keys are always exactly [kMicroNutrientOrder] — see
  /// [MockNutritionRepository] for the seeded zeroed map.
  final Map<String, double> microNutrients;

  final bool microNutrientsExpanded;

  int get totalCalories => foodLog.fold(0, (sum, e) => sum + e.calories);
  double get totalProteinG => foodLog.fold(0, (sum, e) => sum + e.proteinG);
  double get totalCarbsG => foodLog.fold(0, (sum, e) => sum + e.carbsG);
  double get totalFatG => foodLog.fold(0, (sum, e) => sum + e.fatG);

  NutritionData copyWith({
    DateTime? date,
    List<FoodLogEntry>? foodLog,
    List<String>? supplements,
    Map<String, double>? microNutrients,
    bool? microNutrientsExpanded,
  }) {
    return NutritionData(
      date: date ?? this.date,
      foodLog: foodLog ?? this.foodLog,
      supplements: supplements ?? this.supplements,
      microNutrients: microNutrients ?? this.microNutrients,
      microNutrientsExpanded: microNutrientsExpanded ?? this.microNutrientsExpanded,
    );
  }

  @override
  List<Object?> get props => [date, foodLog, supplements, microNutrients, microNutrientsExpanded];
}
