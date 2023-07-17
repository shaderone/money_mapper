import 'package:flutter/material.dart';
import 'package:money_management_app/constants/routes.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/screens/home/widgets/bottom_nav_bar.dart';
import 'package:money_management_app/screens/pages/category/category_page.dart';
import 'package:money_management_app/screens/pages/transaction/transaction_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pages = [
    const TransactionPage(),
    CategoryPage(),
  ];

  @override
  void initState() {
    super.initState();
    CategoryDB.instance.refreshUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: HomeScreen.currentIndexNotifier,
          builder: (BuildContext context, int currentIndex, Widget? _) {
            return _pages[currentIndex];
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (HomeScreen.currentIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(Routes.newTransactionPageRoute);
          } else {
            //CategoryDB.instance.clearDB();
            Navigator.of(context).pushNamed(Routes.newCategoryPageRoute);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
                valueListenable: HomeScreen.currentIndexNotifier,
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
