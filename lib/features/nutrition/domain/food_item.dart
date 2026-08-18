import 'package:equatable/equatable.dart';

/// One entry from the food dataset — nutrition values are PER SERVING
/// (defined by [servingLabel]/[servingGrams]), scaled by quantity when
/// actually logged (see `FoodLogEntry` in nutrition_data.dart).
class FoodItem extends Equatable {
  const FoodItem({
    required this.id,
    required this.name,
    required this.servingLabel,
    required this.servingGrams,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String id;
  final String name;
  final String servingLabel; // e.g. "100 g", "1 cup", "1 medium"
  final double servingGrams;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  @override
  List<Object?> get props => [id, name, servingLabel, servingGrams, calories, proteinG, carbsG, fatG];
}
