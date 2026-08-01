# ⛽ Fuel Cost Calculator (Calculadora de Custo de Combustível)

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/MateusNavarro77/fuel_calculator)
[![Flutter](https://img.shields.io/badge/Flutter-3.44.2-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Static Analysis](https://img.shields.io/badge/analysis-clean-success)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/MateusNavarro77/fuel_calculator/pulls)

A modern, responsive Flutter mobile application designed to calculate fuel expenses for road trips. The application integrates real-time geocoding and routing services (OpenStreetMap/OSRM) to calculate exact route distances, render interactive maps, and accurately compute fuel consumption and total costs.

---

## 🖼️ Application Preview

> [!NOTE]
> Screenshots and interactive UI preview placeholders.

![Fuel Calculator App Banner Placeholder](https://via.placeholder.com/1200x500.png?text=Fuel+Calculator+App+Banner+Placeholder)

<p align="center">
  <img src="https://via.placeholder.com/320x640.png?text=1.+Trip+%26+Vehicle+Inputs" width="30%" alt="Input Screen Placeholder" />
  <img src="https://via.placeholder.com/320x640.png?text=2.+Interactive+Map+Route" width="30%" alt="Map Screen Placeholder" />
  <img src="https://via.placeholder.com/320x640.png?text=3.+Cost+%26+Fuel+Breakdown" width="30%" alt="Results Screen Placeholder" />
</p>

---

## ✨ Features

- **📍 Address Autocomplete & Geocoding**: Search and select trip origin and destination points (powered by Nominatim / OpenStreetMap).
- **🚗 Vehicle Fuel Efficiency**: Input average fuel consumption rate in kilometers per liter (`km/L`).
- **⛽ Fuel Pricing**: Input current fuel price per liter (`R$/L`).
- **🔄 Round-Trip Option (Ida e Volta)**: Support for one-way or round-trip journeys. When round-trip is enabled, return routes are computed separately from destination to origin to account for one-way streets, traffic restrictions, and mandatory turns (RN05).
- **🗺️ Interactive Route Map**: View outbound and return routes rendered visually on an embedded map using `flutter_map`.
- **📊 Real-time Calculations & Breakdown**: Instantly view total distance (km), outbound distance, return distance, estimated fuel required (Liters), and total trip cost (R$).

---

## 📐 Business Rules & Calculation Formulas

### Formulas
$$\text{Total Liters} = \frac{\text{Total Distance (km)}}{\text{Fuel Consumption (km/L)}}$$

$$\text{Total Cost (R\$)} = \text{Total Liters} \times \text{Fuel Price (R\$/L)}$$

### Business Rules (Requisitos MVP)
- **RN01**: Vehicle fuel consumption rate must be strictly greater than `0 km/L`.
- **RN02**: Fuel price per liter must be strictly greater than `R$ 0.00/L`.
- **RN03**: Both origin and destination addresses are mandatory before calculation.
- **RN04**: Trip distance is sourced directly from the OSRM routing API.
- **RN05**: Round-trip return routes are fetched via a distinct secondary API call (Destination → Origin) to accurately reflect road directions and legal turns rather than simply doubling the outbound distance.

---

## 🏗️ Architecture & Project Structure

The project follows a clean, modular architecture separating domain models, API data providers, and UI components:

```text
lib/
├── data/
│   └── services/       # Geocoding (Nominatim) & Routing (OSRM) HTTP integrations
├── domain/
│   ├── models/         # Immutable domain models (Route, CalculationResult, Location)
│   └── repositories/   # Abstract service contracts & calculation logic
├── ui/
│   ├── core/           # Design tokens, color palettes, and global typography theme
│   └── features/
│       └── calculator/
│           ├── view_models/  # MVVM state management & form controllers
│           └── views/        # Screen layouts & composable widgets
└── main.dart           # Application entrypoint
```

---

## 🛠️ Prerequisites & Setup

### Requirements
- **Flutter SDK**: `3.44.2` (managed via FVM)
- **Dart SDK**: `^3.12.2`

### Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/MateusNavarro77/fuel_calculator.git
   cd fuel_calculator
   ```

2. **Install dependencies**:
   ```bash
   fvm flutter pub get
   ```

3. **Run the app**:
   ```bash
   fvm flutter run
   ```

---

## 🧪 Testing & Code Quality Commands

Maintain code quality and verify business requirements using the following CLI commands:

- **Static Analysis**:
  ```bash
  fvm flutter analyze
  ```
- **Execute Test Suite**:
  ```bash
  fvm flutter test
  ```
- **Format Dart Code**:
  ```bash
  fvm dart format lib test
  ```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
