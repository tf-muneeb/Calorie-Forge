import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/user_goal_model.dart';
import '../providers/calorie_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _goalController = TextEditingController();
  late GoalType _selectedGoalType;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CalorieProvider>();
    _goalController.text =
        provider.userGoal.dailyCalorieGoal.toStringAsFixed(0);
    _selectedGoalType = provider.userGoal.goalType;
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _saveGoal(AppColors colors) {
    final value = double.tryParse(_goalController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid calorie goal',
              style: TextStyle(color: Colors.white)),
          backgroundColor: colors.warning,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    context.read<CalorieProvider>().updateUserGoal(
      dailyCalorieGoal: value,
      goalType: _selectedGoalType,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Goal updated successfully!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: colors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _openBMRCalculator(AppColors colors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BMRCalculatorSheet(
        colors: colors,
        onApply: (calories) {
          setState(() {
            _goalController.text = calories.toStringAsFixed(0);
          });
        },
      ),
    );
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
              child: Icon(Icons.arrow_back_rounded,
                  color: colors.textSecondary, size: 18),
            ),
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeToggle(colors),
            const SizedBox(height: 24),
            _buildSectionHeader(
              icon: Icons.flag_rounded,
              title: 'Daily Goal',
              color: colors.accent,
              colors: colors,
            ),
            const SizedBox(height: 20),
            _buildGoalInput(colors),
            const SizedBox(height: 12),
            // BMR Calculator Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () => _openBMRCalculator(colors),
                icon: Icon(Icons.calculate_rounded, size: 18, color: colors.accent),
                label: Text(
                  'Use BMR Calculator',
                  style: TextStyle(
                    color: colors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.accent.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildGoalTypeSelector(colors),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _saveGoal(colors),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Save Goal',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionHeader(
              icon: Icons.info_outline_rounded,
              title: 'Current Session',
              color: const Color(0xFF3B82F6),
              colors: colors,
            ),
            const SizedBox(height: 20),
            _buildSessionInfo(colors),
            const SizedBox(height: 24),
            _buildDangerZone(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(AppColors colors) {
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => themeProvider.toggleTheme(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: colors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Theme',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: colors.accent,
                  activeTrackColor: colors.accent.withOpacity(0.3),
                  inactiveThumbColor: colors.textTertiary,
                  inactiveTrackColor: colors.border,
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildGoalInput(AppColors colors) {
    return TextFormField(
      controller: _goalController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
      ],
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '2000',
        hintStyle: TextStyle(
          color: colors.textTertiary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        suffixText: 'kcal',
        suffixStyle: TextStyle(color: colors.textTertiary, fontSize: 14),
        filled: true,
        fillColor: colors.card,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGoalTypeSelector(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Goal Type',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: GoalType.values.map((type) {
            final isSelected = type == _selectedGoalType;
            final label = _getGoalLabel(type);
            final icon = _getGoalIcon(type);
            final color = _getGoalColor(type);

            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedGoalType = type),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin:
                    EdgeInsets.only(right: type != GoalType.gain ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.15)
                          : colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? color : colors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(icon,
                            color: isSelected ? color : colors.textTertiary,
                            size: 22),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: TextStyle(
                            color:
                            isSelected ? color : colors.textSecondary,
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSessionInfo(AppColors colors) {
    return Consumer<CalorieProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              _buildInfoRow('Daily Goal',
                  '${provider.userGoal.dailyCalorieGoal.toStringAsFixed(0)} kcal',
                  colors),
              _buildInfoRow(
                  'Goal Type', provider.userGoal.goalTypeLabel, colors),
              _buildInfoRow('Food Entries',
                  '${provider.allFoodEntries.length}', colors),
              _buildInfoRow('Workout Entries',
                  '${provider.allWorkoutEntries.length}', colors),
              _buildInfoRow('Net Calories',
                  '${provider.netCalories.toStringAsFixed(0)} kcal', colors),
              _buildInfoRow(
                  'Health Score', '${provider.healthScore}/100', colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: colors.textSecondary, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDangerZone(AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.warning.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: colors.warning, size: 18),
              const SizedBox(width: 8),
              Text('Danger Zone',
                  style: TextStyle(
                      color: colors.warning,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => _showResetDialog(colors),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.warning,
                side: BorderSide(color: colors.warning, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Reset All Data',
                  style:
                  TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(AppColors colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Reset All Data?',
            style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: Text(
          'This will clear all food entries, workouts, and reset your goal to default. This cannot be undone.',
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
              context.read<CalorieProvider>().resetAll();
              _goalController.text = '2000';
              setState(() => _selectedGoalType = GoalType.maintain);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All data has been reset',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: colors.warning,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: Text('Reset Everything',
                style: TextStyle(
                    color: colors.warning, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String _getGoalLabel(GoalType type) {
    switch (type) {
      case GoalType.lose:
        return 'Lose';
      case GoalType.maintain:
        return 'Maintain';
      case GoalType.gain:
        return 'Gain';
    }
  }

  IconData _getGoalIcon(GoalType type) {
    switch (type) {
      case GoalType.lose:
        return Icons.trending_down_rounded;
      case GoalType.maintain:
        return Icons.balance_rounded;
      case GoalType.gain:
        return Icons.trending_up_rounded;
    }
  }

  Color _getGoalColor(GoalType type) {
    switch (type) {
      case GoalType.lose:
        return const Color(0xFF3B82F6);
      case GoalType.maintain:
        return const Color(0xFF22C55E);
      case GoalType.gain:
        return const Color(0xFFFBBF24);
    }
  }
}

// ─── BMR Calculator Bottom Sheet ─────────────────────────────────────────────

class BMRCalculatorSheet extends StatefulWidget {
  final AppColors colors;
  final Function(double) onApply;

  const BMRCalculatorSheet({
    super.key,
    required this.colors,
    required this.onApply,
  });

  @override
  State<BMRCalculatorSheet> createState() => _BMRCalculatorSheetState();
}

class _BMRCalculatorSheetState extends State<BMRCalculatorSheet> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String _gender = 'Male';
  String _activityLevel = 'Sedentary';
  double? _result;

  final List<String> _activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extra Active',
  ];

  double _getActivityMultiplier() {
    switch (_activityLevel) {
      case 'Sedentary':
        return 1.2;
      case 'Lightly Active':
        return 1.375;
      case 'Moderately Active':
        return 1.55;
      case 'Very Active':
        return 1.725;
      case 'Extra Active':
        return 1.9;
      default:
        return 1.2;
    }
  }

  void _calculate() {
    final age = int.tryParse(_ageController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final height = double.tryParse(_heightController.text.trim());

    if (age == null || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields',
              style: TextStyle(color: Colors.white)),
          backgroundColor: widget.colors.warning,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Mifflin-St Jeor Equation
    double bmr;
    if (_gender == 'Male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    final tdee = bmr * _getActivityMultiplier();
    setState(() => _result = tdee);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.calculate_rounded,
                      color: colors.accent, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'BMR Calculator',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Uses Mifflin-St Jeor equation to estimate your daily calorie needs.',
                style: TextStyle(color: colors.textTertiary, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Gender selector
            Text('Gender',
                style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: ['Male', 'Female'].map((g) {
                final isSelected = _gender == g;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _gender = g),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: g == 'Male' ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.accent.withOpacity(0.15)
                            : colors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? colors.accent : colors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            g == 'Male' ? Icons.male_rounded : Icons.female_rounded,
                            color: isSelected ? colors.accent : colors.textTertiary,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            g,
                            style: TextStyle(
                              color: isSelected ? colors.accent : colors.textSecondary,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Age, Weight, Height inputs
            Row(
              children: [
                Expanded(
                  child: _buildInput(
                    controller: _ageController,
                    label: 'Age',
                    hint: '25',
                    suffix: 'yrs',
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInput(
                    controller: _weightController,
                    label: 'Weight',
                    hint: '70',
                    suffix: 'kg',
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInput(
                    controller: _heightController,
                    label: 'Height',
                    hint: '175',
                    suffix: 'cm',
                    colors: colors,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Activity level
            Text('Activity Level',
                style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.border),
              ),
              child: DropdownButton<String>(
                value: _activityLevel,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: colors.card,
                style: TextStyle(color: colors.textPrimary, fontSize: 13),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: colors.textTertiary),
                items: _activityLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _activityLevel = val);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Calculate button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Calculate',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),

            // Result
            if (_result != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.accent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Daily Calorie Need',
                      style: TextStyle(
                          color: colors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_result!.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        color: colors.accent,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on $_gender, $_activityLevel activity',
                      style: TextStyle(
                          color: colors.textTertiary, fontSize: 11),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onApply(_result!);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Apply to Goal',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required AppColors colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: colors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
            TextStyle(color: colors.textTertiary, fontSize: 14),
            suffixText: suffix,
            suffixStyle:
            TextStyle(color: colors.textTertiary, fontSize: 11),
            filled: true,
            fillColor: colors.background,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}