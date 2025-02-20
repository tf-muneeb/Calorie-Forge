import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calorie_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/health_score_widget.dart';
import '../widgets/meal_breakdown_bar.dart';
import '../widgets/empty_state_widget.dart';
import 'food_log_screen.dart';
import 'workout_log_screen.dart';
import 'add_entry_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      body: Consumer<CalorieProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, colors),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildGoalBanner(provider, colors),
                    const SizedBox(height: 20),
                    _buildCalorieRing(provider),
                    Transform.translate(
                      offset: const Offset(0, -9),
                      child: _buildSummaryCards(context, provider, colors),
                    ),
                    const SizedBox(height: 20),
                    _buildDailyProgress(provider, colors),
                    const SizedBox(height: 20),
                    HealthScoreWidget(
                      score: provider.healthScore,
                      label: provider.healthScoreLabel,
                    ),
                    const SizedBox(height: 20),
                    if (provider.totalCaloriesConsumed > 0)
                      MealBreakdownBar(
                        caloriesByMeal: provider.caloriesByMealType,
                        totalCalories: provider.totalCaloriesConsumed,
                      ),
                    if (provider.totalCaloriesConsumed == 0)
                      EmptyStateWidget(
                        icon: Icons.restaurant_menu_rounded,
                        title: 'No entries yet',
                        subtitle:
                        'Start logging your meals and workouts to see your dashboard come alive.',
                        actionLabel: 'Add First Entry',
                        onAction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddEntryScreen(),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    _buildRecentActivity(context, provider, colors),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(context, colors),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColors colors) {
    return SliverAppBar(
      backgroundColor: colors.background,
      expandedHeight: 100,
      floating: true,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: colors.accent,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'CalorieForge',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            context.read<ThemeProvider>().toggleTheme();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
            ),
            child: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: colors.textSecondary,
              size: 18,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 20, top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: colors.textSecondary,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalBanner(CalorieProvider provider, AppColors colors) {
    final isOver = provider.isOverCalorieGoal;
    final bannerColor = isOver ? colors.warning : colors.accent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bannerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isOver ? Icons.warning_amber_rounded : Icons.flag_rounded,
            color: bannerColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.userGoal.goalTypeLabel,
                  style: TextStyle(
                    color: bannerColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOver
                      ? 'You\'ve exceeded your daily goal by ${provider.calorieDeficitOrSurplus.toStringAsFixed(0)} kcal'
                      : 'Daily Goal: ${provider.userGoal.dailyCalorieGoal.toStringAsFixed(0)} kcal',
                  style: TextStyle(
                    color: bannerColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${provider.goalProgressPercentage.toStringAsFixed(0)}%',
            style: TextStyle(
              color: bannerColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieRing(CalorieProvider provider) {
    final isOver = provider.isOverCalorieGoal;
    final ringColor = isOver ? const Color(0xFFEF4444) : const Color(0xFF22C55E);
    final remaining = provider.remainingCalories;

    return CircularProgressCard(
      title: 'Remaining Calories',
      progress: provider.goalProgressFraction,
      centerText: remaining >= 0
          ? remaining.toStringAsFixed(0)
          : '+${remaining.abs().toStringAsFixed(0)}',
      centerSubText: remaining >= 0 ? 'kcal left' : 'kcal over',
      progressColor: ringColor,
      size: 140,
      strokeWidth: 10,
    );
  }

  Widget _buildSummaryCards(
      BuildContext context, CalorieProvider provider, AppColors colors) {
    final isOver = provider.isOverCalorieGoal;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      children: [
        DashboardCard(
          title: 'Consumed',
          value: provider.totalCaloriesConsumed.toStringAsFixed(0),
          subtitle: '${provider.allFoodEntries.length} entries',
          icon: Icons.restaurant_rounded,
          iconColor: const Color(0xFF22C55E),
          valueColor: isOver ? const Color(0xFFEF4444) : null,
        ),
        DashboardCard(
          title: 'Burned',
          value: provider.totalCaloriesBurned.toStringAsFixed(0),
          subtitle: '${provider.allWorkoutEntries.length} workouts',
          icon: Icons.local_fire_department_rounded,
          iconColor: const Color(0xFFEF4444),
        ),
        DashboardCard(
          title: 'Net Calories',
          value: provider.netCalories.toStringAsFixed(0),
          subtitle: 'consumed - burned',
          icon: Icons.calculate_rounded,
          iconColor: const Color(0xFF3B82F6),
        ),
        DashboardCard(
          title: 'Protein',
          value: '${provider.totalProteinConsumed.toStringAsFixed(1)}g',
          subtitle: 'total intake',
          icon: Icons.egg_rounded,
          iconColor: const Color(0xFFFBBF24),
        ),
      ],
    );
  }

  Widget _buildDailyProgress(CalorieProvider provider, AppColors colors) {
    final isOver = provider.isOverCalorieGoal;
    final progressColor = isOver ? colors.warning : colors.accent;

    return ProgressCard(
      title: 'Daily Goal Progress',
      progress: provider.goalProgressFraction,
      progressLabel: '${provider.goalProgressPercentage.toStringAsFixed(1)}%',
      progressColor: progressColor,
      icon: Icons.track_changes_rounded,
      trailingText:
      '${provider.netCalories.toStringAsFixed(0)} / ${provider.userGoal.dailyCalorieGoal.toStringAsFixed(0)} kcal',
      bottomWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMiniStat('Workout Duration',
              '${provider.totalWorkoutDuration.toStringAsFixed(0)} min', colors),
          _buildMiniStat(
              'Food Entries', '${provider.allFoodEntries.length}', colors),
          _buildMiniStat(
              'Workouts', '${provider.allWorkoutEntries.length}', colors),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, AppColors colors) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: colors.textTertiary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(
      BuildContext context, CalorieProvider provider, AppColors colors) {
    final recentFoods = provider.allFoodEntries.length > 3
        ? provider.allFoodEntries.sublist(provider.allFoodEntries.length - 3)
        : provider.allFoodEntries;

    final recentWorkouts = provider.allWorkoutEntries.length > 2
        ? provider.allWorkoutEntries
        .sublist(provider.allWorkoutEntries.length - 2)
        : provider.allWorkoutEntries;

    if (recentFoods.isEmpty && recentWorkouts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FoodLogScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recentFoods.reversed.map((entry) => _buildActivityItem(
          entry.name,
          '+${entry.calories.toStringAsFixed(0)} kcal',
          entry.mealTypeLabel,
          entry.formattedTime,
          Icons.restaurant_rounded,
          const Color(0xFF22C55E),
          colors,
        )),
        ...recentWorkouts.reversed.map((entry) => _buildActivityItem(
          entry.exerciseName,
          '-${entry.caloriesBurned.toStringAsFixed(0)} kcal',
          entry.formattedDuration,
          entry.formattedTime,
          Icons.fitness_center_rounded,
          const Color(0xFFEF4444),
          colors,
        )),
      ],
    );
  }

  Widget _buildActivityItem(
      String title,
      String calories,
      String badge,
      String time,
      IconData icon,
      Color color,
      AppColors colors,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style:
                      TextStyle(color: colors.textTertiary, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              isActive: true,
              colors: colors,
              onTap: () {},
            ),
            _buildNavItem(
              icon: Icons.restaurant_menu_rounded,
              label: 'Food',
              colors: colors,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FoodLogScreen()));
              },
            ),
            _buildNavAddButton(context, colors),
            _buildNavItem(
              icon: Icons.fitness_center_rounded,
              label: 'Workout',
              colors: colors,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const WorkoutLogScreen()));
              },
            ),
            _buildNavItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              colors: colors,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    bool isActive = false,
    required AppColors colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? colors.accent : colors.textTertiary,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? colors.accent : colors.textTertiary,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavAddButton(BuildContext context, AppColors colors) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddEntryScreen()));
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.accent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colors.accent.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}