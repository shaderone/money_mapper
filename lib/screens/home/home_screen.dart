import 'package:flutter/material.dart';
import 'package:money_management_app/screens/pages/category/category_page.dart';
import 'package:money_management_app/screens/pages/transaction/transaction_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

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
        title: Text(_title[currentIndex]),
      ),
      body: _pages[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add New Transaction',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.history),
            label: "Home",
          ),
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: "Category"),
        ],
      ),
    );
  }
}
