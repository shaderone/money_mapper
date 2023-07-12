import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final List<Tab> _tabs = [
    const Tab(text: 'Income'),
    const Tab(text: 'Expense'),
    //Tab(text: 'Tab 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: TabBar(
                tabs: _tabs,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ListTile(
                          title: Text('Tab 1 Item $index'),
                        );
                      },
                      childCount: 20,
                    ),
                  ),
                ],
              ),
              const Center(
                child: Text('Content for Tab 2'),
              ),
              //const Center(
              //  child: Text('Content for Tab 3'),
              //),
            ],
          ),
        ),
      ),
    );
  }
}
