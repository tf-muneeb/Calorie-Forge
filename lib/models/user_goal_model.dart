enum GoalType { lose, maintain, gain }

class UserGoalModel {
  final double dailyCalorieGoal;
  final GoalType goalType;

  UserGoalModel({
    required this.dailyCalorieGoal,
    required this.goalType,
  });

  UserGoalModel copyWith({
    double? dailyCalorieGoal,
    GoalType? goalType,
  }) {
    return UserGoalModel(
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      goalType: goalType ?? this.goalType,
    );
  }

  String get goalTypeLabel {
    switch (goalType) {
      case GoalType.lose:
        return 'Lose Weight';
      case GoalType.maintain:
        return 'Maintain Weight';
      case GoalType.gain:
        return 'Gain Weight';
    }
  }
}