import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import 'home_screen.dart';
import 'products_screen.dart';
import 'exchange_screen.dart';
import 'cart_checkout_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToParts: () => _switchTab(1)),
      const ProductsScreen(),
      const ExchangeScreen(),
      const CartCheckoutScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AlEuroColors.darkGray, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _switchTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AlEuroColors.black,
          selectedItemColor: AlEuroColors.ivory,
          unselectedItemColor: AlEuroColors.warmGray,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded, color: AlEuroColors.burgundy),
              label: context.tr('nav_home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view_outlined),
              activeIcon: const Icon(Icons.grid_view_rounded, color: AlEuroColors.burgundy),
              label: context.tr('nav_parts'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.swap_horiz_outlined),
              activeIcon: const Icon(Icons.swap_horiz_rounded, color: AlEuroColors.burgundy),
              label: context.tr('nav_exchange'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag_outlined),
              activeIcon: const Icon(Icons.shopping_bag_rounded, color: AlEuroColors.burgundy),
              label: context.tr('nav_cart'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded, color: AlEuroColors.burgundy),
              label: context.tr('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }
}
