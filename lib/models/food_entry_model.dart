enum MealType { breakfast, lunch, dinner, snack }

class FoodEntryModel {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final MealType mealType;
  final DateTime timestamp;

  FoodEntryModel({
    required this.id,
    required this.name,
    required this.calories,
    this.protein = 0.0,
    required this.mealType,
    required this.timestamp,
  });

  String get mealTypeLabel {
    switch (mealType) {
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

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}