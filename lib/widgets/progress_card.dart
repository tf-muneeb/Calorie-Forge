import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String progressLabel;
  final Color progressColor;
  final Color? backgroundColor;
  final String? trailingText;
  final IconData? icon;
  final Widget? bottomWidget;

  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.progressLabel,
    this.progressColor = const Color(0xFF22C55E),
    this.backgroundColor,
    this.trailingText,
    this.icon,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: progressColor, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                progressLabel,
                style: TextStyle(
                  color: progressColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: clampedProgress,
                backgroundColor: colors.border,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ),
          if (trailingText != null) ...[
            const SizedBox(height: 10),
            Text(
              trailingText!,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          if (bottomWidget != null) ...[
            const SizedBox(height: 12),
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}

class CircularProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String centerText;
  final String? centerSubText;
  final Color progressColor;
  final double size;
  final double strokeWidth;

  const CircularProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.centerText,
    this.centerSubText,
    this.progressColor = const Color(0xFF22C55E),
    this.size = 120,
    this.strokeWidth = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(
                    value: clampedProgress,
                    strokeWidth: strokeWidth,
                    backgroundColor: colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        centerText,
                        style: TextStyle(
                          color: progressColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (centerSubText != null)
                      Text(
                        centerSubText!,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}