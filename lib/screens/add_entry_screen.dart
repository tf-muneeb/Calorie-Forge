import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/food_entry_model.dart';
import '../models/workout_entry_model.dart';
import '../providers/calorie_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_entry_form.dart';

class AddEntryScreen extends StatefulWidget {
  final int initialTab;

  const AddEntryScreen({super.key, this.initialTab = 0});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _foodFormKey = GlobalKey<FormState>();
  final _workoutFormKey = GlobalKey<FormState>();

  final _foodNameController = TextEditingController();
  final _foodCaloriesController = TextEditingController();
  final _foodProteinController = TextEditingController();

  final _workoutNameController = TextEditingController();
  final _workoutCaloriesController = TextEditingController();
  final _workoutDurationController = TextEditingController();

  MealType _selectedMealType = MealType.breakfast;
  bool _showFoodSuccess = false;
  bool _showWorkoutSuccess = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _foodNameController.dispose();
    _foodCaloriesController.dispose();
    _foodProteinController.dispose();
    _workoutNameController.dispose();
    _workoutCaloriesController.dispose();
    _workoutDurationController.dispose();
    super.dispose();
  }

  void _addFoodEntry() {
    if (!_foodFormKey.currentState!.validate()) return;

    final provider = context.read<CalorieProvider>();
    final entry = FoodEntryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _foodNameController.text.trim(),
      calories: double.parse(_foodCaloriesController.text.trim()),
      protein: _foodProteinController.text.trim().isNotEmpty
          ? double.parse(_foodProteinController.text.trim())
          : 0.0,
      mealType: _selectedMealType,
      timestamp: DateTime.now(),
    );

    provider.addFoodEntry(entry);

    _foodNameController.clear();
    _foodCaloriesController.clear();
    _foodProteinController.clear();

    setState(() => _showFoodSuccess = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showFoodSuccess = false);
    });
  }

  void _addWorkoutEntry() {
    if (!_workoutFormKey.currentState!.validate()) return;

    final provider = context.read<CalorieProvider>();
    final entry = WorkoutEntryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseName: _workoutNameController.text.trim(),
      caloriesBurned: double.parse(_workoutCaloriesController.text.trim()),
      durationMinutes: int.parse(_workoutDurationController.text.trim()),
      timestamp: DateTime.now(),
    );

    provider.addWorkoutEntry(entry);

    _workoutNameController.clear();
    _workoutCaloriesController.clear();
    _workoutDurationController.clear();

    setState(() => _showWorkoutSuccess = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showWorkoutSuccess = false);
    });
  }

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
          'Add Entry',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: colors.accent,
                borderRadius: BorderRadius.circular(7),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: colors.textSecondary,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              dividerHeight: 0,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Food'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Workout'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFoodForm(colors),
          _buildWorkoutForm(colors),
        ],
      ),
    );
  }

  Widget _buildFoodForm(AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionHeader(
            icon: Icons.restaurant_rounded,
            title: 'Log Food Entry',
            color: colors.accent,
            colors: colors,
          ),
          const SizedBox(height: 24),
          if (_showFoodSuccess) ...[
            _buildSuccessMessage('Food entry added successfully!', colors),
            const SizedBox(height: 16),
          ],
          AddEntryForm(
            formKey: _foodFormKey,
            fields: [
              AddEntryField(
                controller: _foodNameController,
                label: 'Food Name',
                hint: 'e.g. Grilled Chicken Salad',
                prefixIcon: Icons.fastfood_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter food name';
                  }
                  return null;
                },
              ),
              AddEntryField(
                controller: _foodCaloriesController,
                label: 'Calories',
                hint: 'e.g. 350',
                prefixIcon: Icons.local_fire_department_rounded,
                suffixText: 'kcal',
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter calories';
                  }
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid calorie amount';
                  }
                  return null;
                },
              ),
              AddEntryField(
                controller: _foodProteinController,
                label: 'Protein (optional)',
                hint: 'e.g. 25',
                prefixIcon: Icons.egg_rounded,
                suffixText: 'grams',
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}')),
                ],
              ),
            ],
            dropdownField: StyledDropdown<MealType>(
              value: _selectedMealType,
              label: 'Meal Type',
              prefixIcon: Icons.category_rounded,
              items: MealType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getMealLabel(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedMealType = value);
                }
              },
            ),
            submitLabel: 'Add Food Entry',
            submitIcon: Icons.add_rounded,
            onSubmit: _addFoodEntry,
          ),
          const SizedBox(height: 24),
          _buildCurrentStats(colors),
        ],
      ),
    );
  }

  Widget _buildWorkoutForm(AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionHeader(
            icon: Icons.fitness_center_rounded,
            title: 'Log Workout',
            color: colors.warning,
            colors: colors,
          ),
          const SizedBox(height: 24),
          if (_showWorkoutSuccess) ...[
            _buildSuccessMessage(
                'Workout entry added successfully!', colors),
            const SizedBox(height: 16),
          ],
          AddEntryForm(
            formKey: _workoutFormKey,
            fields: [
              AddEntryField(
                controller: _workoutNameController,
                label: 'Exercise Name',
                hint: 'e.g. Running, Push-ups',
                prefixIcon: Icons.directions_run_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter exercise name';
                  }
                  return null;
                },
              ),
              AddEntryField(
                controller: _workoutCaloriesController,
                label: 'Calories Burned',
                hint: 'e.g. 200',
                prefixIcon: Icons.local_fire_department_rounded,
                suffixText: 'kcal',
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter calories burned';
                  }
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid calorie amount';
                  }
                  return null;
                },
              ),
              AddEntryField(
                controller: _workoutDurationController,
                label: 'Duration',
                hint: 'e.g. 30',
                prefixIcon: Icons.timer_rounded,
                suffixText: 'minutes',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter duration';
                  }
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid duration';
                  }
                  return null;
                },
              ),
            ],
            submitLabel: 'Add Workout',
            submitIcon: Icons.fitness_center_rounded,
            accentColor: colors.warning,
            onSubmit: _addWorkoutEntry,
          ),
          const SizedBox(height: 24),
          _buildCurrentStats(colors),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
    required AppColors colors,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessMessage(String message, AppColors colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: colors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colors.accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStats(AppColors colors) {
    return Consumer<CalorieProvider>(
      builder: (context, provider, _) {
        final isOver = provider.isOverCalorieGoal;
        final statusColor = isOver ? colors.warning : colors.accent;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart_rounded,
                      color: colors.textSecondary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Current Status',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('Consumed',
                      '${provider.totalCaloriesConsumed.toStringAsFixed(0)}',
                      colors.accent, colors),
                  _buildStatItem('Burned',
                      '${provider.totalCaloriesBurned.toStringAsFixed(0)}',
                      colors.warning, colors),
                  _buildStatItem('Remaining',
                      '${provider.remainingCalories.toStringAsFixed(0)}',
                      statusColor, colors),
                  _buildStatItem('Goal',
                      '${provider.userGoal.dailyCalorieGoal.toStringAsFixed(0)}',
                      const Color(0xFF3B82F6), colors),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: provider.goalProgressFraction.clamp(0.0, 1.0),
                    backgroundColor: colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
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
          style: TextStyle(color: colors.textTertiary, fontSize: 10),
        ),
      ],
    );
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
}