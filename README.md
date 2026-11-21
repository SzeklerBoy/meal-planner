# Meal Planner

A Flutter meal-planning app built over the course *Flutter mobilfejlesztés*. Sprint 2 turns the static UI into a data-driven app.

## Features
- **Live recipes:** loaded from [TheMealDB](https://www.themealdb.com/api.php), with loading, error + retry and empty states, and pull-to-refresh.
- **Recipe details:** image, category and cuisine, ingredients with measures, and instructions.
- **Favorites:** a heart on every recipe card and on the details screen. Every heart shows the same shared state, and a Favorites screen lists the saved recipes.
- **Persistent favorites:** saved on the device and kept after a restart.

## Tech stack
| | |
|---|---|
| UI | Flutter (Material 3) |
| State management | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) 3 |
| HTTP | [dio](https://pub.dev/packages/dio) |
| Local storage | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| API | TheMealDB (free, no key) |

## Running
```bash
flutter pub get
flutter run
```
Building for **Windows desktop** with plugins requires Developer Mode (`start ms-settings:developers`). Android, iOS and web need no extra setup.

## Architecture
The layers, data flow, and the reasoning behind each decision are in [ARCHITECTURE.md](ARCHITECTURE.md).
