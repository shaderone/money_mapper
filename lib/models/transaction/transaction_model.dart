import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/models/category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel {
  @HiveField(0)
  final String purpose;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final CategoryModel transactionCategory;
  @HiveField(4)
  final CategoryType categoryType;

  TransactionModel({
    required this.purpose,
    required this.amount,
    required this.date,
    required this.transactionCategory,
    required this.categoryType,
  });
}
