import 'package:flutter/foundation.dart';
import '../models/food_entry_model.dart';
import '../models/workout_entry_model.dart';
import '../models/user_goal_model.dart';

enum FoodFilter { all, breakfast, lunch, dinner, snack, highCalorie, lowCalorie }

class CalorieProvider extends ChangeNotifier {
  UserGoalModel _userGoal = UserGoalModel(
    dailyCalorieGoal: 2000,
    goalType: GoalType.maintain,
  );

  final List<FoodEntryModel> _foodEntries = [];
  final List<WorkoutEntryModel> _workoutEntries = [];
  FoodFilter _currentFilter = FoodFilter.all;

  UserGoalModel get userGoal => _userGoal;
  List<FoodEntryModel> get allFoodEntries => List.unmodifiable(_foodEntries);
  List<WorkoutEntryModel> get allWorkoutEntries => List.unmodifiable(_workoutEntries);
  FoodFilter get currentFilter => _currentFilter;

  double get totalCaloriesConsumed {
    if (_foodEntries.isEmpty) return 0;
    return _foodEntries.fold(0.0, (sum, entry) => sum + entry.calories);
  }

  double get totalCaloriesBurned {
    if (_workoutEntries.isEmpty) return 0;
    return _workoutEntries.fold(0.0, (sum, entry) => sum + entry.caloriesBurned);
  }

  double get netCalories {
    return totalCaloriesConsumed - totalCaloriesBurned;
  }

  double get remainingCalories {
    final remaining = _userGoal.dailyCalorieGoal - netCalories;
    return remaining;
  }

  double get goalProgressPercentage {
    if (_userGoal.dailyCalorieGoal <= 0) return 0;
    final progress = (netCalories / _userGoal.dailyCalorieGoal) * 100;
    return progress.clamp(0, 150);
  }

  double get goalProgressFraction {
    if (_userGoal.dailyCalorieGoal <= 0) return 0;
    return (netCalories / _userGoal.dailyCalorieGoal).clamp(0.0, 1.5);
  }

  double get totalProteinConsumed {
    if (_foodEntries.isEmpty) return 0;
    return _foodEntries.fold(0.0, (sum, entry) => sum + entry.protein);
  }

  int get healthScore {
    if (_userGoal.dailyCalorieGoal <= 0) return 0;

    final ratio = netCalories / _userGoal.dailyCalorieGoal;
    int score = 100;

    if (ratio <= 0) {
      score = 50;
    } else if (ratio > 0 && ratio <= 0.5) {
      score = 60 + (ratio * 40).toInt();
    } else if (ratio > 0.5 && ratio <= 0.8) {
      score = 80 + ((ratio - 0.5) / 0.3 * 10).toInt();
    } else if (ratio > 0.8 && ratio <= 1.0) {
      score = 90 + ((ratio - 0.8) / 0.2 * 10).toInt();
    } else if (ratio > 1.0 && ratio <= 1.1) {
      score = 95 - ((ratio - 1.0) / 0.1 * 15).toInt();
    } else if (ratio > 1.1 && ratio <= 1.3) {
      score = 80 - ((ratio - 1.1) / 0.2 * 30).toInt();
    } else if (ratio > 1.3 && ratio <= 1.5) {
      score = 50 - ((ratio - 1.3) / 0.2 * 20).toInt();
    } else {
      score = 20;
    }

    if (_workoutEntries.isNotEmpty) {
      final workoutBonus = (_workoutEntries.length * 2).clamp(0, 10);
      score = (score + workoutBonus).clamp(0, 100);
    }

    final mealTypes = _foodEntries.map((e) => e.mealType).toSet();
    if (mealTypes.length >= 3) {
      score = (score + 5).clamp(0, 100);
    }

    if (totalProteinConsumed > 0) {
      final proteinRatio = totalProteinConsumed / (netCalories > 0 ? netCalories : 1);
      if (proteinRatio >= 0.15 && proteinRatio <= 0.35) {
        score = (score + 5).clamp(0, 100);
      }
    }

    return score.clamp(0, 100);
  }

  String get healthScoreLabel {
    final score = healthScore;
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Fair';
    if (score >= 40) return 'Needs Improvement';
    return 'Poor';
  }

  bool get isOverCalorieGoal {
    return netCalories > _userGoal.dailyCalorieGoal;
  }

  double get calorieDeficitOrSurplus {
    return netCalories - _userGoal.dailyCalorieGoal;
  }

  Map<MealType, double> get caloriesByMealType {
    final map = <MealType, double>{};
    for (final type in MealType.values) {
      final total = _foodEntries
          .where((e) => e.mealType == type)
          .fold(0.0, (sum, e) => sum + e.calories);
      map[type] = total;
    }
    return map;
  }

  Map<MealType, int> get entriesCountByMealType {
    final map = <MealType, int>{};
    for (final type in MealType.values) {
      map[type] = _foodEntries.where((e) => e.mealType == type).length;
    }
    return map;
  }

  double get totalWorkoutDuration {
    if (_workoutEntries.isEmpty) return 0;
    return _workoutEntries.fold(0.0, (sum, e) => sum + e.durationMinutes);
  }

  List<FoodEntryModel> get filteredFoodEntries {
    switch (_currentFilter) {
      case FoodFilter.all:
        return List.unmodifiable(_foodEntries);
      case FoodFilter.breakfast:
        return _foodEntries.where((e) => e.mealType == MealType.breakfast).toList();
      case FoodFilter.lunch:
        return _foodEntries.where((e) => e.mealType == MealType.lunch).toList();
      case FoodFilter.dinner:
        return _foodEntries.where((e) => e.mealType == MealType.dinner).toList();
      case FoodFilter.snack:
        return _foodEntries.where((e) => e.mealType == MealType.snack).toList();
      case FoodFilter.highCalorie:
        final sorted = List<FoodEntryModel>.from(_foodEntries)
          ..sort((a, b) => b.calories.compareTo(a.calories));
        return sorted;
      case FoodFilter.lowCalorie:
        final sorted = List<FoodEntryModel>.from(_foodEntries)
          ..sort((a, b) => a.calories.compareTo(b.calories));
        return sorted;
    }
  }

  void updateUserGoal({double? dailyCalorieGoal, GoalType? goalType}) {
    _userGoal = _userGoal.copyWith(
      dailyCalorieGoal: dailyCalorieGoal,
      goalType: goalType,
    );
    notifyListeners();
  }

  void addFoodEntry(FoodEntryModel entry) {
    _foodEntries.add(entry);
    notifyListeners();
  }

  void removeFoodEntry(String id) {
    _foodEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void addWorkoutEntry(WorkoutEntryModel entry) {
    _workoutEntries.add(entry);
    notifyListeners();
  }

  void removeWorkoutEntry(String id) {
    _workoutEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setFilter(FoodFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void clearAllFoodEntries() {
    _foodEntries.clear();
    notifyListeners();
  }

  void clearAllWorkoutEntries() {
    _workoutEntries.clear();
    notifyListeners();
  }

  void resetAll() {
    _foodEntries.clear();
    _workoutEntries.clear();
    _userGoal = UserGoalModel(
      dailyCalorieGoal: 2000,
      goalType: GoalType.maintain,
    );
    _currentFilter = FoodFilter.all;
    notifyListeners();
  }
}