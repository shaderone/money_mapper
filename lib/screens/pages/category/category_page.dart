import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/models/category/category_model.dart';
import 'package:money_management_app/screens/pages/category/widgets/category_list_widget.dart';

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
          body: TabBarView(
            children: [
              //first TabView
              ValueListenableBuilder<List<CategoryModel>>(
                valueListenable: CategoryDB.instance.incomeCategoryListNotifier,
                builder: (BuildContext context, List<CategoryModel> categoryList, Widget? child) {
                  //print("income list - ${categoryList.length}");
                  //for (var index = 0; index < categoryList.length; index++) {
                  //  print("$index) - ${categoryList[index].categoryName} ${categoryList[index].type}");
                  //}
                  return CategoryListWidget(categoryList: categoryList);
                },
              ),

              //Second TabView
              ValueListenableBuilder<List<CategoryModel>>(
                valueListenable: CategoryDB.instance.expenseCategoryListNotifier,
                builder: (BuildContext context, List<CategoryModel> categoryList, Widget? child) {
                  //print("expense list - ${categoryList.length}");
                  return CategoryListWidget(categoryList: categoryList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
