# 🔥 CalorieForge

A premium dark-themed Flutter fitness app for tracking calories, workouts, and nutrition — built with clean architecture and zero backend dependency.

---

## ✨ Features

- **Command Center Dashboard** — real-time cards showing calories consumed, burned, remaining, and protein intake
- **BMR Goal Calculator** — auto-suggests daily calorie target using Mifflin-St Jeor formula based on age, weight, height, and gender
- **Food Log** — add meals by type (breakfast, lunch, dinner, snack) with optional protein tracking
- **Workout Log** — log exercises with auto-detected intensity badge (Light / Moderate / Intense)
- **Meal Breakdown Bar** — visual calorie distribution across meal types
- **Health Score** — dynamic score based on how close you are to your daily calorie goal
- **Smart Filtering** — filter food entries by meal type, high calorie, or low calorie instantly
- **Swipe to Delete** — swipe left on any entry to remove it
- **Haptic Feedback** — native tactile response on key interactions

---

## 🏗️ Architecture
```
lib/
├── models/
│   ├── food_entry_model.dart
│   ├── workout_entry_model.dart
│   └── user_goal_model.dart
├── providers/
│   └── calorie_provider.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── food_log_screen.dart
│   ├── workout_log_screen.dart
│   └── add_entry_screen.dart
└── widgets/
    ├── dashboard_card.dart
    ├── progress_card.dart
    ├── entry_list_item.dart
    ├── health_score_ring.dart
    ├── meal_breakdown_bar.dart
    └── workout_intensity_badge.dart
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Provider |
| Architecture | Clean Architecture |
| Storage | None — runtime only |
| Charts | Flutter built-in widgets |
| External Libraries | `provider: ^6.1.2` only |

---

## 🎨 Design System

| Token | Value |
|---|---|
| Background | `#121212` |
| Card | `#1E1E1E` |
| Border | `#2D2D2D` |
| Accent Green | `#22C55E` |
| Warning Red | `#EF4444` |
| Border Radius | `8px` |

---

## 🚀 Getting Started
```bash
# Clone the repo
git clone https://github.com/yourusername/calorieforge.git

# Navigate into the project
cd calorieforge

# Install dependencies
flutter pub get

# Run the app
flutter run
```

**Requirements:** Flutter 3.x · Dart 3.x

---

## ⚠️ Constraints

This app intentionally uses **no persistence layer**. All data is runtime-only and resets when the app is closed. This is by design to demonstrate clean state management architecture without any storage dependency.

---

## 📄 License

MIT License — free to use, modify, and distribute.
```

---

**GitHub Topics to add to your repo:**
```
flutter dart provider clean-architecture fitness calorie-tracker health dark-theme mobile-app
