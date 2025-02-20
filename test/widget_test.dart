import 'package:calorieforge/main.dart';
import 'package:calorieforge/providers/calorie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
void main() {
  testWidgets('CalorieForge app launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    expect(find.text('CalorieForge'), findsOneWidget);
  });

  testWidgets('Dashboard displays initial zero values', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    expect(find.text('0'), findsWidgets);
  });

  testWidgets('Dashboard shows goal type label', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    expect(find.text('Maintain Weight'), findsOneWidget);
  });

  testWidgets('Add button exists on dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add_rounded), findsWidgets);
  });

  testWidgets('Bottom navigation items exist', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Health score widget displays on dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    expect(find.text('Health Score'), findsOneWidget);
  });

  testWidgets('Provider calculates correct initial values', (WidgetTester tester) async {
    final provider = CalorieProvider();

    expect(provider.totalCaloriesConsumed, 0);
    expect(provider.totalCaloriesBurned, 0);
    expect(provider.remainingCalories, 2000);
    expect(provider.goalProgressPercentage, 0);
    expect(provider.netCalories, 0);
    expect(provider.totalProteinConsumed, 0);
    expect(provider.allFoodEntries.isEmpty, true);
    expect(provider.allWorkoutEntries.isEmpty, true);
    expect(provider.isOverCalorieGoal, false);
  });

  testWidgets('Navigate to Food Log screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();

    expect(find.text('Food Log'), findsOneWidget);
  });

  testWidgets('Navigate to Workout Log screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();

    expect(find.text('Workout Log'), findsOneWidget);
  });

  testWidgets('Navigate to Settings screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Daily Goal'), findsOneWidget);
    expect(find.text('Danger Zone'), findsOneWidget);
  });

  testWidgets('Navigate to Add Entry screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    final addButtons = find.byIcon(Icons.add_rounded);
    await tester.tap(addButtons.first);
    await tester.pumpAndSettle();

    expect(find.text('Add Entry'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
    expect(find.text('Workout'), findsWidgets);
  });

  testWidgets('Empty state shows on Food Log', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();

    expect(find.text('No food entries'), findsOneWidget);
  });

  testWidgets('Empty state shows on Workout Log', (WidgetTester tester) async {
    await tester.pumpWidget(const CalorieForgeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();

    expect(find.text('No workouts logged'), findsOneWidget);
  });
}