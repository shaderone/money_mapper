import 'package:flutter/material.dart';
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
            separatorBuilder: (BuildContext context, int index) {
              final category = categoryList[index];
              return ListTile(
                minVerticalPadding: 20,
                title: Text(category.categoryName),
                trailing: IconButton(
                  onPressed: () => print("deleted"),
                  icon: const Icon(Icons.delete),
                ),
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return index == 0 ? const SizedBox() : const Divider(height: 1);
            },
            itemCount: categoryList.length + 1,
          );
  }
}
