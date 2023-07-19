import 'package:flutter/material.dart';
import 'package:money_management_app/models/category/category_model.dart';

import '../../../db/category/category_db.dart';

final ValueNotifier<CategoryType> selectedCategoryTypeNotifier = ValueNotifier(CategoryType.income);

class AddNewCategoryPage extends StatefulWidget {
  const AddNewCategoryPage({super.key});

  @override
  State<AddNewCategoryPage> createState() => _AddNewCategoryPageState();
}

class _AddNewCategoryPageState extends State<AddNewCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();

  String? categoryNameInput;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Category"),
        leadingWidth: 30,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              handleNewCategory();
            },
            label: const Text("Done"),
            icon: const Icon(Icons.check_circle_outline_outlined),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Category name should not be empty";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    categoryNameInput = value;
                  },
                  onSaved: (newValue) {
                    _categoryNameController.clear();
                  },
                  controller: _categoryNameController,
                  decoration: const InputDecoration(
                    label: Text("Category Name"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    CustomRadioWidget(
                      title: "Income",
                      categoryType: CategoryType.income,
                    ),
                    CustomRadioWidget(
                      title: "Expense",
                      categoryType: CategoryType.expense,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleNewCategory() async {
    //validate inputs
    if (_formKey.currentState!.validate()) {
      //clear input by using onSaved
      _formKey.currentState!.save();

      //parse the details into model
      final categoryModel = CategoryModel(
        categoryName: categoryNameInput!,
        type: selectedCategoryTypeNotifier.value,
      );
      //call insert method to insert new Category into the db
      CategoryDB.instance.insertNewCategory(categoryModel);
      //go back
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added Category '$categoryNameInput'"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          action: SnackBarAction(
            label: "OK",
            onPressed: () {},
          ),
        ),
      );
    }
  }
}

class CustomRadioWidget extends StatelessWidget {
  final String title;
  final CategoryType categoryType;

  const CustomRadioWidget({
    super.key,
    required this.title,
    required this.categoryType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        ValueListenableBuilder(
          valueListenable: selectedCategoryTypeNotifier,
          builder: (BuildContext context, CategoryType type, Widget? _) {
            return Radio<CategoryType>(
              value: categoryType,
              groupValue: type,
              onChanged: (newValue) {
                if (newValue == null) return;
                selectedCategoryTypeNotifier.value = newValue;
              },
            );
          },
        ),
      ],
    );
  }
}
