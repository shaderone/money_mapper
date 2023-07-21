import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/models/category/category_model.dart';

import '../../../db/category/category_db.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  //List<CategoryModel> categoryList = [];
  @override
  void initState() {
    super.initState();
    //default value, else dropdown will throw error because the condition will return false (type is empty at first)
    _selectedCategoryType = CategoryType.income;
    //WidgetsBinding.instance.addPostFrameCallback((_) async {
    //  categoryList = await CategoryDB.instance.getAllCategories();
    //});
    //temporary
    CategoryDB.instance.refreshUI();
  }

  //The value selected from the DatePicker
  DateTime? _selectedDate; // done
  //The value selected from the radio
  CategoryType? _selectedCategoryType; // done
  //The value selected from the dropdown
  CategoryModel? _selectedCategory;

  Object? dropDownValue;

  void resetField() {
    //unfocus any selected widget
  }

  @override
  Widget build(BuildContext context) {
    //TODO: purpose, date, category, CategoryType?
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Transaction"),
        leadingWidth: 30,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              //handleNewTransaction();
            },
            label: const Text("Done"),
            icon: const Icon(Icons.check_circle_outline_outlined),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Purpose
              const TextField(
                decoration: InputDecoration(
                  label: Text("Transaction Name"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              //Amount
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text("Amount"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              //Category Dropdown
              DropdownButtonFormField(
                //isExpanded: true,
                value: dropDownValue,
                //hint: const Text("Choose Category"),

                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Choose Category",
                ),
                items: (_selectedCategoryType == CategoryType.income ? CategoryDB.instance.incomeCategoryListNotifier : CategoryDB.instance.expenseCategoryListNotifier).value.map(
                  (category) {
                    print("dropdownValueIN - $dropDownValue value - ${category.key}, ${category.categoryName}");
                    return DropdownMenuItem(
                      value: category.key,
                      child: Text(category.categoryName),
                    );
                  },
                ).toList(),
                onChanged: (newValue) {
                  print(" newvalue - $newValue");
                  setState(() {
                    dropDownValue = newValue;
                  });
                },
              ),

              /* FEATURE 
              Add option to create new category if category is not present or empty 
              */

              const SizedBox(height: 15),
              //Category Type
              //xxx- commented out because since category dropdown items are of type CategoryModel, it will also have its categoryType. we can compare the key of the selected item with the item in the database. xxx
              //uncommented because this enables us to select category having similar Type

              Row(
                children: [
                  Row(
                    children: [
                      const Text("Income"),
                      Radio<CategoryType>(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          //if (newValue == null) return;
                          setState(() {
                            dropDownValue = null;
                            _selectedCategoryType = newValue;
                            //To avoid mismatch error, ie; checking the value/item in the dropdown within some other list
                          });
                          print("dropdown income - $dropDownValue");
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Expense"),
                      Radio<CategoryType>(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          print("dropdown exp  type: $newValue");
                          setState(() {
                            dropDownValue = null;
                            _selectedCategoryType = newValue;
                          });
                          print("dropdown expense - $dropDownValue");
                        },
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final date = await handleDatePicking(context);
                      if (date == null) return;

                      setState(() {
                        //print(date.toString());
                        _selectedDate = date;
                      });
                    },
                    icon: const Icon(Icons.date_range),
                    label: const Text("Pick Date"),
                  ),
                  _selectedDate == null
                      ? const SizedBox()
                      : Chip(
                          label: Text(
                            DateFormat.yMMMd().format(_selectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> handleDatePicking(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    //print(selectedDate.toString());
    if (selectedDate == null) return null;
    return selectedDate;
  }
}
