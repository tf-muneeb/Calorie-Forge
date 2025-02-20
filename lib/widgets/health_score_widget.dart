import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class HealthScoreWidget extends StatelessWidget {
  final int score;
  final String label;

  const HealthScoreWidget({
    super.key,
    required this.score,
    required this.label,
  });

  Color _getScoreColor() {
    if (score >= 90) return const Color(0xFF22C55E);
    if (score >= 75) return const Color(0xFF84CC16);
    if (score >= 60) return const Color(0xFFFBBF24);
    if (score >= 40) return const Color(0xFFF97316);
    return const Color(0xFFEF4444);
  }

  IconData _getScoreIcon() {
    if (score >= 90) return Icons.emoji_events_rounded;
    if (score >= 75) return Icons.thumb_up_rounded;
    if (score >= 60) return Icons.sentiment_neutral_rounded;
    if (score >= 40) return Icons.warning_amber_rounded;
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final color = _getScoreColor();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 6,
                    backgroundColor: colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '$score',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_getScoreIcon(), color: color, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Health Score',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 6,
                    child: LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}