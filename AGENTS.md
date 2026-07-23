# Repository Guidelines

## Project Structure & Module Organization

This is a Flutter fuel-cost calculator. Keep application code under `lib/`:

- `lib/domain/` contains models and repository contracts; keep calculation rules here.
- `lib/data/services/` contains HTTP-backed geocoding and routing integrations.
- `lib/ui/` contains theming, formatting helpers, and feature UI. The calculator feature follows `ui/features/calculator/{view_models,views,views/widgets}`.
- `test/domain/`, `test/ui/`, and `test/widget_test.dart` mirror domain, view-model, and widget coverage.
- `requisitos/mvp.md` defines the MVP requirements and business rules (for example, RN01–RN05).

Platform configuration belongs in `android/` and `ios/`; avoid placing app logic there. Generated directories such as `build/` and `.dart_tool/` are not source files.

## Build, Test, and Development Commands

Use the Flutter version pinned in `.fvmrc` (3.44.2).

- `fvm flutter pub get` installs dependencies.
- `fvm flutter run` runs the app on a connected device or emulator.
- `fvm flutter analyze` performs static analysis using `flutter_lints`.
- `fvm flutter test` runs the full unit and widget test suite.
- `fvm dart format lib test` formats changed Dart source and tests.

If FVM is unavailable, use the equivalent `flutter` and `dart` commands from Flutter 3.44.2.

## Coding Style & Naming Conventions

Follow the analyzer configuration in `analysis_options.yaml` and format with `dart format`; use two-space indentation. Name files in `snake_case.dart`, types in `UpperCamelCase`, and variables, methods, and parameters in `lowerCamelCase`. Keep widgets small and composable; place calculator-specific reusable widgets in `views/widgets/`. Model business concepts as immutable domain types where practical, and keep API parsing/network concerns out of UI classes.

## Testing Guidelines

Write tests with `flutter_test` alongside the matching layer. Name test files `*_test.dart`, group related behavior with `group()`, and describe observable outcomes in `test()`. Cover validation and calculations, including the requirements referenced in `requisitos/mvp.md`; for round trips, verify separate outbound and return distances. Run `fvm flutter test` and `fvm flutter analyze` before opening a pull request.

## Commit & Pull Request Guidelines

Existing history uses short, imperative subjects such as `fix dispose of elements`; continue that style (for example, `add route loading state`). Keep commits focused. Pull requests should explain the user-visible change, link any relevant requirement or issue, list validation commands run, and include screenshots or recordings for UI changes. Call out API, permission, or configuration changes explicitly.
