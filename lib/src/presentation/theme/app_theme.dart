import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/widgets/app_bar_theme.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/widgets/card_theme.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/widgets/elevated_button_theme.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/widgets/fab_theme.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/widgets/input_decoration_theme.dart';
import 'app_colors.dart';


class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
        surfaceBright: AppColors.background,
      ),

      appBarTheme: ModernAppBarTheme.theme,           
      cardTheme: ModernCardTheme.theme,               
      elevatedButtonTheme: ModernButtonTheme.theme,   
      floatingActionButtonTheme: ModernFabTheme.theme,
      inputDecorationTheme: ModernInputTheme.theme,   
      
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}