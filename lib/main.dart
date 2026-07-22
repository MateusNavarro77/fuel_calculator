import 'package:flutter/material.dart';
import 'ui/core/theme.dart';
import 'ui/features/calculator/views/calculator_screen.dart';

void main() {
  runApp(const FuelCalculatorApp());
}

class FuelCalculatorApp extends StatelessWidget {
  final bool enableTileLayer;

  const FuelCalculatorApp({super.key, this.enableTileLayer = true});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Combustível',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: CalculatorScreen(enableTileLayer: enableTileLayer),
    );
  }
}
