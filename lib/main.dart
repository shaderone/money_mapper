import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/constants/routes.dart';
import 'package:money_management_app/db/transaction/transaction_db.dart';
import 'package:money_management_app/models/category/category_model.dart';
import 'package:money_management_app/models/transaction/transaction_model.dart';
import 'package:money_management_app/screens/home/home_screen.dart';
import 'package:money_management_app/screens/pages/transaction/add_transaction_page.dart';

import 'screens/pages/category/add_category_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //category adapter
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  //enum adapter
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  //transaction adapter
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  await Hive.openBox<TransactionModel>(transactionDBName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Management app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 234, 209, 21)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        Routes.addCategoryPageRoute: (context) => const AddNewCategoryPage(),
        Routes.addTransactionPageRoute: (context) => const AddTransactionPage(),
      },
    );
  }
}
