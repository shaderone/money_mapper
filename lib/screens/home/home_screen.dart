import 'package:flutter/material.dart';
import 'package:money_management_app/screens/home/widgets/bottom_nav_bar.dart';
import 'package:money_management_app/screens/pages/category/category_page.dart';
import 'package:money_management_app/screens/pages/transaction/transaction_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);

  final _pages = [
    const TransactionPage(),
    CategoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: currentIndexNotifier,
          builder: (BuildContext context, int currentIndex, Widget? _) {
            return _pages[currentIndex];
          }),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (currentIndexNotifier.value == 0) {
            print("trans");
          } else {
            print("cats");
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
                valueListenable: currentIndexNotifier,
                builder: (BuildContext context, int currentIndex, Widget? _) {
                  return Text(currentIndex == 0 ? "New Transaction" : "New Category");
                }),
            const Icon(Icons.add),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
