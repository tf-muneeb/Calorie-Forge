import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calorie_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const CalorieForgeApp());
}

class CalorieForgeApp extends StatelessWidget {
  const CalorieForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalorieProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'CalorieForge',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}