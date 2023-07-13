import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/models/category/category_model.dart';

const _CategoryDBName = "categoryDB";
late Box<CategoryModel> _categorydb;

abstract class CategoryDBFunctions {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> insertNewCategory(CategoryModel categoryModel);
  //Future<void> deleteCategory(String key);
}

class CategoryDB implements CategoryDBFunctions {
  //@override
  //Future<void> deleteCategory(String key) {
  //  // TODO: implement deleteCategory
  //  throw UnimplementedError();
  //}

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    _categorydb = await Hive.openBox<CategoryModel>(_CategoryDBName);
    return _categorydb.values.toList();
  }

  @override
  Future<void> insertNewCategory(CategoryModel categoryModel) async {
    _categorydb = await Hive.openBox<CategoryModel>(_CategoryDBName);
    _categorydb.add(categoryModel);
  }
}
