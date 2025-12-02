import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;

  static const Color primary = Color(0xFF1A1F36);
  static const Color accent = Color(0xFF3D5AFE);

  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF6E7787);
  static const Color border = Color(0xFFE2E8F0);
  static const Color error = Color(0xFFE53935);

  static const BoxShadow softShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.05),
    offset: Offset(0, 4),
    blurRadius: 12,
  );
}