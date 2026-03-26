import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.manropeTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      textTheme: baseTextTheme.apply(
        bodyColor: AppColors.white,
        displayColor: AppColors.white,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.white),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.toggleGreen;
          }
          return AppColors.white.withValues(alpha: 0.3);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.buttonTextBlue,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          textStyle: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        surface: AppColors.black,
      ),
    );
  }
}
