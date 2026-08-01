import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppSpacing {
  static const double unit = 4.0;
  static const double stackSm = 8.0;
  static const double stackMd = 16.0;
  static const double gutter = 24.0;
  static const double margin = 40.0;
  static const double stackLg = 48.0;
}

abstract class AppColors {
  static const Color surface = Color(0xFF131313);
  static const Color surfaceDim = Color(0xFF131313);
  static const Color surfaceBright = Color(0xFF393939);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color surfaceContainerLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF20201F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353535);

  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFE7BDB2);

  static const Color outline = Color(0xFFAD887E);
  static const Color outlineVariant = Color(0xFF5D4038);

  static const Color primary = Color(0xFFFFB5A0);
  static const Color heatOrange = Color(0xFFFF4500); // High-vis heat accent
  static const Color primaryContainer = Color(0xFFFF5625);
  static const Color onPrimary = Color(0xFF601400);

  static const Color secondary = Color(0xFFC6C6C7);
  static const Color onSecondary = Color(0xFF2F3131);
  static const Color secondaryContainer = Color(0xFF454747);
  static const Color onSecondaryContainer = Color(0xFFB4B5B5);

  static const Color tertiary = Color(0xFFC9C6C5);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color background = Color(0xFF0D0D0D); // Deep technical black
}

class AppTheme {
  // Apex Engineering Design System Colors
  static const Color surface = AppColors.surface;
  static const Color surfaceDim = AppColors.surfaceDim;
  static const Color surfaceBright = AppColors.surfaceBright;
  static const Color surfaceContainerLowest = AppColors.surfaceContainerLowest;
  static const Color surfaceContainerLow = AppColors.surfaceContainerLow;
  static const Color surfaceContainer = AppColors.surfaceContainer;
  static const Color surfaceContainerHigh = AppColors.surfaceContainerHigh;
  static const Color surfaceContainerHighest =
      AppColors.surfaceContainerHighest;

  static const Color onSurface = AppColors.onSurface;
  static const Color onSurfaceVariant = AppColors.onSurfaceVariant;

  static const Color outline = AppColors.outline;
  static const Color outlineVariant = AppColors.outlineVariant;

  static const Color primary = AppColors.primary;
  static const Color heatOrange = AppColors.heatOrange;
  static const Color primaryContainer = AppColors.primaryContainer;
  static const Color onPrimary = AppColors.onPrimary;

  static const Color secondary = AppColors.secondary;
  static const Color onSecondary = AppColors.onSecondary;
  static const Color secondaryContainer = AppColors.secondaryContainer;
  static const Color onSecondaryContainer = AppColors.onSecondaryContainer;

  static const Color tertiary = AppColors.tertiary;
  static const Color error = AppColors.error;
  static const Color errorContainer = AppColors.errorContainer;
  static const Color onErrorContainer = AppColors.onErrorContainer;

  static const Color background = AppColors.background;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        error: error,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.sourceSerif4(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: onSurface,
          height: 1.1,
        ),
        headlineMedium: GoogleFonts.sourceSerif4(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleLarge: GoogleFonts.sourceSerif4(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleMedium: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: primary,
          letterSpacing: 1.0,
        ),
        bodyLarge: GoogleFonts.jetBrainsMono(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodySmall: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Colors.black,
        ),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.0,
          color: onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceContainerLowest,
        foregroundColor: primary,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        //shape: const Border(
        //  bottom: BorderSide(color: outlineVariant, width: 1),
        //),
        titleTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: primary,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: outlineVariant, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        color: surfaceContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        labelStyle: GoogleFonts.jetBrainsMono(
          color: onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
        hintStyle: GoogleFonts.jetBrainsMono(color: outline, fontSize: 13),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: outlineVariant, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: outlineVariant, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: heatOrange, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: heatOrange,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 1,
        space: 16,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.black;
          }
          return secondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return heatOrange;
          }
          return surfaceContainerHigh;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(outlineVariant),
      ),
    );
  }

  // Alias lightTheme to darkTheme to maintain compatibility
  static ThemeData get lightTheme => darkTheme;
}
