import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/views/home_page.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/views/ingredients_page.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/views/profile_page.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const IngredientsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05, red: 0 , green: 0, blue: 0), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primary.withOpacity(0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu, color: AppColors.primary),
              label: 'Recetas',
            ),
            NavigationDestination(
              icon: Icon(Icons.kitchen_rounded),
              selectedIcon: Icon(Icons.kitchen_rounded, color: AppColors.primary),
              label: 'Ingredientes',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}