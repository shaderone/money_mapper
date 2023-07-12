import 'package:flutter/material.dart';
import 'package:money_management_app/screens/home/widgets/bottom_nav_bar.dart';
import 'package:money_management_app/screens/pages/category/category_page.dart';
import 'package:money_management_app/screens/pages/transaction/transaction_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);

  final List<String> _title = ['Transaction History', 'Category'];
  final _pages = [
    const TransactionPage(),
    const CategoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: ValueListenableBuilder(
            valueListenable: currentIndexNotifier,
            builder: (BuildContext context, int currentIndex, Widget? _) {
              return Text(_title[currentIndex]);
            }),
      ),
      body: ValueListenableBuilder(
          valueListenable: currentIndexNotifier,
          builder: (BuildContext context, int currentIndex, Widget? _) {
            return _pages[currentIndex];
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add New Transaction',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
