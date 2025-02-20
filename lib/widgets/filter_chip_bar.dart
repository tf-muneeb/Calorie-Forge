import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calorie_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class FilterChipBar extends StatelessWidget {
  final FoodFilter selectedFilter;
  final ValueChanged<FoodFilter> onFilterSelected;

  const FilterChipBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  String _getFilterLabel(FoodFilter filter) {
    switch (filter) {
      case FoodFilter.all:
        return 'All';
      case FoodFilter.breakfast:
        return 'Breakfast';
      case FoodFilter.lunch:
        return 'Lunch';
      case FoodFilter.dinner:
        return 'Dinner';
      case FoodFilter.snack:
        return 'Snack';
      case FoodFilter.highCalorie:
        return 'High Cal';
      case FoodFilter.lowCalorie:
        return 'Low Cal';
    }
  }

  IconData _getFilterIcon(FoodFilter filter) {
    switch (filter) {
      case FoodFilter.all:
        return Icons.apps_rounded;
      case FoodFilter.breakfast:
        return Icons.wb_sunny_rounded;
      case FoodFilter.lunch:
        return Icons.restaurant_rounded;
      case FoodFilter.dinner:
        return Icons.nights_stay_rounded;
      case FoodFilter.snack:
        return Icons.cookie_rounded;
      case FoodFilter.highCalorie:
        return Icons.trending_up_rounded;
      case FoodFilter.lowCalorie:
        return Icons.trending_down_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: FoodFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = FoodFilter.values[index];
          final isSelected = filter == selectedFilter;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onFilterSelected(filter),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected ? colors.accent : colors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? colors.accent : colors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getFilterIcon(filter),
                      size: 14,
                      color: isSelected ? Colors.white : colors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getFilterLabel(filter),
                      style: TextStyle(
                        color: isSelected ? Colors.white : colors.textSecondary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}