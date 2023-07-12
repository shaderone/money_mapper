import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 20,
      separatorBuilder: (BuildContext context, int index) {
        return ListTile(
          minVerticalPadding: 20,
          title: Text('Tab 1 Item $index'),
          trailing: IconButton(
            onPressed: () => print("deleted"),
            icon: const Icon(Icons.delete),
          ),
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return index == 0 ? const SizedBox() : const Divider(height: 1);
      },
    );
  }
}
