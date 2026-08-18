import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../application/nutrition_providers.dart';
import '../domain/nutrition_data.dart';
import 'widgets/entry_row.dart';
import 'widgets/food_search_section.dart';
import 'widgets/macro_stat_card.dart';
import 'widgets/micro_nutrient_list.dart';

/// Nested under the Home branch of the persistent shell — inherits the
/// bottom nav + expandable "+" FAB from `HomeShell` automatically, same
/// pattern as Water Intake / Workout.
class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  Future<void> _pickMealType(BuildContext context, WidgetRef ref) async {
    final selected = await showModalBottomSheet<MealType>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: MealType.values
              .map((type) => ListTile(
                    title: Text(type.label, style: AppTextStyles.inputValue),
                    onTap: () => Navigator.pop(context, type),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      ref.read(pendingMealTypeProvider.notifier).state = selected;
    }
  }

  Future<void> _addSupplement(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Supplement'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'e.g. Omega-3')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      ref.read(nutritionControllerProvider.notifier).addSupplement(name);
    }
  }

  Future<void> _editMicroNutrient(BuildContext context, WidgetRef ref, String nutrient, double current) async {
    final controller = TextEditingController(text: current == 0 ? '' : current.toString());
    final value = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(nutrient),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Value'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, double.tryParse(controller.text.trim()) ?? 0),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (value != null) {
      ref.read(nutritionControllerProvider.notifier).updateMicroNutrient(nutrient, value);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(nutritionControllerProvider);
    final controller = ref.read(nutritionControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          Expanded(
            child: asyncData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: TextButton(onPressed: controller.refresh, child: const Text('Couldn\'t load — tap to retry')),
              ),
              data: (data) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nutrition Tracker', style: AppTextStyles.hint),
                    const SizedBox(height: 4),
                    Text('Meals & Macros', style: AppTextStyles.pageHeading.copyWith(color: AppColors.inputText)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: MacroStatCard(
                            icon: Icons.eco_outlined,
                            label: 'CALORIES',
                            value: '${data.totalCalories}',
                            unit: 'kcal',
                            accentColor: AppColors.greenText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MacroStatCard(
                            icon: Icons.bolt_outlined,
                            label: 'PROTEIN',
                            value: data.totalProteinG.toStringAsFixed(0),
                            unit: 'g',
                            accentColor: AppColors.scoreRingGreenDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: MacroStatCard(
                            icon: Icons.bakery_dining_outlined,
                            label: 'CARBS',
                            value: data.totalCarbsG.toStringAsFixed(0),
                            unit: 'g',
                            accentColor: AppColors.chipSelectedOrange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MacroStatCard(
                            icon: Icons.water_drop_outlined,
                            label: 'FAT',
                            value: data.totalFatG.toStringAsFixed(0),
                            unit: 'g',
                            accentColor: AppColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text('TODAY\'S MEALS', style: AppTextStyles.sectionLabel),
                    const SizedBox(height: 6),
                    EntryRow(
                      label: 'Meal type',
                      trailing: ref.watch(pendingMealTypeProvider)?.label ?? 'Select',
                      onTap: () => _pickMealType(context, ref),
                      showDivider: false,
                    ),
                    const SizedBox(height: 14),
                    FoodSearchSection(
                      mealType: ref.watch(pendingMealTypeProvider) ?? MealType.snack,
                      onFoodSelected: (entry) => controller.logFoodItem(entry),
                    ),
                    if (data.foodLog.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...data.foodLog.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${entry.name} · ${entry.mealType.label}',
                                  style: AppTextStyles.hint.copyWith(fontSize: 13),
                                ),
                                Text('${entry.calories} kcal', style: AppTextStyles.hint.copyWith(fontSize: 13)),
                              ],
                            ),
                          )),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SUPPLEMENTS', style: AppTextStyles.sectionLabel),
                        TextButton(
                          onPressed: () => _addSupplement(context, ref),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            '+ Add',
                            style: AppTextStyles.chipLabel.copyWith(
                              color: AppColors.greenText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (data.supplements.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: data.supplements
                            .map((s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreyFill,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(s, style: AppTextStyles.chipLabel),
                                ))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    MicroNutrientList(
                      values: data.microNutrients,
                      expanded: data.microNutrientsExpanded,
                      onToggleExpanded: controller.toggleMicroNutrientsExpanded,
                      onEditNutrient: (nutrient) =>
                          _editMicroNutrient(context, ref, nutrient, data.microNutrients[nutrient] ?? 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
