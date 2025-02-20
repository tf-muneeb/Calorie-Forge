import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_entry_model.dart';
import '../models/workout_entry_model.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class FoodListItem extends StatelessWidget {
  final FoodEntryModel entry;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const FoodListItem({
    super.key,
    required this.entry,
    this.onDelete,
    this.onTap,
  });

  Color _getMealColor() {
    switch (entry.mealType) {
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

  IconData _getMealIcon() {
    switch (entry.mealType) {
      case MealType.breakfast:
        return Icons.wb_sunny_rounded;
      case MealType.lunch:
        return Icons.restaurant_rounded;
      case MealType.dinner:
        return Icons.nights_stay_rounded;
      case MealType.snack:
        return Icons.cookie_rounded;
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final isDark = context.read<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          'Remove Food Entry?',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${entry.name}" (${entry.calories.toStringAsFixed(0)} kcal)?',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Remove',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && onDelete != null) {
      onDelete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final mealColor = _getMealColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: mealColor.withOpacity(0.1),
        highlightColor: mealColor.withOpacity(0.05),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: mealColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getMealIcon(),
                  color: mealColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: mealColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.mealTypeLabel,
                        style: TextStyle(
                          color: mealColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: colors.textTertiary,
                          size: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          entry.formattedTime,
                          style: TextStyle(
                            color: colors.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                        if (entry.protein > 0) ...[
                          const SizedBox(width: 10),
                          Icon(
                            Icons.egg_outlined,
                            color: colors.textTertiary,
                            size: 11,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${entry.protein.toStringAsFixed(1)}g protein',
                            style: TextStyle(
                              color: colors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entry.calories.toStringAsFixed(0),
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'kcal',
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _confirmDelete(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFFEF4444),
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutListItem extends StatelessWidget {
  final WorkoutEntryModel entry;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const WorkoutListItem({
    super.key,
    required this.entry,
    this.onDelete,
    this.onTap,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final isDark = context.read<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          'Remove Workout?',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${entry.exerciseName}" (${entry.caloriesBurned.toStringAsFixed(0)} kcal burned)?',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Remove',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && onDelete != null) {
      onDelete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: const Color(0xFFEF4444).withOpacity(0.1),
        highlightColor: const Color(0xFFEF4444).withOpacity(0.05),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.exerciseName,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: colors.textTertiary,
                          size: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          entry.formattedDuration,
                          style: TextStyle(
                            color: colors.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.access_time_rounded,
                          color: colors.textTertiary,
                          size: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          entry.formattedTime,
                          style: TextStyle(
                            color: colors.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '-${entry.caloriesBurned.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'kcal',
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _confirmDelete(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFFEF4444),
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}