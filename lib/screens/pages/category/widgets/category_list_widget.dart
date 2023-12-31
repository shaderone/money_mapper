import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/models/category/category_model.dart';

class CategoryListWidget extends StatelessWidget {
  final List<CategoryModel> categoryList;

  const CategoryListWidget({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return categoryList.isEmpty
        ? const Center(
            child: Text("List is Empty"),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final category = categoryList.reversed.toList()[index];
              return ListTile(
                minVerticalPadding: 20,
                title: Text(category.categoryName),
                trailing: IconButton(
                  onPressed: () {
                    CategoryDB.instance.deleteCategory(category.key);
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox();
            },
            itemCount: categoryList.length,
          );
  }
}
