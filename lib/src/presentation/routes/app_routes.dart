import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/views/main_navigation_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/': (_) => const MainNavigationScreen(),
  };
}