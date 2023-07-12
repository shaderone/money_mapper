import 'package:flutter/material.dart';
import 'package:money_management_app/screens/home/home_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HomeScreen.currentIndexNotifier,
        builder: (BuildContext context, int currentIndex, Widget? _) {
          return NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (value) {
              HomeScreen.currentIndexNotifier.value = value;
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.history),
                label: "Home",
              ),
              NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: "Category"),
            ],
          );
        });
  }
}
