import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../application/food_search_providers.dart';
import '../../domain/food_item.dart';
import '../../domain/nutrition_data.dart';

/// Search bar + live results list for logging a meal, replacing the
/// original manual "type in calories/protein/carbs/fat yourself" flow —
/// results come from the food dataset (currently a small mock; see
/// `MockFoodSearchRepository`'s TODO for swapping in the real one).
///
/// Selecting a result opens a small serving-quantity confirmation before
/// actually logging it, since dataset nutrition values are per-serving
/// and a real entry might be e.g. "1.5 servings".
class FoodSearchSection extends ConsumerStatefulWidget {
  const FoodSearchSection({
    super.key,
    required this.mealType,
    required this.onFoodSelected,
  });

  /// Which meal the logged item should be tagged with — passed in from
  /// the "Meal type" selector above this section.
  final MealType mealType;
  final ValueChanged<FoodLogEntry> onFoodSelected;

  @override
  ConsumerState<FoodSearchSection> createState() => _FoodSearchSectionState();
}

class _FoodSearchSectionState extends ConsumerState<FoodSearchSection> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectFood(FoodItem food) async {
    final entry = await showModalBottomSheet<FoodLogEntry>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ServingQuantitySheet(food: food, mealType: widget.mealType),
    );
    if (entry != null) {
      widget.onFoodSelected(entry);
      _searchController.clear();
      ref.read(foodSearchControllerProvider.notifier).clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(foodSearchControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGreyFill,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            style: AppTextStyles.inputValue,
            onChanged: (value) => ref.read(foodSearchControllerProvider.notifier).updateQuery(value),
            decoration: InputDecoration(
              hintText: 'Search food to log (e.g. "chicken breast")',
              hintStyle: AppTextStyles.hint,
              prefixIcon: const Icon(Icons.search, color: AppColors.inputText, size: 20),
              suffixIcon: searchState.query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(foodSearchControllerProvider.notifier).clear();
                      },
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (searchState.isSearching) ...[
          const SizedBox(height: 12),
          const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator())),
        ] else if (searchState.query.isNotEmpty && searchState.results.isEmpty) ...[
          const SizedBox(height: 12),
          Text('No matches for "${searchState.query}"', style: AppTextStyles.hint),
        ] else if (searchState.results.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...searchState.results.map((food) => _FoodResultTile(food: food, onTap: () => _selectFood(food))),
        ],
      ],
    );
  }
}

class _FoodResultTile extends StatelessWidget {
  const _FoodResultTile({required this.food, required this.onTap});

  final FoodItem food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name, style: AppTextStyles.inputValue.copyWith(fontSize: 15)),
                  Text(
                    '${food.servingLabel} · ${food.calories} kcal',
                    style: AppTextStyles.hint.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
            const Icon(Icons.add_circle_outline, color: AppColors.accentColor, size: 22),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet shown after tapping a search result — lets the user
/// adjust how many servings before actually logging it.
class _ServingQuantitySheet extends StatefulWidget {
  const _ServingQuantitySheet({required this.food, required this.mealType});

  final FoodItem food;
  final MealType mealType;

  @override
  State<_ServingQuantitySheet> createState() => _ServingQuantitySheetState();
}

class _ServingQuantitySheetState extends State<_ServingQuantitySheet> {
  double _servings = 1;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food.name, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 4),
            Text('${food.servingLabel} per serving', style: AppTextStyles.hint),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Servings', style: AppTextStyles.chipLabel),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _servings > 0.5
                          ? () => setState(() => _servings = (_servings - 0.5).clamp(0.5, 20))
                          : null,
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        _servings.toStringAsFixed(_servings % 1 == 0 ? 0 : 1),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _servings = (_servings + 0.5).clamp(0.5, 20)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${(food.calories * _servings).round()} kcal · '
              '${(food.proteinG * _servings).toStringAsFixed(1)}g protein · '
              '${(food.carbsG * _servings).toStringAsFixed(1)}g carbs · '
              '${(food.fatG * _servings).toStringAsFixed(1)}g fat',
              style: AppTextStyles.hint.copyWith(fontSize: 12.5),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Log ${food.name}',
              showArrow: false,
              onPressed: () => Navigator.pop(
                context,
                FoodLogEntry(
                  name: food.name,
                  mealType: widget.mealType,
                  calories: (food.calories * _servings).round(),
                  proteinG: food.proteinG * _servings,
                  carbsG: food.carbsG * _servings,
                  fatG: food.fatG * _servings,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
