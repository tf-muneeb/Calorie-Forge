class WorkoutEntryModel {
  final String id;
  final String exerciseName;
  final double caloriesBurned;
  final int durationMinutes;
  final DateTime timestamp;

  WorkoutEntryModel({
    required this.id,
    required this.exerciseName,
    required this.caloriesBurned,
    required this.durationMinutes,
    required this.timestamp,
  });

  String get formattedDuration {
    if (durationMinutes >= 60) {
      final hours = durationMinutes ~/ 60;
      final mins = durationMinutes % 60;
      return '${hours}h ${mins}m';
    }
    return '${durationMinutes}m';
  }

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}