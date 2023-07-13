import 'package:hive_flutter/adapters.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String categoryName;
  @HiveField(1)
  final CategoryType type;
  @HiveField(2)
  final bool isDeleted;

  CategoryModel({required this.categoryName, required this.type, this.isDeleted = false});
}
