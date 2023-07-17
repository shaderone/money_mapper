import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/models/category/category_model.dart';

const _CategoryDBName = "categoryDB";
late Box<CategoryModel> _categorydb;

abstract class CategoryDBFunctions {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> insertNewCategory(CategoryModel categoryModel);
  Future<void> clearDB();
  //Future<void> deleteCategory(String key);
}

class CategoryDB extends ChangeNotifier implements CategoryDBFunctions {
  /* Creating SingleTon */
  CategoryDB._internal(); // named constructor

  //When the Object `instance` is called the object of CategoryDB._internal() should be returned
  static CategoryDB instance = CategoryDB._internal();

  //when returning the instance of the class we need to make sure that only one object is returned, therefore we use factory method

  factory CategoryDB() {
    return instance;
  }

  final ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier = ValueNotifier([]);
  final ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier = ValueNotifier([]);

  @override
  Future<void> insertNewCategory(CategoryModel categoryModel) async {
    //clear any existing values before displaying, else previous values will be duplicated
    _categorydb = await Hive.openBox<CategoryModel>(_CategoryDBName);
    await _categorydb.add(categoryModel);
    await refreshUI();
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    _categorydb = await Hive.openBox<CategoryModel>(_CategoryDBName);
    return _categorydb.values.toList();
  }

  //We need a sperate function to refresh ui because if we split and add the category data when inserting, it sits in the memory and wont persist on next start
  Future<void> refreshUI() async {
    //data from database
    final categoryList = await getAllCategories();
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();
    //print("clist length - ${categoryList.length}");
    if (categoryList.isNotEmpty) {
      await Future.forEach(categoryList, (category) {
        if (category.type == CategoryType.income) {
          incomeCategoryListNotifier.value.add(category);
        } else {
          expenseCategoryListNotifier.value.add(category);
        }
      });
    }
    //print('incnotifier - ${incomeCategoryListNotifier.value} \n expNotifier - ${expenseCategoryListNotifier.value}');

    incomeCategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }

  @override
  Future<void> clearDB() async {
    _categorydb = await Hive.openBox<CategoryModel>(_CategoryDBName);
    await _categorydb.clear();
    //print("db cleared");
    await refreshUI();
  }
}
