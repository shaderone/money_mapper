import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/db/transaction/transaction_db.dart';
import 'package:money_management_app/models/category/category_model.dart';
import 'package:money_management_app/models/transaction/transaction_model.dart';

import '../../../db/category/category_db.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  @override
  void initState() {
    super.initState();
    //default value, else dropdown will throw error because the condition will return false (type is empty at first)
    _selectedCategoryType = CategoryType.income;
    CategoryDB.instance.refreshUI();
  }

  //The value selected from the DatePicker
  DateTime? _selectedDate; // done
  //The value selected from the radio
  CategoryType? _selectedCategoryType; // done
  //The value selected from the dropdown
  CategoryModel? _selectedCategory;

  Object? dropDownValue;

  final FocusNode _dropdownFocusNode = FocusNode();

  final transactionPurposeController = TextEditingController();
  final transactionAmountController = TextEditingController();

  @override
  void dispose() {
    _dropdownFocusNode.dispose();
    super.dispose();
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
              handleNewTransaction();
              Navigator.of(context).pop();
            },
            label: const Text("Done"),
            icon: const Icon(Icons.check_circle_outline_outlined),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: FocusScope(
        node: FocusScopeNode(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Purpose
                TextField(
                  controller: transactionPurposeController,
                  decoration: const InputDecoration(
                    label: Text("Transaction Purpose"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                //Amount
                TextField(
                  controller: transactionAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text("Amount"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                //Category Dropdown
                Focus(
                  focusNode: _dropdownFocusNode,
                  child: DropdownButtonFormField(
                    value: dropDownValue,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Choose Category",
                    ),
                    items: (_selectedCategoryType == CategoryType.income ? CategoryDB.instance.incomeCategoryListNotifier : CategoryDB.instance.expenseCategoryListNotifier).value.map(
                      (category) {
                        return DropdownMenuItem(
                          value: category.key,
                          child: Text(category.categoryName),
                          onTap: () {
                            _selectedCategory = category;
                          },
                        );
                      },
                    ).toList(),
                    onChanged: (newValue) {
                      //value from dropdown

                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                  ),
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
                            _dropdownFocusNode.unfocus();
                            setState(() {
                              dropDownValue = null;
                              _selectedCategoryType = newValue;
                              //To avoid mismatch error, ie; checking the value/item in the dropdown within some other list
                            });
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
                            _dropdownFocusNode.unfocus();
                            setState(() {
                              dropDownValue = null;
                              _selectedCategoryType = newValue;
                            });
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
                        if (date == null) return; // close the popup

                        setState(() {
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

    if (selectedDate == null) return null;
    return selectedDate;
  }

  Future<void> handleNewTransaction() async {
    final purposeText = transactionPurposeController.text;
    final amountText = transactionAmountController.text;

    if (purposeText.isEmpty || amountText.isEmpty || _selectedDate == null || _selectedCategory == null) {
      return;
    }

    final transactionInfo = TransactionModel(
      purpose: purposeText,
      amount: double.parse(amountText),
      date: _selectedDate!,
      transactionCategory: _selectedCategory!,
      categoryType: _selectedCategoryType!,
    );

    TransactionDB.instance.createNewTransaction(transactionInfo);
  }
}
