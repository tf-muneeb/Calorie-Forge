import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_entry_model.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class MealBreakdownBar extends StatelessWidget {
  final Map<MealType, double> caloriesByMeal;
  final double totalCalories;

  const MealBreakdownBar({
    super.key,
    required this.caloriesByMeal,
    required this.totalCalories,
  });

  Color _getMealColor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return const Color(0xFFFBBF24);
      case MealType.lunch:
        return const Color(0xFF22C55E);
      case MealType.dinner:
        return const Color(0xFF3B82F6);
      case MealType.snack:
        return const Color(0xFFA855F7);
    }
  }

  String _getMealLabel(MealType type) {
    switch (type) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                color: colors.accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Meal Breakdown',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (totalCalories > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: MealType.values.map((type) {
                    final cals = caloriesByMeal[type] ?? 0;
                    if (cals <= 0) return const SizedBox.shrink();
                    final fraction = cals / totalCalories;
                    return Expanded(
                      flex: (fraction * 1000).toInt().clamp(1, 1000),
                      child: Container(color: _getMealColor(type)),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...MealType.values.map((type) {
            final cals = caloriesByMeal[type] ?? 0;
            final percentage = totalCalories > 0
                ? ((cals / totalCalories) * 100).toStringAsFixed(0)
                : '0';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getMealColor(type),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _getMealLabel(type),
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '${cals.toStringAsFixed(0)} kcal',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '$percentage%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: colors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}