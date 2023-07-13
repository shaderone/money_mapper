import 'package:flutter/material.dart';
import 'package:money_management_app/models/category/category_model.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({super.key});

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  static final ValueNotifier<CategoryType> selectedCategoryNotifier = ValueNotifier(CategoryType.income);
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();

  String? categoryNameInput;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Category"),
        actions: [
          ElevatedButton.icon(
            onPressed: () => handleNewCategory,
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
                    _NewCategoryPageState.selectedCategoryNotifier.value = CategoryType.income;
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

  void handleNewCategory() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CategoryModel(
        categoryName: categoryNameInput!,
        type: _NewCategoryPageState.selectedCategoryNotifier.value,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added Category '$categoryNameInput'"),
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
          valueListenable: _NewCategoryPageState.selectedCategoryNotifier,
          builder: (BuildContext context, CategoryType type, Widget? _) {
            return Radio<CategoryType>(
              value: categoryType,
              groupValue: type,
              onChanged: (newValue) {
                if (newValue == null) return;
                _NewCategoryPageState.selectedCategoryNotifier.value = newValue;
              },
            );
          },
        ),
      ],
    );
  }
}
