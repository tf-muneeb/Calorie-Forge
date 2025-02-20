import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color card;
  final Color border;
  final Color accent;
  final Color warning;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color iconDefault;

  const AppColors({
    required this.background,
    required this.card,
    required this.border,
    required this.accent,
    required this.warning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconDefault,
  });

  static const dark = AppColors(
    background: Color(0xFF121212),
    card: Color(0xFF1E1E1E),
    border: Color(0xFF2D2D2D),
    accent: Color(0xFF22C55E),
    warning: Color(0xFFEF4444),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF9CA3AF),
    textTertiary: Color(0xFF6B7280),
    iconDefault: Color(0xFF6B7280),
  );

  static const light = AppColors(
    background: Color(0xFFF5F5F5),
    card: Colors.white,
    border: Color(0xFFE5E7EB),
    accent: Color(0xFF16A34A),
    warning: Color(0xFFDC2626),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    iconDefault: Color(0xFF9CA3AF),
  );
}

class AppTheme {
  static ThemeData darkTheme() {
    const c = AppColors.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        background: c.background,
        surface: c.card,
        primary: c.accent,
        secondary: c.accent,
        error: c.warning,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: c.textPrimary,
        onBackground: c.textPrimary,
        surfaceVariant: c.border,
        onSurfaceVariant: c.textSecondary,
      ),
      scaffoldBackgroundColor: c.background,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.card,
        modalBackgroundColor: c.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.warning),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: c.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: c.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: c.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: c.textPrimary,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(
          color: c.textSecondary,
          fontSize: 13,
        ),
        bodySmall: TextStyle(
          color: c.textTertiary,
          fontSize: 12,
        ),
      ),
      iconTheme: IconThemeData(
        color: c.iconDefault,
        size: 20,
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData lightTheme() {
    const c = AppColors.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        background: c.background,
        surface: c.card,
        primary: c.accent,
        secondary: c.accent,
        error: c.warning,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: c.textPrimary,
        onBackground: c.textPrimary,
        surfaceVariant: c.border,
        onSurfaceVariant: c.textSecondary,
      ),
      scaffoldBackgroundColor: c.background,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.card,
        modalBackgroundColor: c.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.warning),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: c.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: c.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: c.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: c.textPrimary,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(
          color: c.textSecondary,
          fontSize: 13,
        ),
        bodySmall: TextStyle(
          color: c.textTertiary,
          fontSize: 12,
        ),
      ),
      iconTheme: IconThemeData(
        color: c.iconDefault,
        size: 20,
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}