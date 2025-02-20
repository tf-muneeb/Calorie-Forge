import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calorie_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/entry_list_item.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/empty_state_widget.dart';
import 'add_entry_screen.dart';

class FoodLogScreen extends StatelessWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: colors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Food Log',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<CalorieProvider>(
            builder: (context, provider, _) {
              if (provider.allFoodEntries.isEmpty) return const SizedBox.shrink();
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showClearDialog(context, provider, colors),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.warning.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: colors.warning,
                      size: 18,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CalorieProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              const SizedBox(height: 12),
              _buildSummaryRow(provider, colors),
              const SizedBox(height: 16),
              FilterChipBar(
                selectedFilter: provider.currentFilter,
                onFilterSelected: (filter) {
                  provider.setFilter(filter);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: provider.filteredFoodEntries.isEmpty
                    ? EmptyStateWidget(
                  icon: Icons.restaurant_menu_rounded,
                  title: provider.allFoodEntries.isEmpty
                      ? 'No food entries'
                      : 'No matching entries',
                  subtitle: provider.allFoodEntries.isEmpty
                      ? 'Tap the button below to add your first meal.'
                      : 'Try a different filter to find your entries.',
                  actionLabel:
                  provider.allFoodEntries.isEmpty ? 'Add Food' : null,
                  onAction: provider.allFoodEntries.isEmpty
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddEntryScreen(),
                      ),
                    );
                  }
                      : null,
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: provider.filteredFoodEntries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.filteredFoodEntries[index];
                    return FoodListItem(
                      entry: entry,
                      onDelete: () {
                        provider.removeFoodEntry(entry.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${entry.name} removed',
                              style: TextStyle(color: colors.textPrimary),
                            ),
                            backgroundColor: colors.card,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
          );
        },
        backgroundColor: colors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryRow(CalorieProvider provider, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryStat(
              'Total',
              '${provider.totalCaloriesConsumed.toStringAsFixed(0)} kcal',
              colors.accent,
              colors,
            ),
            Container(width: 1, height: 30, color: colors.border),
            _buildSummaryStat(
              'Entries',
              '${provider.allFoodEntries.length}',
              const Color(0xFF3B82F6),
              colors,
            ),
            Container(width: 1, height: 30, color: colors.border),
            _buildSummaryStat(
              'Protein',
              '${provider.totalProteinConsumed.toStringAsFixed(1)}g',
              const Color(0xFFFBBF24),
              colors,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(
      String label, String value, Color color, AppColors colors) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: colors.textTertiary, fontSize: 11),
        ),
      ],
    );
  }

  void _showClearDialog(
      BuildContext context, CalorieProvider provider, AppColors colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          'Clear All Food Entries?',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This will remove all food entries. This action cannot be undone.',
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              provider.clearAllFoodEntries();
              Navigator.pop(ctx);
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: colors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}