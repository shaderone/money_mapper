import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/models/transaction/transaction_model.dart';

const transactionDBName = "transactionDB";

abstract class TransactionDBFunctions {
  Future<void> createNewTransaction(TransactionModel transactionInfo);
  Future<List<TransactionModel>> getAllTransaction();
}

class TransactionDB extends ChangeNotifier implements TransactionDBFunctions {
  //Singleton
  TransactionDB.internal();

  static final instance = TransactionDB.internal();

  factory TransactionDB() => instance;

  static ValueNotifier<List<TransactionModel>> transactionListNotifier = ValueNotifier([]);

  @override
  Future<void> createNewTransaction(TransactionModel transactionInfo) async {
    final box = await Hive.openBox<TransactionModel>(transactionDBName);
    await box.add(transactionInfo);
  }

  @override
  Future<List<TransactionModel>> getAllTransaction() async {
    final box = await Hive.openBox<TransactionModel>(transactionDBName);
    return box.values.toList();
  }
}
