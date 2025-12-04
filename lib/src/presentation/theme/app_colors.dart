import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFFF8F0); 
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFFFF6B00); 
  static const Color accent = Color(0xFF4CAF50);
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color border = Color(0xFFFFE0B2);
  static const Color error = Color(0xFFE53935);
  static BoxShadow softShadow = BoxShadow(
    color: const Color(0xFFFF6B00).withOpacity(0.1),
    offset: const Offset(0, 4),
    blurRadius: 12,
  );
}