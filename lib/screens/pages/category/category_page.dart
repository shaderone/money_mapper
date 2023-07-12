import 'package:flutter/material.dart';

import 'widgets/category_list_widget.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final List<Tab> _tabs = [
    const Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Income"),
          Icon(Icons.trending_up_rounded),
        ],
      ),
    ),
    const Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Expense"),
          Icon(Icons.trending_down_rounded),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: TabBar(
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.grey,
                tabs: _tabs,
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              CategoryListWidget(),
              CategoryListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
